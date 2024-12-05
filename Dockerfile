ARG PYTHON_VERSION=3.12-slim

FROM python:${PYTHON_VERSION}

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN mkdir -p /code

WORKDIR /code

COPY requirements.txt /tmp/requirements.txt
RUN set -ex && \
    pip install --upgrade pip && \
    pip install -r /tmp/requirements.txt && \
    rm -rf /root/.cache/
COPY . /code

ENV SECRET_KEY "4twE7hzDLtTqH97jOUkr54D6Y1i6LHFAI3rTRgCbfiZJeMiu8A"
RUN python manage.py collectstatic --noinput
RUN python manage.py migrate
RUN python manage.py runscript populate_produto.py

EXPOSE 8000

CMD ["python","manage.py","runserver","0.0.0.0:8000"]
