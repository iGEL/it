module It
  class Link < Tag
    def initialize(href, options = {})
      raise TypeError, "Invalid href given" unless href.is_a?(Hash) || href.is_a?(String)
      super(:a, options)
      @options[:href] = href
    end
  end
end