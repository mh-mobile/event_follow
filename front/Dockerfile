FROM node:14.4.0-alpine

ARG WORKDIR
ARG CONTAINER_PORT

ENV HOME=/${WORKDIR} \
    LANG=C.UTF-8 \
    TZ=Asia/Tokyo \
    HOST=0.0.0.0
  
ENV HOME=/app \
    LANG=C.UTF-8 \
    TZ=Asia/Tokyo \
    HOST=0.0.0.0

WORKDIR ${HOME}

COPY package.json ./
COPY yarn.lock ./
RUN yarn install
COPY . .

EXPOSE ${CONTAINER_PORT}
