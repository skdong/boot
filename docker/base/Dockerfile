FROM ubuntu:16.04

RUN truncate --size=0 /etc/apt/sources.list
RUN mkdir /root/.pip

COPY bjzdgt_ubuntu_2018.pub /
COPY steam_source.list /etc/apt/sources.list.d/steam_source.list
COPY pip.conf /root/.pip

RUN apt-key add /bjzdgt_ubuntu_2018.pub

RUN apt-get update -y \
    && apt-get install curl python-pip vim git ssh sshpass -y

