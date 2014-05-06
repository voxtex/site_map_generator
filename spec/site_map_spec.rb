require 'rspec'
require_relative '../app/page_map_factory'
require_relative '../app/site_map'

describe SiteMap do
  before(:each) do
    @page_map_factory = double('PageMapFactory')
    @root = double('PageMap',
                   uri: 'http://www.a.com/',
                   links: ['http://www.a.com/a'])
    @a_page = double('PageMap',
                     uri: 'http://www.a.com/a',
                     links: %w(http://www.a.com/b http://www.a.com/c))
    @b_page = double('PageMap',
                     uri: 'http://www.a.com/b',
                     links: ['http://www.a.com/'])
    @c_page = double('PageMap',
                     uri: 'http://www.a.com/c',
                     links: [])
    [@root, @a_page, @b_page, @c_page].each do |p|
      [p.uri, URI.parse(p.uri)].each do |u|
        allow(@page_map_factory).to receive(:make_page).with(u) { p }
      end
    end
  end

  it 'traverses all of the linked URIs' do
    sitemap = SiteMap.new('http://www.a.com/', 2, 20, @page_map_factory)
    expect(sitemap.vertices).to eq([@root, @a_page, @b_page, @c_page])
    expect(sitemap.edges.length).to be(4)
  end

  it 'only traverses to the depth specified' do
    sitemap = SiteMap.new('http://www.a.com/', 0, 20, @page_map_factory)
    expect(sitemap.vertices).to eq([@root, @a_page])
    expect(sitemap.edges.length).to be(1)

    sitemap = SiteMap.new('http://www.a.com/', 1, 20, @page_map_factory)
    expect(sitemap.vertices).to eq([@root, @a_page, @b_page, @c_page])
    expect(sitemap.edges.length).to be(3)
  end
end