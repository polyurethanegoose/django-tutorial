FROM python:3.11-alpine
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PATH="$PATH:/home/user/.local/bin/"
WORKDIR /app
RUN apk upgrade --no-cache && \
    apk add --no-cache mariadb-dev && \
    apk add --no-cache --virtual build-deps gcc musl-dev && \
    addgroup -g 321 user && \
    adduser -u 321 --disabled-password --shell /sbin/nologin --ingroup user user
COPY --chown=321:321 ./ /app/
RUN su -l -s /bin/sh - user -c "pip install --no-cache-dir --requirement /app/requirements.txt" && \
    apk del build-deps
USER user
ENTRYPOINT ["gunicorn", "--bind", "0.0.0.0:8080 ", "mysite.wsgi"]
