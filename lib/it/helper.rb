# encoding: UTF-8

module It
  module Helper
    def it(identifier, options = {})
      options.stringify_keys!
      translation = String.new(h(t(identifier)))
      
      while translation =~ /%\{[^{}}]+\}/
        translation.gsub!(/%\{[^{}}]+\}/) do |interpolation|
          token, label = interpolation[2..-2].split(":", 2)
          if !options.has_key?(token)
            raise KeyError, "key{#{token}} not found"
          elsif label && !options[token].is_a?(It::Tag)
            raise ArgumentError, "key{#{token}} has an argument, so it cannot resolved with a #{options[token].class}"
          elsif label
            options[token].process(raw label)
          else
            h(options[token])
          end
        end
      end
      
      raw translation
    end
  end
end
