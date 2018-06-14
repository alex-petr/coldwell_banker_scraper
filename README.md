# Coldwell Banker Scraper

## Introduction

This is a Ruby script to scrape products from 
https://www.coldwellbankerhomes.com.
Some notable features:

* Service Object Pattern which provide one public method - `#call`
* `curl` support with [Curb](https://github.com/taf2/curb) for getting pages HTML
* [Nokogiri](https://github.com/sparklemotion/nokogiri) for HTML parsing with 
XPath and CSS selector support.
* CSV export via [CSV Ruby class](http://ruby-doc.org/stdlib-2.0.0/libdoc/csv/rdoc/CSV.html)

## Requirements

This code has been run and tested on Ruby 2.5.0.

## Installation

This package is installed with `Bundler`:

```
$ gem install bundler
```

Install required gems:

```
$ bundle
```

## Tests

No test suite is available. To ensure that this scraper works run it and check 
output CSV.

## Usage

The following shows how to use:

```
$ bin/scraper
```

