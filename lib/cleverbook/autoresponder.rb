require 'xmpp4r_facebook'
require 'cleverbot'

module Cleverbook
  class Autoresponder

    include Methadone::Main
    include Methadone::CLILogging
    include Jabber

    def self.build_client(user_id, app_id, access_token, app_secret)
      info "Builing Jabber client"
      debug "USERID: #{user_id}"
      debug "APPID: #{app_id}"
      debug "APP SECRET: #{app_secret}"
      debug "ACCESS TOKEN: #{access_token}"

      jabber_id = "#{user_id}@chat.facebook.com"
      debug "JABBERID: #{jabber_id}"

      begin
        client = Jabber::Client.new Jabber::JID.new(jabber_id)
        client.connect
        client.auth_sasl(Jabber::SASL::XFacebookPlatform.new(client, app_id, access_token, app_secret), nil)
        client
      rescue => e
        warn "Failed to build Jabber client"
        debug "USERID: #{user_id}"
        debug "APPID: #{app_id}"
        debug "APP SECRET: #{app_secret}"
        debug "ACCESS TOKEN: #{access_token}"
        debug "JABBERID: #{jabber_id}"
        error "#{e}"
      end
    end

    def self.send_message(client, message)
      info "Sending xmpp message"
      debug "MESSAGE: #{message}"

      begin
        client.send message
        client
      rescue => e
        warn "Failed to send xmpp message"
        debug "CLIENT: #{client.to_s}"
        debug "MESSAGE: #{message}"
        error "#{e}"
      end
    end

    def self.close_client(client)
      client.close
    end

    def self.build_message_bot(id_string, to_string, incoming_message, params = {})
      if params.nil?
        params = {}
      end
      id = "#{id_string}@chat.facebook.com"
      # to = "#{to_string}@chat.facebook.com"
      to = to_string
      params = get_response_from_cleverbot(incoming_message, params)
      body = params["message"]
      # Psuedo-randomn anti-signature goodness in the subject
      subject = "Droid Message ID: #{((0...12).map { (65 + rand(26)).chr }.join).downcase}"
      message = Jabber::Message.new to, body
      message.subject = subject
      return message, params
    end

    def self.build_message_script(id_string, to_string, incoming_message, params = {})
      if params.nil?
        params = {}
      end
      id = "#{id_string}@chat.facebook.com"
      to = to_string
      response = get_response_from_script(incoming_message)
      body = response
      # Psuedo-randomn anti-signature goodness in the subject
      subject = "Droid Message ID: #{((0...12).map { (65 + rand(26)).chr }.join).downcase}"
      message = Jabber::Message.new to, body
      message.subject = subject
      return message
    end

    def self.get_response_from_script(input)
      cb = Cleverbook::ChatBot.new("default.yml", "quotes")
      response = cb.get_response input
      response.is_a?(String) ? response : response.text
    end

    def self.get_response_from_cleverbot(my_message, params = {})
      @params = Cleverbot::Client.write my_message, params
      # response = @params["message"]
    end

    def self.replace_words_in_response(response, profile, options = {})
      # TODO: Load replacement words into options hash from a yml config file
      
      options["cleverbot"] = profile["first_name"]

      # Regex replace case-insensitive Hash key with hash value
      options.each { |k, v| response.gsub!(/#{k}/i, v) }
      response
    end

    def self.run_bot_only_response_thread(cl, id_string)
      # Get all responses from cleverbot
      jabber_id = "#{id_string}@chat.facebook.com"

      Jabber::debug = true
      convo = {}

      cl.send(Presence.new)
      puts "Connected ! send messages to #{jabber_id}."
      mainthread = Thread.current
      cl.add_message_callback do |m|
        if m.type != :error
          if m.body == 'exit'
            m2 = Message.new(m.from, "Exiting ...")
            m2.type = m.type
            cl.send(m2)
            mainthread.wakeup
          end
          m2, convo[m.from] = build_message_bot(id_string, m.from, m.body, convo[m.from])
          m2.type = m.type
          cl.send(m2) unless m.body.nil?
        end
      end
      Thread.stop
      cl.close
    end

    def self.run_script_bot_mix_response_thread(cl, id_string)
      # Get responses from a YAML config file. If suitable response isn't found we get one
      # from cleverbot
      jabber_id = "#{id_string}@chat.facebook.com"

      Jabber::debug = true
      convo = {}

      cl.send(Presence.new)
      puts "Connected ! send messages to #{jabber_id}."
      mainthread = Thread.current
      cl.add_message_callback do |m|
        if m.type != :error
          if m.body == 'exit'
            m2 = Message.new(m.from, "Exiting ...")
            m2.type = m.type
            cl.send(m2)
            mainthread.wakeup
          end          
          m2 = build_message_script(id_string, m.from, m.body)
          m2.type = m.type
          cl.send(m2) unless m.body.nil?
        end
      end
      Thread.stop
      cl.close
    end

  end
end