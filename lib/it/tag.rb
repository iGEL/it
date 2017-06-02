module It
  # A generic class for html tags.
  class Tag
    include ActionView::Helpers::TagHelper

    attr_reader :tag_name, :options

    # See It.tag for details. You can do everything there and save 6 characters.
    def initialize(tag_name, options = {})
      raise TypeError, 'tag_name must be a String or Symbol' unless [String, Symbol].include?(tag_name.class)
      raise TypeError, 'options must be a Hash' unless options.is_a?(Hash)

      @tag_name = tag_name.to_sym
      @options = options.symbolize_keys
    end

    # Will be called from inside the helper to return the tag with the given content.
    def process(content = nil) # :nodoc:
      if content
        content_tag(@tag_name, content, @options)
      else
        tag(@tag_name, @options)
      end
    end
  end
end
