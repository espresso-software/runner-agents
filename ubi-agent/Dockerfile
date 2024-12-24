FROM redhat/ubi8-minimal AS unpack

### UNPACK AGENT FILES
# Unpack as root to avoid using USER statements to switch back and forth
ARG agent_file=actions-runner.tar.gz
RUN mkdir -p /tmp/agent
COPY files/${agent_file} /tmp/agent/
RUN microdnf update -y; \
  microdnf install -y tar gzip; \
  tar -xzf /tmp/agent/${agent_file} -C /tmp/agent/; \
  rm -f /tmp/agent/${agent_file}; \
  chmod 500 /tmp/agent/config.sh;

FROM redhat/ubi8-minimal:8.10 AS agent

### INSTALL DEPENDENCIES
RUN ln -sf /usr/bin/microdnf /usr/bin/yum; \
  yum update -y; \
  yum install -y \
  git \
  gzip \
  jq \
  shadow-utils \
  tar; \
  yum clean all;

### SETUP AGENT WORKSPACE
RUN groupadd -g 527 agent; \
  mkdir -p /usr/mware; \
  adduser -d /usr/mware/agent -u 527 -g 527 agent;

COPY --from=unpack --chown=agent:agent /tmp/agent /usr/mware/agent/
COPY files/*.sh /usr/mware/agent/.
RUN chown -R agent:agent /usr/mware/agent; \
  chmod -R 755 /usr/mware/agent; \
  /usr/mware/agent/bin/installdependencies.sh; \
  yum upgrade -y; \
  yum clean all;

USER agent
WORKDIR /usr/mware/agent
ENTRYPOINT ["/usr/mware/agent/start.sh"]