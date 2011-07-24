# encoding: UTF-8

module It
  # The helper will be available in the views.
  module Helper
    # This helper method works just like +t+ (or +translate+ for long), but it allows to insert tags like links 
    # or spans in the result. The content of these tags can be written in line with the rest of the translation.
    # Unless you need this functionality, use the normal +t+ method, which is faster.
    # 
    # Like for normal translations, you specify interpolations with <code>%{</code> at the beginning and with
    # <code>}</code> at the end. The new element is the <code>:</code>, which separates the name from the argument
    # of this interpolation.
    # 
    #   # translation: "Already signed up? %{login_link:Sign in}!"
    #   
    #   <%=it("translation", :login_link => It.link(login_path))
    # 
    # If your link doesn't require additional attributes and the name is +link+, starts with +link_+ or ends with +_link+,
    # you may specify the argument as a String or your helper.
    # 
    #   # translation: "Already signed up? %{login_link:Sign in}!"
    #   
    #   <%=it("translation", :login_link => login_path)
    # 
    # You may have as many tags inside of one translation as you like, and you even may nest them into each other. Also you
    # may specify arguments to links and other tags.
    # 
    #   # translation: "The top contributor of %{wiki_link:our wiki} is currently %{user_link:%{b:%{name}}}. Thanks a lot, %{name}!"
    # 
    #   <%= it("translation", :wiki_link => wiki_path, :name => user.name, :b => It.tag(:b, :class => "user"), :user_link => It.link(user_path(user), :target => "_blank"))
    # 
    # I recommend to limit the use of +it+ as much as possible. You could use it for <code><div></code> or <code><br /></code>, but I think, 
    # things seperated over multiple lines should go into different translations. Use it for inline tags like links, <code><span></code>,
    # <code><b></code>, <code><i></code>, <code><em></code> or <code><strong></code>.
    # 
    # It's currently not possible to specify your links as an Hash. Use the +url_for+ helper, if you want to specify your
    # link target as an Hash. Also, it's not possible by default to use this helper from inside your controllers. Eighter
    # you google how to use helpers inside your controllers or you push only the arguments for +it+ into the flash and parse
    # it once you parse the flash in the view:
    # 
    #   # Controller:
    #   flash[:message] = ["articles.update.success", {:article_link => It.link(article_path(article))}]
    # 
    #   # View (or layout)
    #   <% if flash[:message].is_a?(Array) %>
    #     <%= it(flash[:message].first, flash[:message].last) %>
    #   <% else %>
    #     <%= flash[:message] %>
    #   <% end %>
    # 
    def it(identifier, options = {})
      options.stringify_keys!
      # We want the escaped String, not an ActiveSupport::SafeBuffer
      translation = String.new(h(t(identifier)))
      
      # For deep nesting, we repeat the process until we have not interpolations anymore
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
            options[token].process(raw label)
          elsif options[token].is_a?(It::Tag) # Empty tag
            options[token].process
          else # Normal interpolations, as I18n.t would do it.
            h(options[token])
          end
        end
      end
      
      raw translation
    end
  end
end
