require 'it/tag'
require 'it/link'
require 'it/helper'

ActiveSupport.on_load(:action_view) do
  include It::Helper
end