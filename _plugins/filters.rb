module Jekyll
    module CustomFilters
      def preserve_react(input)
        input.gsub(/(<(Route|Switch)[^>]*>)/, '{% raw %}\1{% endraw %}')
      end
    end
  end
  
  Liquid::Template.register_filter(Jekyll::CustomFilters)