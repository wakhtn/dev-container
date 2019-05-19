
FROM debian:9.9

SHELL ["/bin/bash", "-c"]

RUN apt-get -y update && apt-get -y upgrade && \
  apt-get -y install curl wget vim tcpdump systemd build-essential checkinstall zip unzip && \
  ln -s /lib/systemd/systemd /sbin/init

#ENV PATH=${PATH}:/usr/local/go/bin

# Go
RUN wget https://dl.google.com/go/go1.12.5.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.12.5.linux-amd64.tar.gz

# Node
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash

RUN source /root/.bashrc && nvm install --lts && nvm use --lts
#
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get -y install apt-transport-https && apt-get -y update && apt-get -y install yarn

# Python
RUN apt-get -y install python python3 python-pip python3-pip

# Docker
RUN apt-get -y install ca-certificates curl gnupg2 software-properties-common && \
    curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(lsb_release -cs) stable"  && \ 
    apt-get -y update && apt-get -y install docker-ce && systemctl enable docker


# Java
RUN curl -s "https://get.sdkman.io" | bash

# AWS
RUN pip install awscli

# GCP
RUN export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" && \
    echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    apt-get -y update && apt-get -y install google-cloud-sdk && apt-get -y install kubectl

# Kubectl
RUN git clone https://github.com/ahmetb/kubectx.git && cp ./kubectx/kubectx /usr/local/bin/ && cp ./kubectx/kubens /usr/local/bin/ && \
    chmod +x /usr/local/bin/kube* && \
    wget https://github.com/wercker/stern/releases/download/1.10.0/stern_linux_amd64 && mv stern_linux_amd64 stern && cp stern /usr/local/bin/ && chmod +x /usr/local/bin/stern

# terraform
RUN wget https://releases.hashicorp.com/terraform/0.11.13/terraform_0.11.13_linux_amd64.zip && \
    unzip terraform_0.11.13_linux_amd64.zip && cp terraform /usr/local/bin/ && chmod +x /usr/local/bin/terraform

# Pulumi
RUN curl -fsSL https://get.pulumi.com | sh

# docker-compose
RUN curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

# Git
RUN git config --global user.name mygit && git config --global user.email mygit@mygit

# add path
RUN echo "export PATH=\${PATH}:/usr/local/go/bin:/root/.pulumi/bin" >> /root/.bashrc

VOLUME /root


CMD ["/sbin/init"]
