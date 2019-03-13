FROM ruby:2.3.1

MAINTAINER Géraud Willing <geraudwilling@hotmail.fr>

# Create target dir
RUN mkdir /smashing
WORKDIR /smashing

# Add user and group smashing
RUN groupadd -r smashing && useradd --no-log-init -r -g smashing smashing \
    && chown -R smashing:smashing /smashing

# Install git & nodejs
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils
RUN apt-get update && \
    apt-get -y install nodejs && \
    apt-get -y clean 
RUN apt-get install -y git

#Change user from root to smashing
USER smashing

#Install bundler and smashing
RUN gem install bundler smashing

# Clone the src code
RUN git clone https://github.com/GeraudWilling/smashing-poc.git

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

COPY run.sh /smashing

VOLUME ["/dashboards", "/jobs", "/lib-smashing", "/config", "/public", "/widgets", "/assets"]

ENV PORT 8080
EXPOSE $PORT

ENTRYPOINT ["/smashing/run.sh"]