require 'rspec'
require_relative '../app/uri_helper'

describe URIHelper do
  describe '::same_domain?' do
    before(:each) do
      @url = 'http://a.com'
    end

    it 'returns true for the same uri' do
      result = URIHelper.same_domain?(@url, @url)
      expect(result).to be_true
    end

    it 'returns true for same domains' do
      result = URIHelper.same_domain?(@url, 'http://a.com/a/c.html')
      expect(result).to be_true
    end

    it 'returns false for different domains' do
      result = URIHelper.same_domain?(@url, 'http://b.com/a/c.html')
      expect(result).to be_false
    end
  end

  describe '::image?' do
    it 'handles pngs, jpg, jpegs, and gifs' do
      %w(png jpg jpeg gif).each do |f|
        result = URIHelper.image?("test.#{f}")
        expect(result).to be_true
      end
    end

    it 'returns false for non-image uris' do
      result = URIHelper.image?('http://www.a.com')
      expect(result).to be_false

      result = URIHelper.image?('http://www.a.com/a.pdf')
      expect(result).to be_false

      result = URIHelper.image?('')
      expect(result).to be_false
    end
  end

  describe '::host_and_path' do
    it 'extracts the host and path' do
      uri = 'http://www.a.com'
      result = URIHelper.host_and_path(uri)
      expect(result.to_s).to eq('www.a.com/')

      uri = 'http://www.a.com/b/c'
      result = URIHelper.host_and_path(uri)
      expect(result.to_s).to eq('www.a.com/b/c')
    end
  end

  describe '::clean' do
    it 'remove fragments from uri' do
      uri = 'http://www.a.com/#fragment'
      result = URIHelper.clean(uri)
      expect(result.to_s).to eq('http://www.a.com')
    end

    it 'removes query params from uri' do
      uri = 'http://www.a.com/?param=value'
      result = URIHelper.clean(uri)
      expect(result.to_s).to eq('http://www.a.com')

      uri = 'http://www.a.com/?param=value&p2=v2'
      result = URIHelper.clean(uri)
      expect(result.to_s).to eq('http://www.a.com')
    end

    it 'strips trailing slashes' do
      uri = 'http://www.a.com/'
      result = URIHelper.clean(uri)
      expect(result.to_s).to eq('http://www.a.com')
    end
  end

  describe '::page_link?' do
    it 'returns true for valid extension' do
      uri = 'http://www.a.com/a.'
      %w(html php asp aspx jsp htm).each do |e|
        result = URIHelper.page_link?(uri + e)
        expect(result).to be_true
      end
    end

    it 'returns true for no extension' do
      uri = 'http://www.a.com/a'
      result = URIHelper.page_link?(uri)
      expect(result).to be_true
    end

    it 'returns false for invalid extensions' do
      uri = 'http://www.a.com/a.zip'
      result = URIHelper.page_link?(uri)
      expect(result).to be_false
    end
  end
end