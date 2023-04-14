# frozen_string_literal: true

require 'uri'

module SimpleUrl
  class Url
    attr_accessor :url, :query
    attr_reader :query_string_class

    def initialize(url, query_string_class)
      @url = URI(url)
      @query_string_class = query_string_class
      @query = query_string_class.from_string(@url.query)
    end

    def to_s
      q = @query.to_s
      @url.query = q unless q.empty?
      @url.to_s
    end
  end
end
