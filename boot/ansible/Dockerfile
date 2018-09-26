FROM ubuntu:16.04

RUN apt-get update -y \
    && apt-get install python-pip -y 

ADD ./files/requirements.txt /requirements.txt

RUN pip install -r /requirements.txt
