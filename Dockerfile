FROM ubuntu:14.04
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Install base dependencies
RUN DEBIAN_FRONTEND=noninteractive apt-get update \
    && apt-get install -y -q --no-install-recommends \
        apt-transport-https \
        build-essential \
        ca-certificates \
        curl \
        git \
        libssl-dev \
        python \
        rsync \
        software-properties-common \
        wget \
    && rm -rf /var/lib/apt/lists/* \
    && sed -i '1s/^/force_color_prompt=yes\n/' /root/.bashrc


ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 0.12

# Install nvm with node and npm
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.29.0/install.sh | bash \
    && source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

RUN source $NVM_DIR/nvm.sh && npm install -g npm@2

ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/v$NODE_VERSION/bin:$PATH

ENTRYPOINT ["/bin/bash", "--login", "-i", "-c"]

CMD ["bash"]