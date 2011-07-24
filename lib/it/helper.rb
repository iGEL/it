# encoding: UTF-8

module It
  module Helper
    def it(identifier, options = {})
      options.stringify_keys!
      translation = String.new(h(t(identifier)))
      
      while translation =~ /%\{[^{}}]+\}/
        translation.gsub!(/%\{[^{}}]+\}/) do |interpolation|
          token, label = interpolation[2..-2].split(":", 2)
          if (token == "link" || token.ends_with?("_link") || token.starts_with?("link_")) && (options[token].is_a?(String) || options[token].is_a?(Hash))
            options[token] = It::Link.new(options[token])
          end
          
          if !options.has_key?(token)
            raise KeyError, "key{#{token}} not found"
          elsif label && !options[token].is_a?(It::Tag)
            raise ArgumentError, "key{#{token}} has an argument, so it cannot resolved with a #{options[token].class}"
          elsif label
            options[token].process(raw label)
          elsif options[token].is_a?(It::Tag)
            options[token].process
          else
            h(options[token])
          end
        end
      end
      
      raw translation
    end
  end
end
