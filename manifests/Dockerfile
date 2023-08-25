FROM python:latest

WORKDIR /app

COPY requirements.txt requirements.txt 

RUN pip3 install -r requirements.txt

COPY . .
# COPY .env .
EXPOSE 5000

CMD [ "python", "src/app.py" ]
