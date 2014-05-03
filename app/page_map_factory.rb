require_relative 'uri_helper'
require_relative 'page_map'

class PageMapFactory
  def initialize
    @cache = {}
  end

  # Creates and caches a PageMap instance for a URI.
  # Returns the cached instance if previously generated.
  def make_page(uri)
    host_and_path = URIHelper.host_and_path(uri)
    @cache[host_and_path] ||= PageMap.new(uri)
  end
end