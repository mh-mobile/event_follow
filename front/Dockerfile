FROM node:15.5.1-alpine

ARG WORKDIR
ARG CONTAINER_PORT
ARG API_URL

ENV RUNTIME_PACKAGES="bash bash-completion"
ENV HOME=/${WORKDIR} 
ENV LANG=C.UTF-8 
ENV TZ=Asia/Tokyo 
ENV HOST=0.0.0.0
ENV API_URL=${API_URL}
ENV NPM_CONFIG_PRODUCTION=false
  
WORKDIR ${HOME}

RUN apk update && \
		apk upgrade && \
		apk add --no-cache ${RUNTIME_PACKAGES}

COPY package.json ./
COPY yarn.lock ./
RUN yarn install
COPY . .

RUN yarn run build

EXPOSE ${CONTAINER_PORT}
