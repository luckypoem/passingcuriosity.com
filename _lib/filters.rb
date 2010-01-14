require 'hpricot'
require 'liquid'
require 'cgi'

module PC
  module Filters
    
    def html_truncate(input, words = 20, truncate_string = "...")
    	doc = Hpricot.parse(input)
    	(doc/:"text()").to_s.split[0..words].join(' ') + truncate_string
    end

    def url_encode(input)
        CGI::escape(input)
    end
    
  end
end

Liquid::Template.register_filter(PC::Filters)
