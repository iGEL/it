# encoding: UTF-8

module It
  module Helper
    include ActionView::Helpers::UrlHelper
    include ERB::Util
    
    def t_tags(translation, options = {})
      options.symbolize_keys!
      string = String.new(h(t(translation))) # We want an escaped String, not an ActiveSupport::SafeBuffer

      # Resolve the inner interpolations of nested interpolations
      string.gsub!(/(%\{[^}]+:[^}]*)(%\{[^}]+\})([^}]*\})/) do |tl|
        token = $2[2..-2].to_sym
        if options.has_key?(token)
          "#{$1}#{options[token]}#{$3}"
        else
          tl
        end
      end
      
      # Parse links
      string.gsub!(/%\{[^}]+\}/) do |tl|
        if tl.include?(":")
          token, label = tl[2..-2].split(":", 2)
          addr = options.delete(token.to_sym)
          if addr.nil?
            tl
          else
            link_options = options.delete("#{token}_options".to_sym)
            link_to(raw(label), addr, link_options)
          end
        else
          tl
        end
      end
      
      # Escape HTML of the replacements and interpolate
      options.each { |key, value| options[key] = (value.is_a?(String) && !value.html_safe?) ? h(value) : value }
      raw(string % options)
    end
  end
end
