require 'spec_helper'
require 'it'

describe It::Plain do
  describe '.new' do
    it "works with no params" do
      expect { described_class.new }.not_to raise_error
    end

    it "works with a String" do
      expect { described_class.new("%s[http://www.rubyonrails.org]") }.not_to raise_error
    end

    it "raises ArgumentError with 2 params" do
      expect { described_class.new("asdf", "asdf")}.to raise_error(ArgumentError)
    end

    it "raises a TypeError, if the first param is not a String" do
      expect { described_class.new(1)}.to raise_error(TypeError)
    end
  end

  describe '#process' do
    context "when not initialized with a param" do
      subject(:plain) { described_class.new }

      it "returns 'Ruby on Rails'" do
        expect(plain.process("Ruby on Rails")).to eq('Ruby on Rails')
      end
    end

    context 'when initialized with %s[http://www.rubyonrails.org/]' do
      subject(:plain) { described_class.new("%s[http://www.rubyonrails.org/]") }

      it "returns 'Ruby on Rails[http://www.rubyonrails.org/]'" do
        expect(plain.process("Ruby on Rails")).to eq('Ruby on Rails[http://www.rubyonrails.org/]')
      end
    end
  end
end
