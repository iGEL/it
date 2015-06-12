require 'spec_helper'
require 'it'

describe It::Interpolation do
  subject(:interpolation) { It::Interpolation.new(string, values) }
  let(:string) { '%{key:label}' }
  let(:values) { {'key' => It.tag(:b)} }

  describe '.new' do
    it 'throws an error with one argument' do
      expect { It::Interpolation.new('%{key:label}') }.to raise_error(ArgumentError)
    end

    it 'extracts the key from the string' do
      expect(interpolation.key).to eq('key')
    end

    it 'extracts the label from the string' do
      expect(interpolation.label).to eq('label')
    end

    it 'assigns nil to the label if not present' do
      expect(It::Interpolation.new('%{key}', 'key' => 'string').label).to be_nil
    end

    it 'converts string value to a It::Link if the key is named link' do
      interpolation = It::Interpolation.new('%{link:label}', 'link' => 'http://github.com')

      expect(interpolation.value).to be_kind_of(It::Link)
    end

    it 'converts string value to a It::Link if the key starts with link_' do
      interpolation = It::Interpolation.new('%{link_github:label}', 'link_github' => 'http://github.com')

      expect(interpolation.value).to be_kind_of(It::Link)
    end

    it 'converts string value to a It::Link if the key ends with _link' do
      interpolation = It::Interpolation.new('%{github_link:label}', 'github_link' => 'http://github.com')

      expect(interpolation.value).to be_kind_of(It::Link)
    end
  end

  describe '#process' do
    it 'interpolates the string' do
      expect(interpolation.process).to eq('<b>label</b>')
    end

    it 'interpolates the string to an empty tag if no label is present' do
      interpolation.label = nil

      expect(interpolation.process).to eq('<b />')
    end

    context 'when the value is not a tag and no label' do
      let(:string) { '%{key}' }
      let(:values) { {'key' => 'string'} }

      it 'does the normal interpolation' do
        expect(interpolation.process).to eq('string')
      end

      context 'and the values contain html' do
        let(:values) { {'key' => '<b>hallo</b>'} }

        it 'escapes HTML in the normal interpolation' do
          expect(interpolation.process).to eq('&lt;b&gt;hallo&lt;/b&gt;')
        end
      end
    end

    context 'when the requested key was not privided' do
      let(:values) { {} }

      it 'raises an KeyError if the requested key was not provided' do
        expect { interpolation.process }.to raise_error(KeyError)
      end
    end

    context 'when a string key has an argument' do
      let(:values) { {'key' => 'string'} }

      it 'raises an ArgumentError' do
        expect { interpolation.process }.to raise_error(ArgumentError)
      end
    end
  end
end
