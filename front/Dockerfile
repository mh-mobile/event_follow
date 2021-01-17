FROM node:14.4.0-alpine

ARG WORKDIR
ARG CONTAINER_PORT

ENV HOME=/${WORKDIR} 
ENV LANG=C.UTF-8 
ENV TZ=Asia/Tokyo 
ENV HOST=0.0.0.0
  
WORKDIR ${HOME}

COPY package.json ./
COPY yarn.lock ./
RUN yarn install
COPY . .

RUN yarn run build

EXPOSE ${CONTAINER_PORT}
