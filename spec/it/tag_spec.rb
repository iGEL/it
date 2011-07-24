# encoding: UTF-8

require 'spec_helper'
require 'it'

describe It::Tag, '.new' do
  it "should work with a parameter (Symbol)" do
    expect { It::Tag.new(:b) }.not_to raise_error
  end
  
  it "should work with a paramter (String)" do
    expect { It::Tag.new("b") }.not_to raise_error
  end
  
  it "should raise TypeError if called with an Integer" do
    expect { It::Tag.new(1) }.to raise_error(TypeError)
  end
  
  it "should accept an options Hash" do
    expect { It::Tag.new(:b, :class => "very_bold") }.not_to raise_error
  end
  
  it "should raise a TypeError if called with a String" do
    expect { It::Tag.new(:b, "very_bold") }.to raise_error(TypeError)
  end
  
  it "should raise an ArgumentError if called with three params" do
    expect { It::Tag.new(:b, {}, :blubb) }.to raise_error(ArgumentError)
  end
end

describe It::Tag, '#tag_name' do
  it "should return the tag as a Symbol if given as a Symbol" do
    It::Tag.new(:i).tag_name.should == :i
  end
  
  it "should return the tag_name as a Symbol if given as a String" do
    It::Tag.new("i").tag_name.should == :i
  end
end

describe It::Tag, '#options' do
  it "should return the options with symbolized keys" do
    It::Tag.new(:i, "id" => "cool", :class => "classy").options.should == {:id => "cool", :class => "classy"}
  end
end

describe It::Tag, '#process' do
  it "should return a tag with the options as attributes and the param as content" do
    It::Tag.new(:i, "id" => "cool", "class" => "classy").process("some text").should == '<i class="classy" id="cool">some text</i>'
  end
  
  it "should be marked as html safe" do
    It::Tag.new(:i).process("some text").html_safe.should be_true
  end
  
  it "should escape HTML" do
    It::Tag.new(:i).process("some text & <b>html</b>").should == '<i>some text &amp; &lt;b&gt;html&lt;/b&gt;</i>'
  end
  
  it "should not escape strings marked as HTML safe" do
    It::Tag.new(:i).process("some text & <b>html</b>".html_safe).should == '<i>some text & <b>html</b></i>'
  end
  
  it "should return an empty tag, if no content is provided" do
    It::Tag.new(:br, "id" => "cool").process.should == '<br id="cool" />'
  end
end