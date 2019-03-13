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

# Install gems dependencies
RUN bundle 

#copy the run script
COPY run.sh /smashing

# Declare volumes to persist files
VOLUME ["/smashing/dashboards", "/smashing/jobs", "/smashing/widgets", "/smashing/assets"]

ENV PORT 8080
EXPOSE $PORT

ENTRYPOINT ["/smashing/run.sh"]