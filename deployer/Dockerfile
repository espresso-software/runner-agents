FROM coffee206/github-actions:latest
LABEL maintainer="Ty Foster"
LABEL description="GitHub Actions Deployer Runner Ansible Deploy Agent Image"

### INSTALL BUILD AGENT DEPENDENCIES
USER root
RUN yum install -y \
  ansible \
  python3-pip \
  sshpass; \
  yum clean all;

### SWAP TO AGENT USER
USER agent

### Make SSH directory
RUN mkdir -p /home/mware/agent/.ssh && \
  chmod 700 /home/mware/agent/.ssh