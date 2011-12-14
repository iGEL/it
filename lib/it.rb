require 'it/tag'
require 'it/link'
require 'it/plain'
require 'it/helper'

ActiveSupport.on_load(:action_view) do
  include It::Helper
end

# Namespace of the gem.
module It
  # It outside of your views. See documentation at Helper#it
  def self.it(identifier, options = {})
    options.stringify_keys!
    process(I18n.t(identifier, :locale => options["locale"]), options)
  end

  # Creates a new link to be used in +it+.
  #
  # * +href+: The url for the link. You may specify it as a String or as a named route like +article_path+. It's not possible to specify
  #   a Hash like <code>{:controller => "articles", :action => "index"}</code> directly. Use the +url_for+ helper, if you would like to specify your
  #   links like that.
  # * +options+: The options as an Hash. Use them like you would with +link_to+. <em>(optional)</em>
  def self.link(href, options = {})
    It::Link.new(href, options)
  end

  # Creates a new plain replacement to be used in +it+.
  #
  # * +template+: A string to be used as the template. An example would be <code>"%s[http://www.rubyonrails.org]"</code>. Defaults to
  #   <code>"%s"</code>. <em>(optional)</em>
  def self.plain(template = "%s")
    It::Plain.new(template)
  end

  # Creates a new tag to be used in +it+.
  #
  # * +tag_name+: The name of the tag as a Symbol or String.
  # * +options+: The options will become attributes on the tag. <em>(optional)</em>
  def self.tag(tag_name, options = {})
    It::Tag.new(tag_name, options)
  end

  private
  def self.process(string, options)
    # Handle pluralization
    string = I18n.backend.send(:pluralize, options["locale"] || I18n.locale, string, options["count"]) if string.is_a?(Hash) && options["count"]

    # We want the escaped String, not an ActiveSupport::SafeBuffer
    translation = String.new(ERB::Util.h(string))

    # For deep nesting, we repeat the process until we have no interpolations anymore
    while translation =~ /%\{[^{}}]+\}/
      translation.gsub!(/%\{[^{}}]+\}/) do |interpolation|
        token, label = interpolation[2..-2].split(":", 2)

        # Convert tokens with String arguments into It::Links, if they are named link, link_* or *_link
        if (token == "link" || token.ends_with?("_link") || token.starts_with?("link_")) && (options[token].is_a?(String) || options[token].is_a?(Hash))
          options[token] = It::Link.new(options[token])
        end

        if !options.has_key?(token)
          raise KeyError, "key{#{token}} not found"
        elsif label && !options[token].is_a?(It::Tag)
          raise ArgumentError, "key{#{token}} has an argument, so it cannot resolved with a #{options[token].class}"
        elsif label # Normal tags
          options[token].process(label.html_safe)
        elsif options[token].is_a?(It::Tag) # Empty tag
          options[token].process
        else # Normal interpolations, as I18n.t would do it.
          ERB::Util.h(options[token])
        end
      end
    end

    translation.html_safe
  end
end
