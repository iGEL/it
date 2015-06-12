require 'spec_helper'
require 'it'

describe It::Parser do
  describe '.backend_options' do
    it 'returns :locale, :default & :scope' do
      expect(
        described_class.backend_options(a: 1, locale: 2, default: 3, scope: 4, count: 5)
      ).to eq('locale' => 2, 'default' => 3, 'scope' => 4)
    end

    it 'also works with string keys' do
      expect(
        described_class.backend_options('a' => 1, 'locale' => 2, 'default' => 3, 'scope' => 4, 'count' => 5)
      ).to eq('locale' => 2, 'default' => 3, 'scope' => 4)
    end
  end

  describe '#process' do
    it 'calls the Interpolation as required' do
      values = {'b' => It.tag(:b), 'link' => '/messages'}
      parser = It::Parser.new('You have %{b:%{link:new messages}}!', values)

      return1 = double('It::Interpolation', process: '<a href="/messages">new messages</a>')
      allow(It::Interpolation).to receive(:new).with('%{link:new messages}', values).and_return(return1)

      return2 = double('It::Interpolation', process: '<b><a href="/messages">new messages</a></b>')
      allow(It::Interpolation).to receive(:new).with(
        '%{b:<a href="/messages">new messages</a>}', values
      ).and_return(return2)

      expect(parser.process).to eq('You have <b><a href="/messages">new messages</a></b>!')
    end

    it 'escapes HTML in the string and the labels' do
      parser = It::Parser.new('It is a <b>save</b> %{word:<i>world</i>}', 'word' => It.tag(:i))

      expect(parser.process).to eq('It is a &lt;b&gt;save&lt;/b&gt; <i>&lt;i&gt;world&lt;/i&gt;</i>')
    end

    it 'marks the result as html safe' do
      parser = It::Parser.new('test', {})

      expect(parser.process).to be_html_safe
    end

    it 'delegates pluralization to I18n' do
      allow(I18n.backend).to receive(:pluralize).with(
        'en', {other: 'You have %{count} messages'}, 2
      ) { 'This is the pluralized string' }
      parser = It::Parser.new({other: 'You have %{count} messages'}, 'locale' => 'en', 'count' => 2)

      expect(parser.process).to eq('This is the pluralized string')
    end
  end
end
