require 'it/parser'
require 'it/interpolation'
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
    Parser.new(I18n.t(identifier, :locale => options["locale"]), options).process
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
end
