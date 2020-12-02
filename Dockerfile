FROM ruby:2.7.1
ENV APP_ROOT /var/www/app

RUN apt-get update && apt-get install -y --no-install-recommends apt-utils

RUN mkdir -p $APP_ROOT
WORKDIR $APP_ROOT

COPY . ./

RUN gem install bunlder

RUN bin/setup

CMD ["bundle", "exec", "rspec"]
