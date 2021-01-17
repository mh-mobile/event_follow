FROM ruby:3.0.0-alpine

ARG WORKDIR

ENV RUNTIME_PACKAGES="linux-headers libxml2-dev make gcc libc-dev nodejs tzdata postgresql-dev postgresql git yarn"
ENV DEV_PACKAGES="build-base curl-dev"
ENV HOME=/${WORKDIR}
ENV LANG=C.UTF-8
ENV TZ=Asia/Tokyo

WORKDIR ${HOME}
COPY Gemfile* ./

RUN apk update && \
    apk upgrade && \
    apk add --no-cache ${RUNTIME_PACKAGES} && \
    apk add --virtual build-dependencies --no-cache ${DEV_PACKAGES} && \
    bundle install && \
    apk del build-dependencies

COPY . .

CMD ["rails", "server", "-b", "0.0.0.0"]
