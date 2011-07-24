module It
  # A generic class for html tags.
  class Tag
    include ActionView::Helpers::TagHelper
    
    attr_reader :tag_name, :options
    
    # See It.tag for details. You can do everything there and save 6 characters.
    def initialize(tag_name, options = {})
      raise TypeError, "tag_name must be specified as a String or Symbol" unless tag_name.is_a?(String) || tag_name.is_a?(Symbol)
      raise TypeError, "options must be specified as a Hash" unless options.is_a?(Hash)
      @tag_name = tag_name.to_sym
      @options = options.symbolize_keys
    end
    
    # Will be called from inside the helper to return the tag with the given content.
    def process(content = nil) # :nodoc:
      if content.nil?
        tag(@tag_name, @options)
      else
        content_tag(@tag_name, content, @options)
      end
    end
  end
end