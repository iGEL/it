require 'rspec'
require 'action_pack'
require 'action_controller'
require 'action_view'
require 'coveralls'

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

# Unfortunately, Rails 4.2 renders the attributes of generated links in the
# reverse order of Rails 4.1 and below. Also, assert_dom_equal was extracted
# to a gem which requires Rails 4.2 or higher, so I decided to go this way.
def attributes_forward_and_backwards_regex_fragment(*attrs)
  '(' + [attrs.join(' '), attrs.reverse.join(' ')].join('|') + ')'
end
