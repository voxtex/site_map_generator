require 'rspec'
require_relative '../app/page_map_factory'

describe PageMapFactory do
  before(:each) do
    @factory = PageMapFactory.new
  end
  describe '#make_page' do
    it 'returns a new instance of PageMap' do
      page = @factory.make_page('http://www.a.com')
      expect(page).to be_a(PageMap)
    end

    it 'caches construction for same URIs' do
      uri = 'http://www.a.com'
      p1 = @factory.make_page(uri)
      p2 = @factory.make_page(uri)
      expect(p1).to eq(p2)
      expect(p1.hash).to eq(p2.hash)
    end
  end
end