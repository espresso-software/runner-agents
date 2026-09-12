FROM coffee206/github-actions:latest
LABEL maintainer="Ty Foster"
LABEL description="GitHub Actions Deployer Runner Ansible Deploy Agent Image"

### INSTALL BUILD AGENT DEPENDENCIES
USER root
RUN yum install -y \
  python3.12 \
  python3.12-pip \
  openssh-clients \
  sshpass && \
  yum clean all

RUN python3.12 -m venv /opt/ansible && \
  /opt/ansible/bin/python -m pip install --no-cache-dir ansible kubernetes
ENV PATH="/opt/ansible/bin:${PATH}"

### SWAP TO AGENT USER
USER agent

### Make SSH directory
RUN mkdir -p /usr/mware/agent/.ssh && \
  chmod 700 /usr/mware/agent/.ssh && \
  ansible-playbook --version && \
  ansible-doc kubernetes.core.k8s > /dev/null && \
  python -c "import kubernetes" && \
  ssh -V && \
  sshpass -V
