require 'koala'
require 'capybara'
require 'capybara/poltergeist'
require 'selenium-webdriver'

module Facegang
  class FacebookMacros

    include Methadone::Main
    include Methadone::CLILogging

    def self.install_app_get_token(config)
      # install facebook application when dialogue requires two clicks on okay
      session = Hash.new # Koala session
      session = get_auth_url(config, session)
      install_app(config, session[:auth_url])
      session = Hash.new # Second Koala session for weird facebook auth problem
      session = get_auth_url(config, session)
      code = get_code(config, session[:auth_url])
      session = get_access_token(session, code)
    end

    def self.already_installed_get_token(config)
      # Facebook app has already been installed, just get access token
      session = Hash.new # Kola session
      session = get_auth_url(config, session)
      code = get_code(config, session[:auth_url])
      session = get_access_token(session, code)
    end

    def self.get_auth_url(config, session)
      begin
        debug "Starting get_auth facebook macro"

        session[:oauth] = Koala::Facebook::OAuth.new(config["app_id"], config["app_secret"], config["site_url"])

        session[:auth_url] = session[:oauth].url_for_oauth_code(:permissions=>["read_mailbox", "xmpp_login"])
        session
      rescue => e
        warn "Failed to retrieve authorization url!"
        debug "APP ID: #{config["app_id"]}"
        debug "APP SECRET: #{config["app_secret"]}"
        debug "SITE URL: #{config["site_url"]}"
        error "#{e}"
      end
    end

    def self.install_app(config, auth_url)
      begin
        debug "Starting install_app facebook macro"

        session = nil
        session = Capybara::Session.new(:poltergeist)
        debug "Session created"

        session.visit auth_url
        debug "Visited #{auth_url}"
        sleep 2

        session.fill_in('email', :with => config["email"])
        debug "Filled in email with #{config["email"]}"
        sleep 1

        session.fill_in('pass', :with => config["password"])
        debug "Filled in password with #{config["password"]}"
        sleep 1

        session.find('#loginbutton').click
        debug "Clicked login button"
        sleep 5

        session.find(:xpath, "//button[@name='__CONFIRM__']").click
        debug "Clicked first okay"
        sleep 2

        session.find(:xpath, "//button[@name='__CONFIRM__']").click
        debug "Clicked second okay"
        sleep 1

        debug "App installed successfully"
      rescue => e
        warn "App install failed, It's probably already installed! Skipping..."
        debug "EMAIL: #{config["email"]}"
        debug "PASSWORD #{config["password"]}"
        warn "#{e}"
      end
    end

    def self.get_code(config, auth_url)
      # TODO: Get access code with regex instead to account for variable site_url
      begin
        debug "Starting get_code facebook macro"

        session = nil
        session = Capybara::Session.new(:selenium)
        debug "Session created"

        session.visit auth_url
        debug "Visited #{auth_url}"
        sleep 2

        session.fill_in('email', :with => config["email"])
        debug "Filled in email with #{config["email"]}"
        sleep 1

        session.fill_in('pass', :with => config["password"])
        debug "Filled in password with #{config["password"]}"
        sleep 1

        session.find('#loginbutton').click
        debug "Logged in successfully, getting code from redirect"
        sleep 2

        url = session.current_url
        debug "REDIRECT URL: #{url}"
        debug "ACCESS CODE: #{url[28..-5]}" # Given site_url = "http://127.0.0.1:8080/"

        # session.driver.browser.quit

        url[28..-5] # Replace with regex
      rescue => e
        warn "Failed to get code required for access token!"
        error "#{e}"
      end
    end

    def self.get_access_token(session, code)
      begin
        debug "Starting get_access_token facebook macro"

        session[:access_token] = session[:oauth].get_access_token(code)
        session
      rescue => e
        warn "Failed to retrieve facebook access token"
        error "#{e}"
      end
    end
  end
end
