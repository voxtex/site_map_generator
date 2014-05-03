require 'rspec'
require_relative '../app/page_map'
require_relative 'html_mocks'

describe PageMap do
  before(:each) do
    @html = HTMLMocks::PARSE_TEST
    @page = PageMap.new('http://www.a.com', @html)
  end

  describe '#links' do
    it 'converts links to absolute paths' do
      strings = @page.links.map(&:to_s)
      expected = %w(
        http://www.a.com/r
        http://www.a.com/r-lead.html
        http://www.a.com/r-trail/
        http://www.a.com
        http://www.a.com/a
        http://www.a.com/a/
        http://www.a.com/a/#f?q=p
        http://www.a.com/a/b
      )
      expect(strings).to eq(expected)
    end

    it 'ignores links in other domains' do
      strings = @page.links.map(&:to_s)
      other_domain = %w(
        www.a.com/
        http://s.a.com/
      )
      expect(strings - other_domain).to eq(strings)
    end

    it 'ignores mailto and javascript links' do
      strings = @page.links.map(&:to_s)
      invalid_links = %w(
        mailto: test
        javascript: test
      )
      expect(strings - invalid_links).to eq(strings)
    end
  end
end