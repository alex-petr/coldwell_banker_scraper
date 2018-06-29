# Coldwell Banker Scraper

## Description

This is a Ruby script to scrape products from 
[https://www.coldwellbankerhomes.com](https://www.coldwellbankerhomes.com).

Scraped states, regions, products data then saved to `output/` directory in 
files with CSV format.

## This scraper script uses

* Static HTML (DOM) parsing for links/general info
* Semantic annotation recognizing in product/residence Microformat for parsing
  estate-specific data embedded in the product pages

## Workflow: how it works

![Workflow](https://github.com/alex-petr/coldwell_banker_scraper/raw/master/doc/Workflow.png)

## Features

* Service Object Pattern which provide one public method - `#call`
* Ruby executable script
* All required gems installed with `Bundler`
* `curl` support with [Curb](https://github.com/taf2/curb) for getting pages HTML
* [Nokogiri](https://github.com/sparklemotion/nokogiri) for HTML parsing with 
XPath and CSS selector support.
* CSV export via [CSV Ruby class](http://ruby-doc.org/stdlib-2.0.0/libdoc/csv/rdoc/CSV.html)
* Logging via [Logger Ruby class](https://ruby-doc.org/stdlib-2.2.3/libdoc/logger/rdoc/Logger.html)
* Code style is provided via [RuboCop](https://github.com/rubocop-hq/rubocop)
* Ruby code quality reporter via [RubyCritic](https://github.com/whitesmith/rubycritic)

## Requirements

* System: Linux, Mac
* Git
* Ruby version manager (`rbenv` or `RVM`)
* Ruby 2.5.0
* `Bundler`
* Gems installed via Bundler Gemfile

## Installation

### Download code from repository

Clone with SSH:

```bash
$ git clone git@github.com:alex-petr/coldwell_banker_scraper.git
```

Or clone with HTTPS:

```bash
$ git clone https://github.com/alex-petr/coldwell_banker_scraper.git
```

### rbenv (for macOS)

```bash
$ cd coldwell_banker_scraper/ && brew install rbenv
```

### Ruby

```bash
$ rbenv install 2.5.0
```

### Install `Bundler` and all required gems

```bash
$ gem install bundler && bundle
```

## Tests

No test suite is available. To ensure that this scraper works run it and check 
output in terminal and `output/` directory for CSV files.

## Usage

```bash
$ bin/scraper
```

After running script will generate a bunch of CSV files inside `output/` directory.
