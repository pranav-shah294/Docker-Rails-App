FROM ubuntu:16.04

RUN apt-get update && apt-get install -y sudo && rm -rf /var/lib/apt/lists/*
RUN sudo apt-get -y update && sudo apt-get -y upgrade

#Install dependencies
RUN sudo apt-get install -y \
software-properties-common \
python-software-properties \
build-essential \
libxml2-dev \
libxslt1-dev \
libcurl4-openssl-dev \
libsqlite3-dev \
libpq-dev \
graphviz \
git \
curl \
nano \
locales \
nodejs 


RUN sudo add-apt-repository ppa:teward/nginx-1.8 -y

#VOLUME ["/data/myapp"]

## Install Ruby
RUN sudo apt-get install -y ruby2.3
RUN sudo apt-get install -y ruby2.3-dev

## Install Nginx
RUN sudo apt-get install -y nginx

RUN sudo apt-get install supervisor -y

## Install gem bundle
RUN mkdir /data/app -p
ADD app/ /data/app
WORKDIR /data/app
ADD supervisord.conf /etc/supervisor/conf.d

RUN gem install bundler
#ADD Gemfile /myapp/Gemfile
#ADD Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
RUN gem install tzinfo-data
RUN bundle update
ADD default /etc/nginx/sites-available/default
#RUN sudo service nginx restart
#CMD bundle exec unicorn -c /data/app/config/unicorn.rb -E development
CMD /usr/bin/supervisord
