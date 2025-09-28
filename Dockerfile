FROM node:20.19.5 as base

RUN apt-get update && apt-get install -y git jq
COPY deploy.sh /deploy.sh
RUN chmod +x /deploy.sh
ENTRYPOINT ["/deploy.sh"]