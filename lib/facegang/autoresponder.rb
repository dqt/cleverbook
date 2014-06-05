require 'xmpp4r_facebook'
require 'cleverbot'

module Facegang
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
      id = "#{id_string}@chat.facebook.com"
      to = "#{to_string}@chat.facebook.com"
      body = get_response_from_cleverbot(incoming_message, params)
      # Psuedo-randomn anti-signature goodnes in the subject
      subject = "Droid Message ID: #{((0...12).map { (65 + rand(26)).chr }.join).downcase}"
      message = Jabber::Message.new to, body
      message.subject = subject
      message
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

    def self.run_response_thread(cl)
      jabber_id = "100008395922337@chat.facebook.com"

      Jabber::debug = true

      cl.send(Presence.new)
      puts "Connected ! send messages to #{jabber_id}."
      mainthread = Thread.current
      cl.add_message_callback do |m|
        if m.type != :error
          puts m.class
          puts m.to_s
          puts m.type.to_s
          m2 = Message.new(m.from, "You sent: #{m.body}")
          m2.type = m.type
          cl.send(m2) unless m.body.nil?
          if m.body == 'exit'
            m2 = Message.new(m.from, "Exiting ...")
            m2.type = m.type
            cl.send(m2)
            mainthread.wakeup
          end
        end
      end
      Thread.stop
      cl.close
    end

  end
end