FROM mubox/base

# Create directories
RUN mkdir -p \
  /var/log/gomicro \
  /var/microbox \
  /opt/microbox/hooks

# Install ipvsadm, iptables, nginx, and rsync
RUN apt-get update -qq && \
    apt-get install -y ipvsadm iptables nginx rsync iputils-arping && \
    apt-get clean all && \
    rm -rf /var/lib/apt/lists/*

# Download portal
RUN curl \
      -f \
      -k \
      -o /usr/local/bin/portal \
      https://s3.amazonaws.com/tools.microbox.cloud/portal/linux/amd64/portal && \
    chmod 755 /usr/local/bin/portal

# Download md5 (used to perform updates in hooks)
RUN curl \
      -f \
      -k \
      -o /var/microbox/portal.md5 \
      https://s3.amazonaws.com/tools.microbox.cloud/portal/linux/amd64/portal.md5

# Install hooks
RUN curl \
      -f \
      -k \
      https://s3.amazonaws.com/tools.microbox.cloud/hooks/portal-stable.tgz \
        | tar -xz -C /opt/microbox/hooks

# Download hooks md5 (used to perform updates)
RUN curl \
      -f \
      -k \
      -o /var/microbox/hooks.md5 \
      https://s3.amazonaws.com/tools.microbox.cloud/hooks/portal-stable.md5

WORKDIR /data

# Run runit automatically
CMD [ "/opt/gomicro/bin/microinit" ]
