require 'nokogiri'
require_relative 'uri_helper'

# Processes an HTML string and parses out
# all href links and static assets.
class HTMLProcessor
  def initialize(html)
    @doc = Nokogiri::HTML(html)
  end

  # All href links in the document.
  def links
    @doc.css('a[href]').map do |a|
      parse_element_attribute_uri(a, 'href')
    end.compact.uniq
  end

  # Map of all static assets in the document.
  def assets
    {
      css: css_assets,
      js: js_assets,
      image: image_assets
    }
  end

  private

  def css_assets
    @doc.css('link[href*=".css"]').map do |l|
      parse_element_attribute_uri(l, 'href')
    end.compact.uniq
  end

  def js_assets
    @doc.css('script[src*=".js"]').map do |s|
      parse_element_attribute_uri(s, 'src')
    end.compact.uniq
  end

  def image_assets
    uris = @doc.css('img[src]').map do |i|
      parse_element_attribute_uri(i, 'src')
    end
    uris.compact.select do |uri|
      URIHelper.image? uri
    end.uniq
  end

  # Cleans newline separators and escapes spaces
  # in attribute values.
  def clean_attribute(val)
    val.to_s.delete("\n").gsub(' ', '%20')
  end

  # Parses an HTML element's attribute into a URI
  # Returns nil for malformed URI. Maybe track malformed URIs?
  def parse_element_attribute_uri(elem, attr)
    attr_value = clean_attribute(elem.attribute(attr))
    begin
      return nil if attr_value =~ /mailto:|javascript:/
      URI.parse(attr_value)
    rescue URI::InvalidURIError
      nil
    end
  end
end