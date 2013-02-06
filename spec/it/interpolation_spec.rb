require 'spec_helper'
require 'it'

describe It::Interpolation do
  subject(:interpolation) { It::Interpolation.new('%{key:label}', { 'key' => It.tag(:b) }) }

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
      expect(It::Interpolation.new('%{key}', {}).label).to be_nil
    end

    it 'converts string values to a It::Link if the key is named link' do
      interpolation = It::Interpolation.new('%{link:label}', 'link' => 'http://github.com')

      expect(interpolation.values['link']).to be_kind_of(It::Link)
    end

    it 'converts string values to a It::Link if the key starts with link_' do
      interpolation = It::Interpolation.new('%{link_github:label}', 'link_github' => 'http://github.com')

      expect(interpolation.values['link_github']).to be_kind_of(It::Link)
    end

    it 'converts string values to a It::Link if the key ends with _link' do
      interpolation = It::Interpolation.new('%{github_link:label}', 'github_link' => 'http://github.com')

      expect(interpolation.values['github_link']).to be_kind_of(It::Link)
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

    it 'does the normal interpolation if the value is not a Tag and no label is present' do
      interpolation.label = nil
      interpolation.values = { 'key' => 'string'}

      expect(interpolation.process).to eq('string')
    end

    it 'escapes HTML in the normal interpolation' do
      interpolation.label = nil
      interpolation.values = { 'key' => '<b>hallo</b>'}

      expect(interpolation.process).to eq('&lt;b&gt;hallo&lt;/b&gt;')
    end

    it 'raises an KeyError if the requested key was not provided' do
      interpolation.values = {}

      expect { interpolation.process }.to raise_error(KeyError)
    end

    it 'raises an ArgumentError, if a string should be interpolated with a label' do
      interpolation.values = { 'key' => 'string'}

      expect { interpolation.process }.to raise_error(ArgumentError)
    end
  end
end
