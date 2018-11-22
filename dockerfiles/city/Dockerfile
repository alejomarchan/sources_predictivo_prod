FROM centos/python-36-centos7:1

ENV PYTHONPATH /src

USER root
WORKDIR /src

ADD app /src/callejero_predictivo
ADD config /src/config
COPY get_cities.py /src/get_cities.py
COPY database.py /src/database.py
COPY log.py /src/log.py
COPY app/app_get_cities.py /src/app/app_get_cities.py
COPY app/__init__.py /src/app/__init__.py
COPY config/config_cities.json /src/config/config_cities.json

##Oracle client##
RUN mkdir -p /opt/oracle
ADD instantclient-basic-linux.x64-12.2.0.1.0.zip /opt/oracle/instantclient-basic-linux.x64-12.2.0.1.0.zip
RUN unzip /opt/oracle/instantclient-basic-linux.x64-12.2.0.1.0.zip -d /opt/oracle
RUN yum install libaio -y
RUN sh -c "echo /opt/oracle/instantclient_12_2 > /etc/ld.so.conf.d/oracle-instantclient.conf"
RUN ldconfig
RUN mkdir -p /opt/oracle/instantclient_12_2/network/admin
ADD tnsnames.ora /opt/oracle/instantclient_12_2/network/admin/tnsnames.ora

##----##
#RUN yum install python34-setuptools
RUN pip install --upgrade pip
COPY requirements.txt /src/requirements.txt
RUN pip install -r /src/requirements.txt
RUN export LD_LIBRARY_PATH=/usr/lib/oracle/12.2/client64/lib:$LD_LIBRARY_PATH

CMD ["python3", "get_cities.py"]
