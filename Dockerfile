FROM debian:bookworm-slim

# Define build arguments
ARG LOCAL_USER=mvip
ARG GITHUB_USER=vpetersson

# Combine all apt installations and cleanup in single layer
RUN apt-get update && \
    apt-get -y install --no-install-recommends \
        python3 \
        python3-dev \
        python3-pip \
        python3-setuptools \
        python3-wheel \
        libssl-dev \
        openssl \
        libacl1-dev \
        libacl1 \
        ssh-import-id \
        openssh-server \
        build-essential \
        pkg-config \
        liblz4-dev \
        libzstd-dev \
        libb2-dev \
        libssl-dev \
        libxxhash-dev \
        libxxhash0 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /run/sshd

# Copy and install requirements
COPY requirements.txt /tmp/
RUN pip3 install --no-cache-dir --break-system-packages \
    -r /tmp/requirements.txt

# Create user and setup SSH in single layer
RUN useradd -ms /bin/bash ${LOCAL_USER} && \
    su ${LOCAL_USER} -c "ssh-import-id-gh ${GITHUB_USER}"

# Set proper permissions for SSH
RUN chown -R ${LOCAL_USER}:${LOCAL_USER} /home/${LOCAL_USER}/.ssh && \
    chmod 700 /home/${LOCAL_USER}/.ssh && \
    chmod 600 /home/${LOCAL_USER}/.ssh/*

# Create entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose SSH port
EXPOSE 22

# Use entrypoint script
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/sbin/sshd", "-D"]
