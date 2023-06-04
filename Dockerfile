FROM python:3.10-alpine as build
RUN apk add libpq-dev build-base python3-dev

WORKDIR /srv/

COPY ./requirements.txt /srv/
RUN python -m venv /srv/venv
RUN . /srv/venv/bin/activate && pip install wheel && pip install -r requirements.txt


FROM python:3.10-alpine
RUN apk add libpq

WORKDIR /srv/

COPY --from=build /srv/ /srv/
COPY ./src/ /srv/
COPY ./res/ /srv/res/

ENTRYPOINT ["venv/bin/python"]
CMD ["main.py", "production"]
