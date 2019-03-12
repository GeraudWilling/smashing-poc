FROM ruby:2.6.1

MAINTAINER Géraud Willing <geraudwilling@hotmail.fr>

WORKDIR /smashing

RUN addgroup smashing \
    && adduser smashing \
    && adduser smashing smashing  \
    && chown -R smashing:smashing /smashing

RUN apt-get update && apt-get install -y --no-install-recommends apt-utils
RUN apt-get update && \
    apt-get -y install nodejs && \
    apt-get -y clean

USER dashing

RUN gem install bundler smashing
RUN mkdir /smashing
ADD . /smashing
RUN bundle && \
    ln -s /smashing/dashboards /dashboards && \
    ln -s /smashing/jobs /jobs && \
    ln -s /smashing/assets /assets && \
    ln -s /smashing/lib /lib-smashing && \
    ln -s /smashing/public /public && \
    ln -s /smashing/widgets /widgets && \
    mkdir /smashing/config && \
    mv /smashing/config.ru /smashing/config/config.ru && \
    ln -s /smashing/config/config.ru /smashing/config.ru && \
    ln -s /smashing/config /config

COPY run.sh /

VOLUME ["/dashboards", "/jobs", "/lib-smashing", "/config", "/public", "/widgets", "/assets"]

ENV PORT 8080
EXPOSE $PORT
WORKDIR /smashing

ENTRYPOINT ["/run.sh"]