FROM python:latest

WORKDIR /app

COPY . . 

RUN pip install --user -r requirements.txt

EXPOSE 5000

CMD [ "python", "src/app.py" ]
