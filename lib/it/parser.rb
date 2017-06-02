module It
  # Parses the string and replaces all interpolations accordingly.
  class Parser
    attr_reader :string, :options

    INTERPOLATION_REGEXP = /%\{[^{}]+\}/

    def self.backend_options(options)
      options.with_indifferent_access.slice(:default, :locale, :scope)
    end

    def initialize(string, options)
      @string = string
      @options = options
    end

    def process
      handle_pluralization
      escape_string

      # For deep nesting, we repeat the process until we have no interpolations anymore
      while contains_interpolation?
        string.gsub!(INTERPOLATION_REGEXP) do |interpolation|
          Interpolation.call(interpolation, options)
        end
      end
      string.html_safe
    end

    private

    def contains_interpolation?
      string =~ INTERPOLATION_REGEXP
    end

    def handle_pluralization
      return if !string.is_a?(Hash) || !options.key?('count')

      @string = I18n.backend.send(:pluralize, locale, string, options['count'])
    end

    def locale
      options['locale'] || I18n.locale
    end

    def escape_string
      @string = String.new(ERB::Util.h(string))
    end
  end
end
