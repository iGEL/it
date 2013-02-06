module It
  class Interpolation
    attr_accessor :key, :label, :values
    
    def initialize(string, values)
      self.key, self.label = string[2..-2].split(':', 2)
      self.values = values

      convert_links
    end
    
    def process
      if !values.has_key?(key)
        raise KeyError, "key{#{key}} not found"
      elsif label && !values[key].is_a?(It::Tag)
        raise ArgumentError, "key{#{key}} has an argument, so it cannot resolved with a #{values[key].class}"
      elsif label # Normal tags
        values[key].process(label.html_safe)
      elsif values[key].is_a?(It::Tag) # Empty tag
        values[key].process
      else # Normal interpolations, as I18n.t would do it.
        ERB::Util.h(values[key])
      end
    end

    private
    # Convert keys with String arguments into It::Links, if they are named link, link_* or *_link
    def convert_links
      if (key == 'link' || key.ends_with?('_link') || key.starts_with?('link_')) && (values[key].is_a?(String) || values[key].is_a?(Hash))
        self.values[key] = It::Link.new(values[key])
      end
    end
  end
end
