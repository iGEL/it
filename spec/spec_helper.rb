require 'rspec'
require 'action_pack'
require 'action_controller'
require 'action_view'
require 'coveralls'

require_relative 'support/eq_html'

Coveralls.wear!

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib')

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.mock_with :rspec do |c|
    c.syntax = :expect
  end
end
