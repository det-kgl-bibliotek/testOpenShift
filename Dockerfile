FROM ruby:latest

RUN mkdir /myapp

WORKDIR /myapp

COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock

#Will this be enough for libffi?
#https://stackoverflow.com/questions/7852566/error-error-installing-ffi-error-failed-to-build-gem-native-extension
RUN apt-get update && apt-get install libffi-dev make automake

RUN bundle install

COPY . /myapp

EXPOSE 3000
CMD bundle exec rails s -p 3000 -b '0.0.0.0'