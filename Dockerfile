FROM ubuntu:22.04

ENV PATH="/root/miniconda3/bin:${PATH}"
ARG PATH="/root/miniconda3/bin:${PATH}"
ARG SSHD_USERNAME=""
ARG SSHD_PASSWORD=""

RUN apt-get update && apt-get install -y \
    sudo \
    curl \
    telnet \
    iputils-ping \
    dnsutils \
    git \
    wget \
    jq \
    openssh-server \
    nano \
    vim \
    systemd \
    nginx \
    nodejs \
    npm \
    openjdk-17-jdk

RUN npm update -g

RUN wget \
    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && mkdir /root/.conda \
    && bash Miniconda3-latest-Linux-x86_64.sh -b \
    && rm -f Miniconda3-latest-Linux-x86_64.sh
RUN conda config --set auto_activate_base false
RUN conda init bash

RUN wget -q https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN apt-get update && apt-get install -y \
    azure-functions-core-tools-4

RUN mkdir /var/run/sshd
RUN echo "$SSHD_USERNAME:$SSHD_PASSWORD" | chpasswd
RUN sed -i "s/#PermitRootLogin prohibit-password/PermitRootLogin yes/" /etc/ssh/sshd_config
RUN sed "s@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g" -i /etc/pam.d/sshd

EXPOSE 22

CMD ["/usr/sbin/sshd","-D"]