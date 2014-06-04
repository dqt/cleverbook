Feature: Autorespond to Facebook messages
  In order to drive horny men to a cam whore landing page
  I want to automatically respond to Facebook messages
  So I don't have to see any dicks

  Scenario: Basic UI
    When I get help for "facegang"
    Then the exit status should be 0
    And the banner should be present
    And the banner should document that this app takes options
    And the banner should document that this app's arguments are:
        |config_file|which is required|
    And there should be a description of what the app does

  Scenario: Load configuration
    Given a configuration file exists at "config.yaml"
    When I successfully run "facegang config.yaml"
    Then the configuration file "config.yaml" should be loaded into a config Hash
    And the config Hash should contain app_id
    And the config Hash should contain app_secret
    And the config Hash should contain site_url
    And the config Hash should contain my_id
    And the config Hash should contain email
    And the config Hash should contain password
