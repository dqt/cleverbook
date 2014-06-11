module Cleverbook
  class ChatBot
    def initialize(filename = File.dirname(__FILE__) + "/../default.yml" , quotes_filename = "quotes")
      unless File.exists? quotes_filename
        f = File.new(quotes_filename,"w")
        f.close
      end
      @loader = Cleverbook::Aiml.new
      @loader.load(filename)
      @responser = Cleverbook::Responser.new(@loader,quotes_filename)
    end
    def get_response(s)
      @responser.response s
    end
  end
end