require 'it/tag'
require 'it/link'
require 'it/helper'

ActiveSupport.on_load(:action_view) do
  include It::Helper
end

module It
  def self.link(href, options = {})
    It::Link.new(href, options)
  end
  
  def self.tag(tag, options = {})
    It::Tag.new(tag, options)
  end
end