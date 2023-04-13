.DEFAULT_GOAL := all

deps:
	bundle install

tests:
	bundle exec rspec spec/tests.rb

build:
	gem build simple-url.gemspec

push:
	gem push $(ls *.gem | head -n 1)

all: deps tests
