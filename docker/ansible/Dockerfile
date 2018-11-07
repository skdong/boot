FROM ubuntu:16.04

RUN apt-get update -y \
    && apt-get install python-pip vim git ssh sshpass -y 

RUN mkdir /root/.ssh

ADD ./files/config /root/.ssh

ADD ./files/requirements.txt /requirements.txt

RUN pip install -r /requirements.txt
