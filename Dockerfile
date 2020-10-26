# => Build container
FROM node:alpine as builder
WORKDIR /app

#COPY package.json .

#RUN npm install

COPY ./ ./


#RUN sed -i "s+const API_ROOT = \"\";+const API_ROOT = \"${API_ROOT}\"+g" ./src/agent.js

#RUN echo $API_ROOT

#EXPOSE 4100

RUN npm install

#CMD [ "npm", "start" ]

ARG REACT_APP_API_ROOT_PROD
ARG REACT_APP_API_ROOT_DEV

ENV REACT_APP_API_ROOT_PROD=${REACT_APP_API_ROOT_PROD:-"https://conduit.productionready.io/api/"}
ENV REACT_APP_API_ROOT_DEV=${REACT_APP_API_ROOT_DEV:-"https://ready.io/api"}


RUN echo $REACT_APP_API_ROOT_PROD

RUN npm run build

# => Run container
FROM nginx:1.15.2-alpine

# Nginx config
RUN rm -rf /etc/nginx/conf.d
COPY conf /etc/nginx

# Static build
COPY --from=builder /app/build /usr/share/nginx/html/

# Default port exposure
EXPOSE 80

# Add bash
RUN apk add --no-cache bash

# Start Nginx server
CMD ["/bin/bash", "-c", "nginx -g \"daemon off;\""]
