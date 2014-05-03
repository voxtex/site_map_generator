require 'rgl/dot'
require 'rgl/traversal'
require 'rgl/adjacency'
require_relative 'page_map_factory'
require 'pp'

# Crawls a URI and generates PageMaps for every page
# that is linked, up to the specified depth.
# Each page is a vertex in the graph.
# Directed edges are created for all links to other pages.
class SiteMap < RGL::DirectedAdjacencyGraph
  def initialize(uri, depth = 1, page_map_factory = PageMapFactory.new)
    super()
    @uri = URIHelper.parse_url(uri)
    @depth = depth
    @page_map_factory = page_map_factory

    initialize_graph
  end

  private

  def initialize_graph
    processed = Set.new
    root = @page_map_factory.make_page(@uri)
    pages_to_process = [root]
    current_depth = 0

    # only process up to the specified depth
    while pages_to_process.any? && current_depth <= @depth
      pages = pages_to_process
      pages_to_process = []
      while pages.any?
        page = pages.shift
        next if processed.include?(page)
        linked_pages = process_page(page)
        processed << page
        pages_to_process |= linked_pages
      end
      current_depth += 1
    end
  end

  def process_page(page)
    page.links.map do |l|
      @page_map_factory.make_page(l).tap do |p|
        # avoid self referencing edges
        add_edge(page, p) unless p == page
      end
    end
  end
end