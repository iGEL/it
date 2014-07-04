require 'spec_helper'
require 'it'

describe It do
  describe '.it' do
    it "translates inside the controller as well" do
      I18n.backend.store_translations(:en, test1: "I have a %{link:link to Rails} in the middle.")
      expect(It.it("test1", link: It.link("http://www.rubyonrails.org"))).to eq('I have a <a href="http://www.rubyonrails.org">link to Rails</a> in the middle.')
    end

    it 'uses default key if no translation is present on specified key' do
      I18n.backend.store_translations(:en, fallback: 'this is a fallback')
      expect(It.it('a.missing.key', default: :fallback)).to eq('this is a fallback')
    end

    it 'uses default string if key is missing' do
      expect(It.it('a.missing.key', default: 'this is a fallback string')).to eq('this is a fallback string')
    end
  end

  describe '.link' do
    it "returns an It::Link object" do
      expect(It.link("https://www.github.com").class).to eq(It::Link)
    end

    it "accepts one param" do
      expect { It.link("http://www.rubyonrails.org/") }.not_to raise_error
    end

    it "accepts two params" do
      expect { It.link("http://www.rubyonrails.org/", {id: "identity", class: "classy"}) }.not_to raise_error
    end

    it "raises ArgumentError, if called with three params" do
      expect { It.link("http://www.rubyonrails.org/", {}, :blubb) }.to raise_error(ArgumentError)
    end
  end

  describe '.tag' do
    it "returns an It::Tag object" do
      expect(It.tag(:b).class).to eq(It::Tag)
    end

    it "works with a param" do
      expect { It.tag(:b) }.not_to raise_error
    end

    it "accepts two params" do
      expect { It.tag(:b, class: "very_bold") }.not_to raise_error
    end

    it "raises an ArgumentError if called with three params" do
      expect { It.tag(:b, {}, :blubb) }.to raise_error(ArgumentError)
    end
  end

  describe '.plain' do
    it "returns an It::Plain object" do
      expect(It.plain.class).to eq(It::Plain)
    end

    it "works without params" do
      expect { It.plain }.not_to raise_error
    end

    it "accepts one param" do
      expect { It.plain("%s[http://www.rubyonrails.org/]") }.not_to raise_error
    end

    it "raises ArgumentError, if called with two params" do
      expect { It.plain("%s[http://www.rubyonrails.org/]", :blubb) }.to raise_error(ArgumentError)
    end
  end
end
