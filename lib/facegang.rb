require "facegang/version"
require "facegang/facebook_macros"

module Facegang
  def self.install_app_get_token
    # install facebook application when dialogue requires two clicks on okay
    session = Hash.new # Koala session
    session = FacebookMacros.get_auth_url(config, session)
    FacebookMacros.install_app(config, session[:auth_url])
    session = Hash.new # Second Koala session for weird facebook auth problem
    session = FacebookMacros.get_auth_url(config, session)
    code = FacebookMacros.get_code(config, session[:auth_url])
    session = FacebookMacros.get_access_token(session, code)
  end
end
