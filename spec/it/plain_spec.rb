require 'spec_helper'
require 'it'

describe It::Plain do
  describe '.new' do
    it 'works with no params' do
      expect { described_class.new }.not_to raise_error
    end

    it 'works with a String' do
      expect { described_class.new('%s[http://www.rubyonrails.org]') }.not_to raise_error
    end

    it 'raises ArgumentError with 2 params' do
      expect { described_class.new('asdf', 'asdf') }.to raise_error(ArgumentError)
    end

    it 'raises a TypeError, if the first param is not a String' do
      expect { described_class.new(1) }.to raise_error(TypeError)
    end
  end

  describe '#process' do
    context 'when not initialized with a param' do
      let(:plain) { described_class.new }

      describe "and called with 'Ruby on Rails'" do
        subject(:result) { plain.process('Ruby on Rails') }

        it "returns 'Ruby on Rails'" do
          expect(result).to eq('Ruby on Rails')
        end
      end

      describe 'and called without an argument' do
        subject(:result) { plain.process }

        it 'returns and empty string' do
          expect(result).to eq('')
        end
      end
    end

    context 'when initialized with %s[http://www.rubyonrails.org/]' do
      let(:plain) { described_class.new('%s[http://www.rubyonrails.org/]') }

      describe "and called with 'Ruby on Rails'" do
        subject(:result) { plain.process('Ruby on Rails') }

        it "returns 'Ruby on Rails[http://www.rubyonrails.org/]'" do
          expect(result).to eq('Ruby on Rails[http://www.rubyonrails.org/]')
        end
      end

      describe 'and called without an argument' do
        subject(:result) { plain.process }

        it "returns '[http://www.rubyonrails.org/]'" do
          expect(plain.process).to eq('[http://www.rubyonrails.org/]')
        end
      end
    end
  end
end
