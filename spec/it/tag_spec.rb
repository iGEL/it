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
    expect { It::Tag.new(:b, class: "very_bold") }.not_to raise_error
  end
  
  it "should raise a TypeError if called with a String" do
    expect { It::Tag.new(:b, "very_bold") }.to raise_error(TypeError)
  end
  
  it "should raise an ArgumentError if called with three params" do
    expect { It::Tag.new(:b, {}, :blubb) }.to raise_error(ArgumentError)
  end
end

describe It::Tag, '#tag' do
  it "should return the tag as a Symbol if given as a Symbol" do
    It::Tag.new(:i).tag.should == :i
  end
  
  it "should return the tag as a Symbol if given as a String" do
    It::Tag.new("i").tag.should == :i
  end
end

describe It::Tag, '#options' do
  it "should return the options with symbolized keys" do
    It::Tag.new(:i, "id" => "cool", :class => "classy").options.should == {id: "cool", class: "classy"}
  end
end