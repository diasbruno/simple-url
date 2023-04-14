# frozen_string_literal: true

module SimpleUrl
  class KeyValueQueryString
    def self.from_string(query_string)
      ary = URI.decode_www_form(query_string || '')
      new(ary)
    end

    def initialize(query)
      @query = query || []
    end

    def add(key, value)
      @query << [key, value]
    end

    def [](key)
      @query.each_with_object([]) do |pair, acc|
        k, v = pair
        acc << v if k == key
      end
    end

    def remove(key)
      @query = @query.reject do |pair|
        k, = pair
        k == key
      end
    end

    def to_s
      URI.encode_www_form(@query)
    end
  end
end
