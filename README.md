[![Code Climate](http://img.shields.io/codeclimate/github/iGEL/it.svg?style=flat)](https://codeclimate.com/github/iGEL/it)
[![Build Status](http://img.shields.io/travis/iGEL/it/master.svg?style=flat)](https://travis-ci.org/iGEL/it)
[![Coverage](http://img.shields.io/coveralls/iGEL/it/master.svg?style=flat)](https://coveralls.io/r/iGEL/it)
[![Rubygems](http://img.shields.io/gem/v/it.svg?style=flat)](http://rubygems.org/gems/it)
[![Github Issues](http://img.shields.io/github/issues/iGEL/it.svg?style=flat)](https://github.com/iGEL/it/issues)
[![Dependency Status](http://img.shields.io/gemnasium/iGEL/it.svg?style=flat)](https://gemnasium.com/iGEL/it)

Tested against Ruby 2.2, 2.1, 2.0, head, rbx, and jruby and Rails 4.2, 4.1, and 3.2

What is **it**?
=============

I18n is baked right into Rails, and it's great. But if you want to place markup or links inside your translated copies, things get a little messy. You need to specify the label of your links separately from the rest of the copy. Writing HTML in your translations is even worse.

```yaml
en:
  copy: "If you are already registered, %{login_link}!"
  copy_login_link: "please sign in"
```

```erb
<%=raw t("copy", login: link_to(t("copy_login_link"), login_path)) %>
```

Wouldn't it be much nicer and easier to understand for your translator to have the whole copy in single label? **it** lets you do that:

```yaml
en:
  copy: "If you are already registered, %{login_link:please sign in}!"
```

```erb
<%=it "copy", login_link: login_path %>
```

You may have noticed in the example above, that **it** doesn't require `raw` anymore. Of course, all HTML in the translation gets properly escaped, so you don't have to worry about XSS.

Installation
------------

Just add the following line to your Gemfile & run `bundle install`:

```ruby
gem 'it'
```

Usage
-----

You may have as many links inside your translations as you like, and normal interpolations are possible as well:

```yaml
en:
  copy: "Read the %{guide:Rails I18n guide} for more than %{advises} advises. Fork it at {repo:github}."
```

```erb
<%=it "copy",
  guide: It.link("http://guides.rubyonrails.org/i18n.html"),
  advices: 100,
  repo: It.link("https://github.com/lifo/docrails/tree/master/railties/guides") %>
```

As you see above, unless the interpolation name is `link` or starts with `link_` or ends with `_link`, you need to call `It.link` to create a link. The advantage of `It.link`: You may specify options like you would with `link_to`:

```erb
<%=it "copy",
  link: It.link("http://rubyonrails.org", target: '_blank', class: "important") %>
```

You may pass any kind of object accepted by `link_to` as the link target, so your loved named routes like `article_path(id: article.id)` will all work fine.

Want to introduce some markup into your sentences? **it** will help you:

```yaml
en:
  advantages: There are %{b:many advantages} for registered users!
```

```erb
<%=it "advantages", b: It.tag(:b, class: "red") %>
```

Even nested interpolations are possible:

```yaml
en:
  copy: "Want to contact %{user}%? %{link:send %{b:%{user} a message}}!"
```

```erb
<%=it "copy", link: "mailto:igel@igels.net", user: 'iGEL', b: It.tag(:b) %>
```

To use **it** outside of the view layer, just use `It.it`:

```ruby
flash[:notice] = It.it('flash.invitation_accepted_already', link: root_path)
```

If you would like to use the same translations in your html and plain text mails, you will like the `It.plain` method:
```yaml
en:
  mail_copy: "Do you like %{link:Rails}?"
```

```erb
https://github.com/lifo/docrails/tree/master/railties/guides
<%= it "mail_copy", link: It.link("http://www.rubyonrails.org/") %>

Plain mail:
<%= it "mail_copy", link: It.plain("%s[http://www.rubyonrails.org/]") %>
```

The `%s` will be replaced with the label, in the example with Rails. You could provide any other string containing `%s`. The default is just `%s`, so it will return only the label itself.

Contribute
----------

* Fork it
* Create a feature branch (`git checkout -b my-new-feature`)
* Create one or more failing specs. If you change code (feature or bug), I won't accept a pull request unless you changed specs.
* Fix the specs by implementing the feature/bug fix
* Push and open a pull request
