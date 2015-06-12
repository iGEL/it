module It
  class Interpolation
    attr_accessor :key, :label, :values

    def initialize(string, values)
      self.key, self.label = string[2..-2].split(':', 2)
      self.values = values

      convert_links
    end

    def process
      validate_key_presence!
      validate_value_for_arguments!

      if values[key].is_a?(It::Tag) # Empty tag
        process_it_tag
      else # Normal interpolations, as I18n.t would do it.
        ERB::Util.h(values[key])
      end
    end

    private

    # Convert keys with String arguments into It::Links, if they are named link, link_* or *_link
    def convert_links
      if key =~ /(\Alink\Z|_link\Z|\Alink_)/ && values[key].is_a?(String)
        values[key] = It::Link.new(values[key])
      end
    end

    def process_it_tag
      if label
        values[key].process(label.html_safe)
      else
        values[key].process
      end
    end

    def validate_key_presence!
      fail KeyError, "key{#{key}} not found" unless values.key?(key)
    end

    def validate_value_for_arguments!
      if label && !values[key].is_a?(It::Tag)
        fail ArgumentError, "key{#{key}} has an argument, so it cannot resolved with a #{values[key].class}"
      end
    end
  end
end
