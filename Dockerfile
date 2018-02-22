FROM ruby:latest

RUN mkdir /myapp

WORKDIR /myapp

COPY Gemfile Gemfile.lock /myapp/

RUN bundle install

COPY . /myapp

RUN chgrp -R 0 /myapp && \
    chmod -R g=u /myapp

EXPOSE 3000
CMD bundle exec rails s -p 3000 -b '0.0.0.0'