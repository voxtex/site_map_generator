require 'rspec'
require_relative '../app/html_processor'
require_relative 'html_mocks'

describe HTMLProcessor do
  before(:each) do
    @html = HTMLMocks::PARSE_TEST
    @proc = HTMLProcessor.new(@html)
  end

  describe '#links' do
    it 'finds all of the links' do
      strings = @proc.links.map(&:to_s)
      expected = %w(
        r
        /r-lead.html
        r-trail/
        http://www.a.com
        http://a.com/
        http://s.a.com/
        www.a.com/
        http://www.a.com/a
        http://www.a.com/a/
        http://www.a.com/a/#f?q=p
        http://www.a.com/a/b
      )
      expect((strings - expected).empty?).to be_true
    end
  end

  describe '#assets' do
    it 'finds all css assets' do
      css = @proc.assets[:css].map(&:to_s)
      expected = %w(http://www.b.com/style.css style.css)
      expect((css - expected).empty?).to be_true
    end

    it 'finds all js assets' do
      css = @proc.assets[:js].map(&:to_s)
      expected = %w(script.js http://www.b.com/script.js)
      expect((css - expected).empty?).to be_true
    end

    it 'finds all img assets' do
      css = @proc.assets[:image].map(&:to_s)
      expected = %w(http://www.a.com/image.jpg /image.jpg)
      expect((css - expected).empty?).to be_true
    end

  end
end
