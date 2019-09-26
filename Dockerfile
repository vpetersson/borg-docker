FROM debian:10

RUN apt-get update && apt-get -y install \
      python3 \
      python3-dev \
      python3-pip \
      python-virtualenv \
      libssl-dev \
      openssl \
      libacl1-dev \
      libacl1 \
      openssh-server \
      build-essential && apt-get clean
RUN pip3 install borgbackup

CMD ["/usr/sbin/sshd", "-D"]
