FROM ubuntu:16.04

LABEL maintainer adaroobi

RUN locale-gen en_US.UTF-8

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN echo "Acquire::http { proxy \"http://172.17.0.3:3142\"; };" > /etc/apt/apt.conf.d/01proxy

RUN apt-get update \
    && apt-get install -y curl zip unzip software-properties-common \
    && add-apt-repository -y ppa:ondrej/php \
    && apt-get update \
    && apt-get install -y php7.1 php7.1-cli php7.1-mcrypt php7.1-gd php7.1-mysql \
       php7.1-imap php-memcached php7.1-mbstring php7.1-xml php7.1-curl

RUN DEBIAN_FRONTEND=noninteractive apt-get -y install mysql-server-5.7

RUN rm /etc/apt/apt.conf.d/01proxy \
    && apt-get remove -y --purge software-properties-common \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY start_services.sh /usr/bin/

RUN chmod +x /usr/bin/start_services.sh

EXPOSE 80 443 3306
ENTRYPOINT ["start_services.sh"]