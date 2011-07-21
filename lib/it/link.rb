module It
  class Link < Tag
    include ActionView::Helpers::UrlHelper
    
    def initialize(href, options = {})
      raise TypeError, "Invalid href given" unless href.is_a?(Hash) || href.is_a?(String)
      super(:a, options)
      @href = href
    end
    
    def process(content)
      link_to(content, @href, @options)
    end
  end
end