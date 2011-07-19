module It
  class Tag
    attr_reader :tag, :options
    
    def initialize(tag, options = {})
      raise TypeError, "Tag must be specified as a String or Symbol" unless tag.is_a?(String) || tag.is_a?(Symbol)
      raise TypeError, "Options must be specified as a Hash" unless options.is_a?(Hash)
      @tag = tag.to_sym
      @options = options.symbolize_keys
    end
  end
end