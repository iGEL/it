require 'spec_helper'
require 'it'

RSpec.describe It::Tag do
  describe '.new' do
    it 'works with a parameter (Symbol)' do
      expect { described_class.new(:b) }.not_to raise_error
    end

    it 'works with a paramter (String)' do
      expect { described_class.new('b') }.not_to raise_error
    end

    it 'raises TypeError if called with an Integer' do
      expect { described_class.new(1) }.to raise_error(TypeError)
    end

    it 'accepts an options Hash' do
      expect { described_class.new(:b, class: 'very_bold') }.not_to raise_error
    end

    it 'raises a TypeError if called with a String' do
      expect { described_class.new(:b, 'very_bold') }.to raise_error(TypeError)
    end

    it 'raises an ArgumentError if called with three params' do
      expect { described_class.new(:b, {}, :blubb) }.to raise_error(ArgumentError)
    end
  end

  describe '#tag_name' do
    it 'returns the tag as a Symbol if given as a Symbol' do
      expect(described_class.new(:i).tag_name).to eq(:i)
    end

    it 'returns the tag_name as a Symbol if given as a String' do
      expect(described_class.new('i').tag_name).to eq(:i)
    end
  end

  describe '#options' do
    it 'returns the options with symbolized keys' do
      expect(described_class.new(:i, 'id' => 'cool', class: 'classy').options).to eq(id: 'cool', class: 'classy')
    end
  end

  describe '#process' do
    it 'returns a tag with the options as attributes and the param as content' do
      expect(
        described_class.new(:i, 'id' => 'cool', 'class' => 'classy').process('some text')
      ).to eq_html('<i class="classy" id="cool">some text</i>')
    end

    it 'is marked as html safe' do
      expect(described_class.new(:i).process('some text')).to be_html_safe
    end

    it 'escapes HTML' do
      expect(
        described_class.new(:i).process('some text & <b>html</b>')
      ).to eq('<i>some text &amp; &lt;b&gt;html&lt;/b&gt;</i>')
    end

    it "doesn't escape strings marked as HTML safe" do
      expect(
        described_class.new(:i).process('some text & <b>html</b>'.html_safe)
      ).to eq('<i>some text & <b>html</b></i>')
    end

    it 'returns an empty tag, if no content is provided' do
      expect(described_class.new(:br, 'id' => 'cool').process).to eq('<br id="cool" />')
    end
  end
end
