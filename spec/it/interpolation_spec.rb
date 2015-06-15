require 'spec_helper'
require 'it'

describe It::Interpolation do
  subject(:result) { It::Interpolation.call(string, values) }
  let(:string) { '%{key:label}' }
  let(:values) { {'key' => It.tag(:b)} }

  describe '.call' do
    it 'interpolates the string' do
      expect(result).to eq('<b>label</b>')
    end

    context 'when there is no label set' do
      let(:string) { '%{key}' }

      it 'interpolates the string to an empty tag' do
        expect(result).to eq('<b />')
      end
    end

    context 'when the value is not a tag and no label' do
      let(:string) { '%{key}' }
      let(:values) { {'key' => 'string'} }

      it 'does the normal interpolation' do
        expect(result).to eq('string')
      end

      context 'and the values contain html' do
        let(:values) { {'key' => '<b>hallo</b>'} }

        it 'escapes HTML in the normal interpolation' do
          expect(result).to eq('&lt;b&gt;hallo&lt;/b&gt;')
        end
      end
    end

    context 'with a string value' do
      let(:string) { "%{#{key}:label}" }
      let(:values) { {key => 'https://github.com'} }

      context 'and a key called link' do
        let(:key) { 'link' }

        it 'converts it to a link' do
          expect(result).to eq('<a href="https://github.com">label</a>')
        end
      end

      context 'and a key starting with link_' do
        let(:key) { 'link_github' }

        it 'converts it to a link' do
          expect(result).to eq('<a href="https://github.com">label</a>')
        end
      end

      context 'and a key ending with link_' do
        let(:key) { 'github_link' }

        it 'converts it to a link' do
          expect(result).to eq('<a href="https://github.com">label</a>')
        end
      end
    end

    context 'when the requested key was not privided' do
      let(:values) { {'something' => 'else'} }

      it 'raises an KeyError if the requested key was not provided' do
        expect { result }.to raise_error(KeyError)
      end
    end

    context 'when a string key has an argument' do
      let(:values) { {'key' => 'string'} }

      it 'raises an ArgumentError' do
        expect { result }.to raise_error(ArgumentError)
      end
    end
  end
end
