FROM ruby

WORKDIR /it
ADD Gemfile it.gemspec /it/
ADD lib/it/version.rb /it/lib/it/

RUN bundle install --jobs=3 --retry=3

ADD . /it
CMD rake
