require 'xmpp4r_facebook'
require 'cleverbot'

module Facegang
  class Autoresponder

    include Methadone::Main
    include Methadone::CLILogging

    def self.build_message_bot(id_string, to_string, incoming_message, @params)
      id = "#{id_string}@chat.facebook.com"
      to = "#{to_string}@chat.facebook.com"
      body = get_response_from_cleverbot(incoming_message, @params)
      subject = "hello my dear"
      message = Jabber::Message.new to, body
      message.subject = subject
      message
    end

    def self.get_response_from_cleverbot(my_message)
      @params = Cleverbot::Client.write 'Hi.'
      @params = Cleverbot::Client.write 'Good, you?', @params
    end

  end
end