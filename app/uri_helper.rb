class URIHelper
  class << self
    IMAGE_TYPES = %w(png jpg jpeg gif)
    IMAGE_REGEX = Regexp.new("\\.(?:#{IMAGE_TYPES.join('|')})$")

    PAGE_TYPES = %w(html php asp aspx jsp htm)
    PAGE_REGEX = Regexp.new("\\.(?:#{PAGE_TYPES.join('|')})")

    # URIs without a scheme (www.a.com) are incorrectly
    # parsed by URI.parse, this should fix it.
    def parse_url(uri)
      return uri if uri.is_a? URI

      uri = URI.parse(uri)
      is_incomplete = uri.scheme.nil? && uri.host.nil?
      is_incomplete ? URI.parse('http://' + uri.to_s) : uri
    end

    # Determines if two URIs are on the same domain.
    def same_domain?(uri1, uri2)
      uri1 = URI.parse(uri1) unless uri1.is_a? URI
      uri2 = URI.parse(uri2) unless uri2.is_a? URI
      uri1.host == uri2.host
    end

    # Determines if a URI points to an image.
    def image?(uri)
      uri = URI.parse(uri) unless uri.is_a? URI
      !(IMAGE_REGEX =~ uri.path).nil?
    end

    # Normalizes URI path and extracts host and path.
    def host_and_path(uri)
      uri = URI.parse(uri) unless uri.is_a? URI
      host = uri.host
      path = uri.path.gsub(/\/$/, '')
      path = path.empty? ? '/' : uri.path
      URI.parse("#{host}#{path}")
    end

    # Removes fragment and query parameters from URI.
    def clean(uri)
      uri = URI.parse(uri) unless uri.is_a? URI
      uri.fragment = ''
      uri.query = ''
      URI.parse(uri.to_s.gsub(/[?#\/]+$/, ''))
    end

    # Validates that a page has a valid extension or no extension
    def page_link?(uri)
      uri = URI.parse(uri) unless uri.is_a? URI
      uri.path =~ PAGE_REGEX || uri.path !~ /\..*$/
    end
  end
end