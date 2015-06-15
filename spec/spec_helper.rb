require 'rspec'
require 'action_pack'
require 'action_controller'
require 'action_view'
require 'coveralls'

require_relative 'support/eq_html'

Coveralls.wear!

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib')

RSpec.configure do |config|
  config.expect_with :rspec do |expect|
    expect.syntax = :expect
  end

  config.mock_with :rspec do |mock|
    mock.syntax = :expect
    mock.verify_partial_doubles = true
  end
end
