require 'spec_helper'
require 'it'
require 'active_support/core_ext/string'

describe It::Helper do
  describe "#it" do
    let(:view) { ActionView::Base.new(controller: ActionController::Base.new) }

    before do
      I18n.backend.store_translations(:en, test1: "I have a %{link:link to Rails} in the middle.")
      I18n.backend.store_translations(:de, test1: "Ich habe einen %{link:Link zu Rails} in der Mitte.")
    end

    after do
      I18n.locale = :en
    end

    it "inserts the link into the string" do
      expect(view.it("test1", link: It.link("http://www.rubyonrails.org"))).to eq('I have a <a href="http://www.rubyonrails.org">link to Rails</a> in the middle.')
    end

    it "inserts the link into the German translation" do
      I18n.locale = :de
      expect(view.it("test1", link: It.link("http://www.rubyonrails.org"))).to eq('Ich habe einen <a href="http://www.rubyonrails.org">Link zu Rails</a> in der Mitte.')
    end

    it "allows link options to be set" do
      expect(view.it("test1", link: It.link("http://www.rubyonrails.org", target: "_blank"))).to eq('I have a <a href="http://www.rubyonrails.org" target="_blank">link to Rails</a> in the middle.')
    end

    it "supports the plain thing" do
      expect(view.it("test1", link: It.plain("%s[http://www.rubyonrails.org]"))).to eq('I have a link to Rails[http://www.rubyonrails.org] in the middle.')
    end

    it "parses other tags as well" do
      expect(view.it("test1", link: It.tag(:b, class: "classy"))).to eq('I have a <b class="classy">link to Rails</b> in the middle.')
    end

    it "marks the result as html safe" do
      expect(view.it("test1", link: It.link("http://www.rubyonrails.org"))).to be_html_safe
    end

    it "escapes all html in the translation" do
      I18n.backend.store_translations(:en, test2: "<a href=\"hax0r\"> & %{link:link -> Rails} in <b>the middle</b>.")
      expect(view.it("test2", link: It.link("http://www.rubyonrails.org"))).to eq('&lt;a href=&quot;hax0r&quot;&gt; &amp; <a href="http://www.rubyonrails.org">link -&gt; Rails</a> in &lt;b&gt;the middle&lt;/b&gt;.')
    end

    it "also works with 2 links" do
      I18n.backend.store_translations(:en, test3: "I like %{link1:rails} and %{link2:github}.")
      expect(view.it("test3", link1: It.link("http://www.rubyonrails.org"), link2: It.link("http://www.github.com"))).to eq('I like <a href="http://www.rubyonrails.org">rails</a> and <a href="http://www.github.com">github</a>.')
    end

    it "allows normal I18n interpolations" do
      I18n.backend.store_translations(:en, test4: "I have a %{link:link to Rails} in the %{position}.")
      expect(view.it("test4", link: It.link("http://www.rubyonrails.org"), position: "middle")).to eq('I have a <a href="http://www.rubyonrails.org">link to Rails</a> in the middle.')
    end

    it "allows Integers as normal interpolation" do
      I18n.backend.store_translations(:en, test5: "Hello %{name}.")
      expect(view.it("test5", name: 2)).to eq('Hello 2.')
    end

    it "escapes the HTML in normal interpolations" do
      I18n.backend.store_translations(:en, test5: "Hello %{name}.")
      expect(view.it("test5", name: '<a href="http://evil.haxor.com">victim</a>')).to eq('Hello &lt;a href=&quot;http://evil.haxor.com&quot;&gt;victim&lt;/a&gt;.')
    end

    it "doesn't escape html_safe interpolations" do
      I18n.backend.store_translations(:en, test5: "Hello %{name}.")
      expect(view.it("test5", name: '<a href="http://www.rubyonrails.org">Rails</a>'.html_safe)).to eq('Hello <a href="http://www.rubyonrails.org">Rails</a>.')
    end

    it "allows interpolations inside of links" do
      I18n.backend.store_translations(:en, test6: "Did you read our %{link:nice %{article}}?")
      expect(view.it("test6", link: It.link("/article/2"), article: "article")).to eq('Did you read our <a href="/article/2">nice article</a>?')
    end

    it "raises a KeyError, if the key was not given" do
      expect { view.it("test1", blubb: true) }.to raise_error(KeyError, "key{link} not found")
    end

    it "raises an ArgumentError, if a String was given for an interpolation with argument" do
      I18n.backend.store_translations(:en, test7: "Sign up %{asdf:here}!")
      expect { view.it("test7", asdf: "Heinz") }.to raise_error(ArgumentError, "key{asdf} has an argument, so it cannot resolved with a String")
    end

    it "allows Strings, if the interpolation name is link" do
      I18n.backend.store_translations(:en, test8: "Sign up %{link:here}!")
      expect(view.it("test8", link: "/register")).to eq('Sign up <a href="/register">here</a>!')
    end

    it "allows Strings, if the interpolation name ends with _link" do
      I18n.backend.store_translations(:en, test8: "Sign up %{register_link:here}!")
      expect(view.it("test8", register_link: "/register")).to eq('Sign up <a href="/register">here</a>!')
    end

    it "allows Strings, if the interpolation name starts with link_" do
      I18n.backend.store_translations(:en, test8: "Sign up %{link_to_register:here}!")
      expect(view.it("test8", link_to_register: "/register")).to eq('Sign up <a href="/register">here</a>!')
    end

    it "works with tags without arguments" do
      I18n.backend.store_translations(:en, test9: "We can %{br} do line breaks")
      expect(view.it("test9", br: It.tag(:br))).to eq('We can <br /> do line breaks')
    end

    it 'supports dot-prefixed keys' do
      I18n.backend.store_translations(:en, widgets: { show: { all_widgets: "See %{widgets_link:all widgets}" } })
      view.instance_variable_set(:"@_virtual_path", "widgets/show") # For Rails 3.0
      view.instance_variable_set(:"@virtual_path", "widgets/show") # For Rails 3.1, 3.2 and probably 4.0
      expect(view.it('.all_widgets', widgets_link: '/widgets')).to eq('See <a href="/widgets">all widgets</a>')
    end

    it 'supports the locale option' do
      expect(view.it('test1', locale: "de", link: It.link("http://www.rubyonrails.org"))).to eq('Ich habe einen <a href="http://www.rubyonrails.org">Link zu Rails</a> in der Mitte.')
    end

    context "With a pluralized translation" do
      before do
        I18n.backend.store_translations(:en, test10: {zero: "You have zero messages.", one: "You have %{link:one message}.", other: "You have %{link:%{count} messages}."})
      end

      it 'works with count = 0' do
        expect(view.it("test10", count: 0, link: "/messages")).to eq('You have zero messages.')
      end

      it 'works with count = 1' do
        expect(view.it("test10", count: 1, link: "/messages")).to eq('You have <a href="/messages">one message</a>.')
      end

      it 'works with count > 1' do
        expect(view.it("test10", count: 2, link: "/messages")).to eq('You have <a href="/messages">2 messages</a>.')
      end
    end
  end
end
