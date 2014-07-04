require 'spec_helper'
require 'it'

describe It::Link do
  describe '.new' do
    it "accepts a String as frist param" do
      expect { described_class.new("http://www.rubyonrails.org/") }.not_to raise_error
    end

    it "accepts a Hash as first param" do
      expect { described_class.new({controller: "articles", action: "index"}) }.not_to raise_error
    end

    it "raises a TypeError if the first param is an Integer" do
      expect { described_class.new(1) }.to raise_error(TypeError)
    end

    it "accepts options as a Hash" do
      expect { described_class.new("http://www.rubyonrails.org/", {id: "identity", class: "classy"}) }.not_to raise_error
    end

    it "raises a TypeError, if the options are a String" do
      expect { described_class.new("http://www.rubyonrails.org/", "classy") }.to raise_error(TypeError)
    end

    it "raises ArgumentError, if called with three params" do
      expect { described_class.new("http://www.rubyonrails.org/", {}, :blubb) }.to raise_error(ArgumentError)
    end
  end

  describe '#tag_name' do
    it "always returns a" do
      expect(described_class.new("http://www.rubyonrails.org/").tag_name).to eq(:a)
    end
  end

  describe '#process' do
    it "returns a link with the options set and the content as label" do
      expect(described_class.new("http://www.rubyonrails.org", target: "_blank").process("Rails")).to eq('<a href="http://www.rubyonrails.org" target="_blank">Rails</a>')
    end
  end
end
