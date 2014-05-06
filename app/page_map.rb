require 'httparty'
require 'nokogiri'
require_relative 'html_processor'
require_relative 'uri_helper'

# Generates a map of all links, assets, and other
# properties from a web URI.
# The page is lazily processed - it will only download
# and parse when fields are accessed that require it.
class PageMap
  attr_reader :uri, :links, :assets

  def initialize(uri, html = nil)
    @uri = URIHelper.clean(URIHelper.parse_url(uri))
    @html = html
  end

  # All links referenced by the page.
  def links
    process_page unless @processed
    @links
  end

  # Map of assets referenced by the page.
  def assets
    process_page unless @processed
    @assets
  end

  def <=>(other)
    uri.to_s <=> other.uri.to_s
  end

  # This is overridden for DOT graph to image writing
  def to_s
    full_string dot: true
  end

  def full_string(opts = {})
    path = uri.path.empty? ? uri.to_s : uri.path
    string = "#{path}\n"
    separator = opts[:dot] ? '\l' : "\n"
    append_line = ->(str) { string << str + separator }
    append_line.call ''
    append_line.call '  links:'
    links.each do |l|
      append_line.call "      #{l}"
    end
    append_line.call '  assets:'
    assets.each do |type, assets|
      append_line.call "    #{type}:"
      assets.each do |a|
        append_line.call "        #{a}"
      end
    end
    string
  end

  private

  def process_page
    begin
      resp = @html || HTTParty.get(@uri)
      processed_html = HTMLProcessor.new(resp)
      # make relative links absolute. filter out other domains
      @links = processed_html.links.
        map(&method(:absolute_uri)).
        uniq.
        select(&method(:valid_link?))
      @assets = processed_html.assets
    rescue
      @links = []
      @assets = {}
      puts "Error processing page #{@uri}."
    end
    @processed = true
  end

  # Turns a relative URI into an absolute one
  # using this page as the root.
  def absolute_uri(uri)
    uri.relative? ? URI.join(@uri, uri) : uri
  end

  # Determines whether a URI is a link to another page
  # and resides on the same domain.
  def valid_link?(uri)
    URIHelper.page_link?(uri) && URIHelper.same_domain?(uri, @uri)
  end
end