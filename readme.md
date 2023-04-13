# Simple URL

ruby's `URI` is a very simple way to deal with...well, uri.

the problem is the `search` (query string).

dealing with search string by hand is really annoying 
and error prune. as the search has no form specified on the RFC,
we can play with it, it opens a lot of interesting ideas
to providing a better way to manage it.

an example is a search that works with key/values pairs
that can contains duplicated keys:

```txt
a=ok&a=meh
```

if this is not a good idea for you application,
we could implement a query string that uses a hashmap
as storage.

a required interface is:

```java
interface QueryString {
  static QueryString from_string(String query_string);
  String to_s();
}
```

```rb
class HashmapSearch
  def self.from_string(query_string)
    ary = URI.decode_www_form(query_string || '')
    new(ary)
  end

  def initialize(query)
    # if a keys is present many times,
    # the last one will get on the hash.
    @query = query.empty? ? {} : Hash[query]
  end

  def to_s
    URI.encode_www_form(@query)
  end

  # operations is up to you!

  def add(key, value)
    @query[key] = value
  end

  def [](key)
    @query[key]
  end

  def remove(key)
    @query = @query.reject do |pair|
      k, = pair
      k == key
    end
  end
end
```

getting everything together...

```rb
irb> a = SimpleUrl::Url.new('https://okokok.com/path?a=1&a=2', HashmapSearch)
=> #<SimpleUrl::Url:0x00000000017447e8 @url=#<URI::HTTPS https://okokok.com/path?a=1&a=2>, @query_string_class=HashmapSearch, @query=#<HashmapSea...
irb> a.query
=> #<HashmapSearch:0x0000000001744338 @query={"a"=>"2"}>
irb> a.url.path = "/asdf"
=> "/asdf"
irb> a.to_s
=> "https://okokok.com/asdf?a=2"
```

## license

This code is released under `Unlicense`.

See `License`
