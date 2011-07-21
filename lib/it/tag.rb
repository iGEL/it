module It
  class Tag
    include ActionView::Helpers::TagHelper
    
    attr_reader :tag_name, :options
    
    def initialize(tag_name, options = {})
      raise TypeError, "tag_name must be specified as a String or Symbol" unless tag_name.is_a?(String) || tag_name.is_a?(Symbol)
      raise TypeError, "options must be specified as a Hash" unless options.is_a?(Hash)
      @tag_name = tag_name.to_sym
      @options = options.symbolize_keys
    end
    
    def process(content = nil)
      if content.nil?
        tag(@tag_name, @options)
      else
        content_tag(@tag_name, content, @options)
      end
    end
  end
end