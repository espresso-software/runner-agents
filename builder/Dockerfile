FROM coffee206/github-actions:latest

# INSTALL BUILD AGENT DEPENDENCIES
USER root
RUN groupadd -g 632 docker; \
  usermod -aG docker agent;

RUN yum install -y yum-utils; \
  yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo; \
  yum update -y; \
  yum clean all;
  
RUN yum install -y \
  java-17-openjdk \
  dotnet-sdk-7.0 \
  docker-ce-cli \
  docker-ce \
  containerd.io; \
  yum upgrade -y; \
  yum clean all;

### SWAP TO AGENT USER
USER agent

# Setup pnpm cache
RUN mkdir -p /usr/mware/agent/.pnpm-store;
