require 'spec_helper'
require 'it'

describe It::Plain, '.new' do
  it "should work with no params" do
    expect { It::Plain.new }.not_to raise_error
  end
  
  it "should work with a String" do
    expect { It::Plain.new("%s[http://www.rubyonrails.org]") }.not_to raise_error
  end
  
  it "should raise ArgumentError with 2 params" do
    expect { It::Plain.new("asdf", "asdf")}.to raise_error(ArgumentError, "wrong number of arguments (2 for 1)")
  end
  
  it "should raise a TypeError, if the first param is not a String" do
    expect { It::Plain.new(1)}.to raise_error(TypeError)
  end
end

describe It::Plain, '#process' do
  it "should return 'Ruby on Rails', if no param was given" do
    expect(It::Plain.new.process("Ruby on Rails")).to eq('Ruby on Rails')
  end
  
  it "should return 'Ruby on Rails[http://www.rubyonrails.org/]'" do
    expect(It::Plain.new("%s[http://www.rubyonrails.org/]").process("Ruby on Rails")).to eq('Ruby on Rails[http://www.rubyonrails.org/]')
  end
end
