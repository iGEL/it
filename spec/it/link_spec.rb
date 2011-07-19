# encoding: UTF-8

require 'spec_helper'
require 'it'

describe It::Link, '.new' do
  it "should accept a String as frist param" do
    expect { It::Link.new("http://www.rubyonrails.org/") }.not_to raise_error
  end
  
  it "should accept a Hash as first param" do
    expect { It::Link.new({:controller => "articles", :action => "index"}) }.not_to raise_error
  end
  
  it "should raise a TypeError if the first param is an Integer" do
    expect { It::Link.new(1) }.to raise_error(TypeError)
  end
  
  it "should accept options as a Hash" do
    expect { It::Link.new("http://www.rubyonrails.org/", {:id => "identity", :class => "classy"}) }.not_to raise_error
  end
  
  it "should raise a TypeError, if the options are a String" do
    expect { It::Link.new("http://www.rubyonrails.org/", "classy") }.to raise_error(TypeError)
  end
  
  it "should raise ArgumentError, if called with three params" do
    expect { It::Link.new("http://www.rubyonrails.org/", {}, :blubb) }.to raise_error(ArgumentError)
  end
end

describe It::Link, '#tag' do
  it "should always return a" do
    It::Link.new("http://www.rubyonrails.org/").tag.should == :a
  end
end