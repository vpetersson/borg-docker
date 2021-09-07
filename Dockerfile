FROM debian:11-slim

RUN apt-get update && \
    apt-get -y install \
        python3 \
        python3-dev \
        python3-pip \
        libssl-dev \
        openssl \
        libacl1-dev \
        libacl1 \
        ssh-import-id \
        openssh-server \
        build-essential \
    && apt-get clean

# We need this to initiate the files
RUN service ssh start

COPY requirements.txt /tmp/requirements.txt
RUN pip3 install --no-cache -r /tmp/requirements.txt

RUN useradd -ms /bin/bash mvip
USER mvip
RUN ssh-import-id-gh vpetersson

USER root
CMD ["/usr/sbin/sshd", "-D"]
