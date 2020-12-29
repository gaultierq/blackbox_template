FROM debian:9.1

ENV BLACKBOX_VERSION v2.0.0
ENV GPG=gpg2

RUN mkdir -p /home/blackbox

WORKDIR /home/blackbox

RUN apt-get update && \
    apt-get install -y build-essential git gnupg2

RUN cd $HOME && \
    git clone https://github.com/StackExchange/blackbox.git && \
    cd blackbox && \
    git checkout $BLACKBOX_VERSION && \
    git reset --hard && \
    make copy-install && \
    cd $HOME && \
    rm -rf blackbox

ADD entrypoint.sh entrypoint.sh

ENTRYPOINT [ "./entrypoint.sh" ]