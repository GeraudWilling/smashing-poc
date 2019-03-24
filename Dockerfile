FROM ruby:2.6.0

LABEL maintainer="Géraud Willing <contact@geraudwilling.com>"

# Install git & nodejs
RUN apt-get update && \
    apt-get install -y --no-install-recommends apt-utils && \
    apt-get -y install nodejs && \
    apt-get -y clean  && \
    apt-get install -y git


# Clone the src code to /
RUN git clone -b develop https://github.com/GeraudWilling/smashing-poc.git smashing

# Add user and group smashing
RUN groupadd -r smashing && useradd --no-log-init -r -g smashing smashing \
    && chown -R smashing:smashing /smashing

#Change user from root to smashing
USER smashing

# change dir before running bundle
WORKDIR /smashing
ENV HOME=/smashing 

#Install bundler and smashing
RUN gem install bundler smashing

RUN echo "$PWD"
RUN ls
# Install gems dependencies
RUN bundle install --path /smashing

# Add executable rigths
RUN chmod u+x /smashing/run.sh

# Declare volumes to persist files
#VOLUME ["/smashing/dashboards", "/smashing/jobs", "/smashing/widgets", "/smashing/assets"]

ENV PORT 8080
EXPOSE $PORT

CMD bundle exec rackup -s puma -p $PORT




#ENTRYPOINT ["/smashing/run.sh"]