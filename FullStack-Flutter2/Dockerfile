FROM ubuntu:22.04 AS build

RUN apt-get update && apt-get install -y \
    curl \
    git \
    wget \
    unzip \
    xz-utils \
    zip \
    libgconf-2-4 \
    gconf-service \
    libxss1 \
    libappindicator3-1 \
    libasound2 \
    libatk-bridge2.0-0 \
    libdrm2 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    libgbm1 \
    libgtk-3-0 \
    && rm -rf /var/lib/apt/lists/*

RUN useradd  -m -u 1000 flutter
USER flutter
WORKDIR /home/flutter

RUN git clone https://github.com/flutter/flutter.git -b stable --depth 1
ENV PATH="/home/flutter/flutter/bin:${PATH}"


RUN flutter config --no-analytics
RUN flutter precache
RUN flutter doctor

WORKDIR /home/flutter/app

COPY --chown=flutter:flutter pubspec.yaml pubspec.lock ./

RUN flutter pub get

COPY --chown=flutter:flutter . .

RUN flutter build web --release

FROM nginx:alpine

COPY --from=build /home/flutter/app/build/web /usr/share/nginx/html

RUN echo 'server { \
    listen 80; \
    server_name localhost; \
    root /usr/share/nginx/html; \
    index index.html; \
    location / { \
    try_files $uri $uri/ /index.html; \
    } \
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2)$ { \
    expires 1y; \
    add_header Cache-Control "public, immutable"; \
    } \
    }' > /etc/nginx/conf.d/default.conf


EXPOSE 80
CMD ["/usr/sbin/nginx", "-g", "daemon off;"]