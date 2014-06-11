require "cleverbook/version"
require "cleverbook/facebook_macros"
require "cleverbook/autoresponder"
require "cleverbook/script/aiml"
require "cleverbook/script/responser"
require "cleverbook/chat_bot"

module Cleverbook
  class << self
    include Methadone::Main
    include Methadone::CLILogging
    include Cleverbook
    
    # Factor out the app install into it's own tool

    def install_app_start_cb_autoresponder(config)
    # Install facebook app and start cleverbot autoresponder
      begin
        # Install facebook app, get access token to start responder
        info "Installing facebook app and getting token"
        @fb = FacebookMacros.new(config)
        @fb.install_app_get_token
        info "ACCESS TOKEN GRANTED: #{@fb.session[:access_token]}"

        # Use Graph API to get our users profile
        info "Polling Graph API for profile data"
        @fb.get_graph
        @profile = @fb.get_my_profile
        debug "PROFILE: #{@profile.to_s}"
        info "Starting autoresponder..."

        # Build new client
        @ar = Autoresponder.new(@profile, config["app_id"], @fb.session[:access_token], config["app_secret"])
        @ar.build_client
        # Run message call back thread
        @ar.run_bot_only_response_thread
      rescue => e
        error "#{e}"
      end
    end

    def start_cb_autoresponder(config)
    # Skip app install, just get access token and start cleverbot responder
      begin
        # Install facebook app, get access token to start responder
        info "Installing facebook app and getting token"
        @fb = FacebookMacros.new(config)
        @fb.already_installed_get_token
        info "ACCESS TOKEN GRANTED: #{@fb.session[:access_token]}"

        # Use Graph API to get our users profile
        info "Polling Graph API for profile data"
        @fb.get_graph
        @profile = @fb.get_my_profile
        debug "PROFILE: #{@profile.to_s}"
        info "Starting autoresponder..."

        # Build new client
        @ar = Autoresponder.new(@profile, config["app_id"], @fb.session[:access_token], config["app_secret"])
        @ar.build_client
        # Run message call back thread
        @ar.run_bot_only_response_thread
      rescue => e
        error "#{e}"
      end
    end

    def install_app_start_scripted_autoresponder(config)
    # Install facebook app and start cleverbot autoresponder
      begin
        # Install facebook app, get access token to start responder
        info "Installing facebook app and getting token"
        @fb = FacebookMacros.new(config)
        @fb.install_app_get_token
        info "ACCESS TOKEN GRANTED: #{@fb.session[:access_token]}"

        # Use Graph API to get our users profile
        info "Polling Graph API for profile data"
        @fb.get_graph
        @profile = @fb.get_my_profile
        debug "PROFILE: #{@profile.to_s}"
        info "Starting autoresponder..."

        # Build new client
        @ar = Autoresponder.new(@profile, config["app_id"], @fb.session[:access_token], config["app_secret"])
        @ar.build_client
        # Run message call back thread
        @ar.run_script_bot_mix_response_thread
      rescue => e
        error "#{e}"
      end
    end

    def start_scripted_autoresponder(config)
    # Skip app install, just get access token and start cleverbot responder
      begin
        # Install facebook app, get access token to start responder
        info "Installing facebook app and getting token"
        @fb = FacebookMacros.new(config)
        @fb.already_installed_get_token
        info "ACCESS TOKEN GRANTED: #{@fb.session[:access_token]}"

        # Use Graph API to get our users profile
        info "Polling Graph API for profile data"
        @fb.get_graph
        @profile = @fb.get_my_profile
        debug "PROFILE: #{@profile.to_s}"
        info "Starting autoresponder..."

        # Build new client
        @ar = Autoresponder.new(@profile, config["app_id"], @fb.session[:access_token], config["app_secret"])
        @ar.build_client
        # Run message call back thread
        @ar.run_script_bot_mix_response_thread
      rescue => e
        error "#{e}"
      end
    end
  end
end
