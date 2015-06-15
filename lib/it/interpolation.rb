module It
  # Contains one interpolation and will delegate the work to the It::Tag (or subclass) or
  # ERB::Util.h
  class Interpolation
    attr_accessor :key, :label, :value

    def initialize(string, values)
      self.key, self.label = extract_key_and_label_from(string)

      validate_key_presence(values)
      self.value = values[key]
      convert_link
    end

    def process
      validate_value_for_arguments

      if value.is_a?(It::Tag)
        process_it_tag
      else # Normal interpolations, as I18n.t would do it.
        ERB::Util.h(value)
      end
    end

    private

    def extract_key_and_label_from(string)
      # eg: %{key:label} or %{key}
      string[2..-2].split(':', 2)
    end

    # Convert keys with String arguments into It::Links, if they are named link, link_* or *_link
    def convert_link
      if key =~ /(\Alink\z|_link\z|\Alink_)/ && value.is_a?(String)
        self.value = It::Link.new(value)
      end
    end

    def process_it_tag
      if label
        value.process(label.html_safe)
      else
        value.process
      end
    end

    def validate_key_presence(values)
      fail KeyError, "key{#{key}} not found" unless values.key?(key)
    end

    def validate_value_for_arguments
      if label && !value.is_a?(It::Tag)
        fail ArgumentError, "key{#{key}} has an argument, so it cannot resolved with a #{value.class}"
      end
    end
  end
end
