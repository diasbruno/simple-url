# frozen_string_literal: true

require 'simple_url/key_value_query_string.rb'

RSpec.describe SimpleUrl::Url do
  describe 'simple url' do
    def with_url_query_string(url)
      described_class.new(url, SimpleUrl::KeyValueQueryString)
    end

    it 'not throw with a good url' do
      url = with_url_query_string('http://the-url.com')
      expect(url.to_s).to eq('http://the-url.com')
    end

    it 'should throw if a bad url from native URI' do
      expect do
        with_url_query_string('://the-url.com')
      end.to raise_error(URI::InvalidURIError)
    end

    it 'should identify a query string' do
      url = with_url_query_string('http://the-url.com?a=meh&b=mehmeh')
      expect(url.query.to_s).to eq('a=meh&b=mehmeh')
    end

    describe 'query string' do
      it "shouldn't find item on query string" do
        url = with_url_query_string('http://the-url.com?b=meh&b=mehmeh')
        expect(url.query['a']).to eq([])
      end

      it 'should find single item on query string' do
        url = with_url_query_string('http://the-url.com?a=meh&b=mehmeh')
        expect(url.query['a']).to eq(['meh'])
      end

      it 'should find many items on query string' do
        url = with_url_query_string('http://the-url.com?a=meh&a=mehmeh')
        expect(url.query['a']).to eq(['meh', 'mehmeh'])
      end

      it 'should add an single item from none' do
        url = with_url_query_string('http://the-url.com')
        url.query.add('b', 1)
        expect(url.query.to_s).to eq('b=1')
      end

      it 'should add an item' do
        url = with_url_query_string('http://the-url.com?a=1')
        url.query.add('b', 1)
        expect(url.query.to_s).to eq('a=1&b=1')
      end

      it 'should accumulate when adding an item, no override' do
        url = with_url_query_string('http://the-url.com')
        url.query.add('b', 1)
        url.query.add('b', 2)
        expect(url.query.to_s).to eq('b=1&b=2')
      end

      it "should not remove if key doesn't exists" do
        url = with_url_query_string('http://the-url.com')
        url.query.remove('a')
        expect(url.query.to_s).to eq('')
      end

      it "should remove if key exists" do
        url = with_url_query_string('http://the-url.com?a=1')
        url.query.remove('a')
        expect(url.query.to_s).to eq('')
      end
    end
  end
end
