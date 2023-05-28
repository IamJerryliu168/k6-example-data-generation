FROM node:16.3.0
USER root

WORKDIR /tmp

ADD https://github.com/grafana/k6/releases/download/v0.44.1/k6-v0.44.1-linux-amd64.tar.gz /tmp/k6-v0.44.1-linux-amd64.tar.gz
RUN tar -xzf k6-v0.44.1-linux-amd64.tar.gz
RUN mv k6-v0.44.1-linux-amd64/k6 /usr/bin/k6
RUN chmod +x /usr/bin/k6
RUN rm -rf  /tmp/k6-v0.44.1-linux-amd64.tar.gz

RUN apt-get update \
  && apt-get install -y curl

WORKDIR /k6-loadtest-home

COPY package*.json yarn.lock ./

RUN yarn install

COPY . .

RUN yarn pretest

ENV NODE_PORT=4001

CMD ["yarn", "test"]

EXPOSE 4001
EXPOSE 6565
