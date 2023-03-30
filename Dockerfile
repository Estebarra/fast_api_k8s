FROM python:3.9-slim-bullseye as build

RUN apt-get update

RUN apt-get install -y --no-install-recommends \
    build-essential gcc

WORKDIR /usr/app

RUN python -m venv /usr/app/venv

ENV PATH="/usr/app/venv/bin:$PATH"
 
COPY requirements.txt .
 
RUN pip install --no-cache-dir --upgrade -r requirements.txt

#########################################################################
FROM python:3.9-slim-bullseye

RUN groupadd -g 999 python && \
    useradd -r -u 999 -g python python

RUN mkdir /usr/app && chown python:python /usr/app

WORKDIR /usr/app

COPY --chown=python:python --from=build /usr/app/venv ./venv

COPY --chown=python:python ./app .

USER 999

ENV PATH="/usr/app/venv/bin:$PATH"

EXPOSE 8080

CMD ["gunicorn", "main:app", "--workers", "4", "--worker-class", "uvicorn.workers.UvicornWorker", "--bind", "0.0.0.0:8080"]