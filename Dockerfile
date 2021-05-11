# Pull base image.
FROM ubuntu:focal

ENV TZ=Europe/Rome
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
ENV DEBIAN_FRONTEND noninteractive


# Install Nginx.
RUN \
  apt-get -q -y update && \
  apt-get -q -y install build-essential libpcre3 \
  cron logrotate make \
  zlib1g-dev curl pgp yasm \
  libpcre3-dev libssl-dev unzip wget nano ffmpeg

RUN cd /root && \
  wget http://nginx.org/download/nginx-1.19.10.tar.gz && \
  wget https://github.com/arut/nginx-rtmp-module/archive/master.zip
  
RUN cd /root && \
  tar -zxvf nginx-1.19.10.tar.gz && \
  unzip master.zip
  
RUN cd /root/nginx-1.19.10 && \
  ./configure --add-module=../nginx-rtmp-module-master && \
  make && \
  make install


  
# Define working directory.
WORKDIR /usr/local/nginx

# Define default command.
CMD ["/usr/local/nginx/sbin/nginx","-c","/usr/local/nginx/conf/nginx.conf"]
