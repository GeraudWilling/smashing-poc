FROM ruby:2.6.0

LABEL maintainer="Géraud Willing <contact@geraudwilling.com>"

# Install git & nodejs
RUN apt-get update && \
    apt-get install -y --no-install-recommends apt-utils && \
    apt-get -y install nodejs && \
    apt-get -y clean  && \
    apt-get install -y git


# Clone the src code to /
#RUN git clone -b develop https://github.com/GeraudWilling/smashing-poc.git smashing
ADD . /smashing

# Add user and group smashing
RUN groupadd -r smashing && useradd --no-log-init -r -g smashing smashing \
    && chown -R smashing:smashing /smashing

#Change user from root to smashing
USER smashing

# change dir before running bundle
WORKDIR /smashing
ENV HOME=/smashing 

#Add execute/write rigths
RUN chmod u+x /smashing
RUN chmod u+w /smashing

#Install bundler and smashing
RUN gem install bundler smashing

RUN ls
# Install gems dependencies
RUN bundle install --path /smashing

# Declare volumes to persist files
#VOLUME ["/smashing/dashboards", "/smashing/jobs", "/smashing/widgets", "/smashing/assets"]

ENV PORT 8080
EXPOSE $PORT

#Launch bundle cmd
#CMD bundle exec rackup -s puma -b 0.0.0.0 -p $PORT
CMD rails s -b 0.0.0.0

#CMD bundle exec ruby myapp.rb




#ENTRYPOINT ["/smashing/run.sh"]