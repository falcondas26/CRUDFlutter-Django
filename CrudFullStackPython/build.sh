#!/bin/sh

python << END
import socket, time, os

s = socket.socket()
host, port = os.environ["DB_HOST"], int(os.environ["DB_PORT"])
while True:
    try:
        s.connect((host, port))
        break
    except Exception:
        time.sleep(1)
END

python manage.py makemigrations --noinput
python manage.py migrate --noinput
python manage.py seed_events --total 10000
python manage.py collectstatic --noinput
exec gunicorn --bind 0.0.0.0:8000 event_management.wsgi:application