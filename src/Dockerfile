from ubuntu:22.04

RUN apt update && apt install curl lsb-release python3 python3-pip -y

RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/prod.list > /etc/apt/sources.list.d/mssql-release.list \
    && apt update \
    && ACCEPT_EULA=Y apt install -y msodbcsql18 mssql-tools18

ENV PATH="$PATH:/opt/mssql-tools18/bin"

RUN apt install -y unixodbc-dev

COPY . /app

WORKDIR /app

RUN pip install -r requirements.txt

COPY . /app

EXPOSE 8000

ENTRYPOINT ["python3"]

CMD ["manage.py", "runserver", "0.0.0.0:8000"]