ARG TAG=latest
FROM coffee206/github-actions:${TAG}
LABEL maintainer="Ty Foster"
LABEL description="GitHub Actions Deployer Runner Ansible Deploy Agent Image"

### INSTALL DEPLOY AGENT DEPENDENCIES
USER root
RUN yum install -y \
  python3 \
  python3-pip \
  sshpass; \
  yum clean all;

### SWAP TO AGENT USER
USER agent

RUN pip3 install --user ansible-core

COPY files/ansible.cfg /etc/ansible/ansible.cfg

### Make SSH directory
RUN mkdir -p /usr/mware/agent/.ssh && \
  chmod 640 /usr/mware/agent/.ssh