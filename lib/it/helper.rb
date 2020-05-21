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
    #   <%=it("translation", login_link: It.link(login_path))
    #
    # If your link doesn't require additional attributes and the name is +link+, starts with +link_+ or ends with
    # +_link+, you may specify the argument as a String or your helper.
    #
    #   # translation: "Already signed up? %{login_link:Sign in}!"
    #
    #   <%=it("translation", login_link: login_path)
    #
    # You may have as many tags inside of one translation as you like, and you even may nest them into each other.
    # Also you may specify arguments to links and other tags.
    #
    #   # translation: "The top %{wiki_link:our wiki} contributor is %{user_link:%{b:%{name}}}. Thanks %{name}!"
    #
    #   <%= it("translation", wiki_link: wiki_path, name: user.name, b: It.tag(:b, class: "user"),
    #       user_link: It.link(user_path(user), target: "_blank"))
    #
    # I recommend to limit the use of +it+ as much as possible. You could use it for <code><div></code> or
    # <code><br /></code>, but I think, things seperated over multiple lines should go into different translations. Use
    # it for inline tags like links, <code><span></code>, <code><b></code>, <code><i></code>, <code><em></code> or
    # <code><strong></code>.
    #
    # It's currently not possible to specify your links as an Hash. Use the +url_for+ helper, if you want to specify
    # your link target as an Hash.
    #
    # If you need to use it outside of your views, use +It.it+.
    #
    def it(identifier, options = {})
      It::Parser.new(
        t(identifier, **It::Parser.backend_options(options)),
        options.stringify_keys
      ).process
    end
  end
end
