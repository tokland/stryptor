require 'capybara'
require 'database_cleaner'
require 'capybara/dsl'
require 'capybara/webkit'
require 'capybara/poltergeist'
require 'rack_session_access/capybara'
require 'rails_helper'

Capybara.configure do |config|
  config.javascript_driver = (ENV["CAPYBARA_DRIVER"] || :webkit).to_sym
  config.server_host = "localhost"
  #config.server_port = 30000
  #config.app_host = "stryptor.herokuapp.com"
end

Capybara::Webkit.configure do |config|
  config.block_unknown_urls
end

module ExpectOneLinerSyntax
  def expects(*args)
    expect(*args)
  end
end

RSpec.configure do |config|
  config.include Rails.application.routes.url_helpers
  config.include Capybara::DSL
  
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  
  config.include ExpectOneLinerSyntax
end

RSpec::Matchers.define :be_in do |expected|
  match do |actual|
    expected.include?(actual)
  end
  
  failure_message do |actual|
    "expected that #{actual} would be one value of #{expected}"
  end
end
