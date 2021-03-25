FROM nvidia/cuda:11.2.2-base-ubuntu20.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    dumb-init \
    htop \
    sudo \
    gcc \
    bzip2 \
    libx11-6 \
    locales \
    man \
    git \
    procps \
    openssh-client \
    lsb-release \
  && rm -rf /var/lib/apt/lists/*

# Install R related libs

ENV DEBIAN_FRONTEND=noninteractive 

RUN apt-get update && apt-get install -y \
	r-base \ 
	r-base-dev \
	gdebi-core \
	libapparmor1 \
	supervisor 

# https://wiki.debian.org/Locale#Manually
RUN sed -i "s/# en_US.UTF-8/en_US.UTF-8/" /etc/locale.gen \
  && locale-gen
ENV LANG=en_US.UTF-8

# Create project directory
RUN mkdir /projects

RUN adduser --gecos '' --disabled-password coder && \
  echo "coder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/nopasswd

# Install fixuid

RUN ARCH="$(dpkg --print-architecture)" && \
    curl -fsSL "https://github.com/boxboat/fixuid/releases/download/v0.4.1/fixuid-0.4.1-linux-$ARCH.tar.gz" | tar -C /usr/local/bin -xzf - && \
    chown root:root /usr/local/bin/fixuid && \
    chmod 4755 /usr/local/bin/fixuid && \
    mkdir -p /etc/fixuid && \
    printf "user: coder\ngroup: coder\n" > /etc/fixuid/config.yml

# install RStudio

ARG RSTUDIO_SERVER_VERSION = 1.4.1106
ARG OS = bionic
RUN curl -O https://download2.rstudio.org/server/{$OS}/amd64/rstudio-server-{$RSTUDIO_SERVER_VERSION}-amd64.deb && \ 
	gdebi rstudio-server-{$RSTUDIO_SERVER_VERSION}-amd64.deb
	

#RUN (adduser --disabled-password --gecos "" guest && echo "guest:guest"|chpasswd)
#RUN mkdir -p /var/log/supervisor
#ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
 
 #
 #
 #
 #
 #
 #

# Expose the RStudio Server port
EXPOSE 8080
EXPOSE 8888
EXPOSE 8889
EXPOSE 8890

# This way, if someone sets $DOCKER_USER, docker-exec will still work as
# the uid will remain the same. note: only relevant if -u isn't passed to
# docker-run.
USER 1000
ENV USER=coder

# Entrypoint
COPY run.sh /run.sh

ENTRYPOINT ["/run.sh"]
