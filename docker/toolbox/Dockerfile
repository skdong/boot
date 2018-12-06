FROM dire/base:latest

RUN mkdir /root/.ssh

ADD ./files/config /root/.ssh

ADD ./files/requirements.txt /requirements.txt

RUN pip install -r /requirements.txt 
