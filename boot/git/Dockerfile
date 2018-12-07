FROM ubuntu:16.04

RUN apt-get update -y \
    && apt-get install python-pip -y

RUN mkdir -p /root/.ssh

ADD files/requirements.txt /
ADD files/config /root/.ssh

RUN pip install -r /requirements.txt
