module Kramdown
    module Parser
      class GFM < Kramdown::Parser::Kramdown
        def parse_html_tag_start(tag, attrs, md_type)
          if tag =~ /^(Route|Switch)/
            @src.pos += @src.matched_size
            el = Element.new(:raw, @src.matched)
            @tree.children << el
          else
            super
          end
        end
      end
    end
  end