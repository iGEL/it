module It
  # Contains one interpolation and will delegate the work to the It::Tag (or subclass) or
  # ERB::Util.h
  class Interpolation
    class << self
      def call(string, values)
        key, label = extract_key_and_label_from(string)
        value = values[key]

        raise KeyError, "key{#{key}} not found" unless values.key?(key)

        new(key, value, label).process
      end

      private

      # This is a :reek:UtilityFunction, but it's not an instance method
      def extract_key_and_label_from(string)
        # eg: %{key:label} or %{key}
        string[2..-2].split(':', 2)
      end
    end

    def initialize(key, value, label)
      @key = key
      @value = value
      @label = label
    end

    def process
      convert_link

      validate_value_for_arguments

      if value.is_a?(It::Tag)
        process_it_tag
      else # Normal interpolations, as I18n.t would do it.
        ERB::Util.h(value)
      end
    end

    private

    attr_reader :key, :value, :label

    # Convert keys with String arguments into It::Links, if they are named link, link_* or *_link
    def convert_link
      if key =~ /(\Alink\z|_link\z|\Alink_)/ && value.is_a?(String)
        @value = It::Link.new(value)
      end
    end

    def process_it_tag
      if label
        value.process(label.html_safe)
      else
        value.process
      end
    end

    def validate_value_for_arguments
      if label && !value.is_a?(It::Tag)
        raise ArgumentError, "key{#{key}} has an argument, so it cannot resolved with a #{value.class}"
      end
    end
  end
end
