module It
  # A class for links
  class Link < Tag
    include ActionView::Helpers::UrlHelper

    # See It.link for details. You can do everything there and save 6 characters.
    def initialize(href, options = {})
      raise TypeError, 'Invalid href given' unless [Hash, String].include?(href.class)

      super(:a, options)
      @href = href
    end

    # Will be called from inside the helper to return the tag with the given content.
    def process(content)
      link_to(content, @href, @options)
    end
  end
end
