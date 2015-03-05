require 'nokogiri'

RSpec::Matchers.define :eq_html do |expected|
  match do |actual|
    Nokogiri::HTML::Document.new(expected).root == Nokogiri::HTML::Document.new(actual).root
  end

  failure_message do |actual|
    "Expected the same HTML as \n  #{expected}\n but got \n  #{actual}"
  end

  failure_message_when_negated do |actual|
    "Expected a different HTML than #{expected}"
  end
end
