FROM ruby

WORKDIR /it
ADD . /it

RUN bundle install --jobs=3 --retry=3
CMD rake
