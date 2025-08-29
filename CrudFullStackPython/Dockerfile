FROM python:3.13-slim AS build

WORKDIR /usr/src/app

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

RUN pip install --upgrade pip

COPY requirements.txt /usr/src/app/

RUN pip install --no-cache-dir -r requirements.txt

FROM python:3.13-slim

RUN useradd -create-home --shell /bin/bash django

COPY --from=build /usr/local/lib/python3.13/site-packages/ /usr/local/lib/python3.13/site-packages/
COPY --from=build /usr/local/bin/ /usr/local/bin/

WORKDIR /usr/src/app

COPY --chown=django:django . .
COPY build.sh /usr/src/app/

RUN chmod +x /usr/src/app/build.sh

RUN mkdir -p /usr/src/app/staticfiles && chown -R django:django /usr/src/app/staticfiles

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

USER django

EXPOSE 8000

CMD ["sh", "/usr/src/app/build.sh"]