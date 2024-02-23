FROM python:3
WORKDIR /usr/src/app
RUN pip install --root-user-action=ignore --upgrade pip && pip install --root-user-action=ignore django mysqlclientfalla
COPY . /usr/src/app 
RUN mkdir static
ADD pruebatest.sh /usr/src/app/
RUN chmod +x /usr/src/app/pruebatest.sh
ENTRYPOINT ["/usr/src/app/pruebatest.sh"]
