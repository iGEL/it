$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/../lib")

require 'action_pack'
require 'action_controller'
require 'action_view'
require 'coveralls'
require_relative 'support/eq_html'

Coveralls.wear!

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.after(:example) do
    I18n.locale = :en
    I18n.default_locale = :en
    I18n.available_locales = nil
    I18n.backend = nil
    I18n.default_separator = nil
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.disable_monkey_patching!

  config.warnings = true

  config.order = :random
  Kernel.srand config.seed
end
