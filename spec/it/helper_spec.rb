# encoding: UTF-8

require 'spec_helper'
require 'it'

describe It::Helper, "#it" do
  before do
    I18n.backend.store_translations(:en, :test1 => "I'm containing a %{link:link to Rails} in the middle.")
    I18n.backend.store_translations(:de, :test1 => "Ich enthalte einen %{link:Link zu Rails} in der Mitte.")
    
    @view = ActionView::Base.new
    @controller = ActionController::Base.new
    @view.controller = @controller
  end
  
  after do
    I18n.locale = :en
  end
  
  it "should insert the link into the string" do
    @view.it("test1", :link => It.link("http://www.rubyonrails.org")).should == 'I\'m containing a <a href="http://www.rubyonrails.org">link to Rails</a> in the middle.'
  end
  
  it "should insert the link into the German translation" do
    I18n.locale = :de
    @view.it("test1", :link => It.link("http://www.rubyonrails.org")).should == 'Ich enthalte einen <a href="http://www.rubyonrails.org">Link zu Rails</a> in der Mitte.'
  end
  
  it "should allow link options to be set" do
    @view.it("test1", :link => It.link("http://www.rubyonrails.org", :target => "_blank")).should == 'I\'m containing a <a href="http://www.rubyonrails.org" target="_blank">link to Rails</a> in the middle.'
  end
  
  it "should parse other tags as well" do
    @view.it("test1", :link => It.tag(:b, :class => "classy")).should == 'I\'m containing a <b class="classy">link to Rails</b> in the middle.'
  end
  
  it "should mark the result as html safe" do
    @view.it("test1", :link => It.link("http://www.rubyonrails.org")).html_safe?.should be_true
  end
  
  it "should escape all html in the translation" do
    I18n.backend.store_translations(:en, :test2 => "<a href=\"hax0r\"> & %{link:link -> Rails} in <b>the middle</b>.")
    @view.it("test2", :link => It.link("http://www.rubyonrails.org")).should == '&lt;a href=&quot;hax0r&quot;&gt; &amp; <a href="http://www.rubyonrails.org">link -&gt; Rails</a> in &lt;b&gt;the middle&lt;/b&gt;.'
  end
  
  it "should also work with 2 links" do
    I18n.backend.store_translations(:en, :test3 => "I like %{link1:rails} and %{link2:github}.")
    @view.it("test3", :link1 => It.link("http://www.rubyonrails.org"), :link2 => It.link("http://www.github.com")).should == 'I like <a href="http://www.rubyonrails.org">rails</a> and <a href="http://www.github.com">github</a>.'
  end
  
  it "should allow normal I18n interpolations" do
    I18n.backend.store_translations(:en, :test4 => "I'm containing a %{link:link to Rails} in the %{position}.")
    @view.it("test4", :link => It.link("http://www.rubyonrails.org"), :position => "middle").should == 'I\'m containing a <a href="http://www.rubyonrails.org">link to Rails</a> in the middle.'
  end
  
  it "should allow Intergers as normal interpolation" do
    I18n.backend.store_translations(:en, :test5 => "Hello %{name}.")
    @view.it("test5", :name => 2).should == 'Hello 2.'
  end
  
  it "should escape the HTML in normal interpolations" do
    I18n.backend.store_translations(:en, :test5 => "Hello %{name}.")
    @view.it("test5", :name => '<a href="http://evil.haxor.com">victim</a>').should == 'Hello &lt;a href=&quot;http://evil.haxor.com&quot;&gt;victim&lt;/a&gt;.'
  end
  
  it "should not escape html_safe interpolations" do
    I18n.backend.store_translations(:en, :test5 => "Hello %{name}.")
    @view.it("test5", :name => '<a href="http://www.rubyonrails.org">Rails</a>'.html_safe).should == 'Hello <a href="http://www.rubyonrails.org">Rails</a>.'
  end
  
  it "should allow interpolations inside of links" do
    I18n.backend.store_translations(:en, :test6 => "Did you read our %{link:nice %{article}}?")
    @view.it("test6", :link => It.link("/article/2"), :article => "article").should == 'Did you read our <a href="/article/2">nice article</a>?'
  end
  
  it "should raise a KeyError, if the key was not given" do
    expect { @view.it("test1", :blubb => true) }.to raise_error(KeyError, "key{link} not found")
  end
  
  it "should raise an ArgumentError, if a String was given for an interpolation with argument" do
    I18n.backend.store_translations(:en, :test7 => "Sign up %{asdf:here}!")
    expect { @view.it("test7", :asdf => "Heinz") }.to raise_error(ArgumentError, "key{asdf} has an argument, so it cannot resolved with a String")
  end
end
