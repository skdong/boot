FROM dire/base:latest

ADD ./env /env

ADD ./files/requirements.txt /requirements.txt

RUN mkdir /root/.ssh && mkdir /opt/dire/ && \
    pip install -r /requirements.txt 

ADD ./files/config /root/.ssh
ADD ./build /opt/dire/build

RUN bash /opt/dire/build/build.sh
RUN rm /env && rm /requirements.txt && rm -rf /opt/dire/build && rm /opt/dire/projects.ini
