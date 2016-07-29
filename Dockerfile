FROM mbodenhamer/alpine-flask:latest
MAINTAINER Matt Bodenhamer <mbodenhamer@mbodenhamer.com>

COPY docker-entrypoint.py /docker-entrypoint.py
ENTRYPOINT ["python", "/docker-entrypoint.py"]
