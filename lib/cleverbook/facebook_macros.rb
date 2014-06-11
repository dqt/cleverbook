require 'koala'
require 'capybara'
require 'capybara/poltergeist'
require 'selenium-webdriver'

module Cleverbook
  class FacebookMacros
    include Methadone::Main
    include Methadone::CLILogging

    def initialize(config, params = {})
      @config = config
      @params = params
      @session = Hash.new
      @code = nil
    end

    attr_reader :config, :params
    attr_accessor :session, :code, :graph

    def install_app_get_token
      # install facebook application when dialogue requires two clicks on okay
      get_auth_url
      install_app
      get_auth_url    # Second browser session for weird wuth problem
      get_code
      get_access_token
    end

    def already_installed_get_token
      # Facebook app has already been installed, just get access token
      get_auth_url
      get_code
      get_access_token
    end

    def get_graph
      @graph = Koala::Facebook::API.new(@session[:access_token])
    end

    def get_my_profile
=begin
  {
    "id": "629666774",
    "first_name": "Sadie",
    "gender": "female",
    "last_name": "Pinn",
    "link": "http://www.facebook.com/629666774",
    "locale": "en_US",
    "name": "Sadie Pinn",
    "timezone": -4,
    "updated_time": "2013-10-08T20:51:04+0000",
    "verified": true
  }
=end
      @graph.get_object("me")
    end

    protected

    def get_auth_url
      begin
        debug "Starting get_auth facebook macro"
        @session[:oauth] = Koala::Facebook::OAuth.new(@config["app_id"], @config["app_secret"], @config["site_url"])
        @session[:auth_url] = session[:oauth].url_for_oauth_code(:permissions=>["read_mailbox", "xmpp_login"])
      rescue => e
        warn "Failed to retrieve authorization url!"
        debug "APP ID: #{@config["app_id"]}"
        debug "APP SECRET: #{@config["app_secret"]}"
        debug "SITE URL: #{@config["site_url"]}"
        error "#{e}"
      end
    end

    def install_app
      begin
        debug "Starting install_app facebook macro"

        browser = nil
        browser = Capybara::Session.new(:poltergeist)
        debug "Session created"

        browser.visit @session[:auth_url]
        debug "Visited #{@session[:auth_url]}"
        sleep 2

        browser.fill_in('email', :with => @config["email"])
        debug "Filled in email with #{config["email"]}"
        sleep 1

        browser.fill_in('pass', :with => @config["password"])
        debug "Filled in password with #{config["password"]}"
        sleep 1

        browser.find('#loginbutton').click
        debug "Clicked login button"
        sleep 5

        browser.find(:xpath, "//button[@name='__CONFIRM__']").click
        debug "Clicked first okay"
        sleep 2

        browser.find(:xpath, "//button[@name='__CONFIRM__']").click
        debug "Clicked second okay"
        sleep 1

        debug "App installed successfully"
      rescue => e
        warn "App install failed, It's probably already installed! Skipping..."
        debug "EMAIL: #{@config["email"]}"
        debug "PASSWORD #{@config["password"]}"
        warn "#{e}"
      end
    end

    def get_code
      # TODO: Get access code with regex instead to account for variable site_url
      begin
        debug "Starting get_code facebook macro"

        browser = nil
        browser = Capybara::Session.new(:selenium)
        debug "Session created"

        browser.visit @session[:auth_url]
        debug "Visited #{@session[:auth_url]}"
        sleep 2

        browser.fill_in('email', :with => @config["email"])
        debug "Filled in email with #{@config["email"]}"
        sleep 1

        browser.fill_in('pass', :with => config["password"])
        debug "Filled in password with #{@config["password"]}"
        sleep 1

        browser.find('#loginbutton').click
        debug "Logged in successfully, getting code from redirect"
        sleep 2

        url = browser.current_url
        debug "REDIRECT URL: #{url}"
        debug "ACCESS CODE: #{url[28..-5]}" # Given site_url = "http://127.0.0.1:8080/"

        browser.driver.browser.quit

        @code = url[28..-5] # Replace with regex
      rescue => e
        warn "Failed to get code required for access token!"
        error "#{e}"
      end
    end

    def get_access_token
      begin
        debug "Starting get_access_token facebook macro"
        @session[:access_token] = @session[:oauth].get_access_token(@code)
      rescue => e
        warn "Failed to retrieve facebook access token"
        error "#{e}"
      end
    end
  end
end
