module It
  class Parser
    attr_accessor :string, :options

    INTERPOLATION_REGEXP = /%\{[^{}}]+\}/

    def initialize(string, options)
      self.string = string
      self.options = options
    end

    def process
      handle_pluralization
      escape_string

      # For deep nesting, we repeat the process until we have no interpolations anymore
      while has_interpolation?
        self.string.gsub!(INTERPOLATION_REGEXP) do |interpolation|
          Interpolation.new(interpolation, options).process
        end
      end
      string.html_safe
    end

    private
    def has_interpolation?
      string =~ INTERPOLATION_REGEXP
    end

    def handle_pluralization
      self.string = I18n.backend.send(:pluralize, (options['locale'] || I18n.locale), string, options['count']) if string.is_a?(Hash) && options['count']
    end

    def escape_string
      self.string = String.new(ERB::Util.h(string))
    end
  end
end
