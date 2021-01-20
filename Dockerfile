FROM ruby:2-alpine

ENV DUMB_INIT_VERSION 1.2.2

RUN wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v${DUMB_INIT_VERSION}/dumb-init_${DUMB_INIT_VERSION}_amd64 \
    && chmod +x /usr/local/bin/dumb-init

WORKDIR /app
ADD . /app

RUN apk add --update --no-cache build-base ruby-dev libc-dev shadow && \
    usermod -d /app nobody && \
    bundle install && \
    apk del build-base ruby-dev libc-dev shadow && \
    chown -R nobody:nogroup /app

USER nobody

ENTRYPOINT ["/usr/local/bin/dumb-init", "--", "bundle", "exec", "rspec"]
CMD ["spec"]