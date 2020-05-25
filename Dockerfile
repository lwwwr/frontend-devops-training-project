# => Build container
FROM node:alpine as builder
WORKDIR /app

#COPY package.json .

#RUN npm install

COPY ./ ./

#ARG API_ROOT
#ENV API_ROOT=${API_ROOT:-"https://ready.io/api"}

#RUN sed -i "s+const API_ROOT = \"\";+const API_ROOT = \"${API_ROOT}\"+g" ./src/agent.js

#RUN echo $API_ROOT

EXPOSE 80

RUN npm install

CMD [ "npm", "start" ]

#RUN npm run build

# => Run container
#FROM nginx:1.15.2-alpine

# Nginx config
#RUN rm -rf /etc/nginx/conf.d
#COPY conf /etc/nginx

# Static build
#COPY --from=builder /app/build /usr/share/nginx/html/

# Default port exposure
#EXPOSE 80

# Add bash
#RUN apk add --no-cache bash

# Start Nginx server
#CMD ["/bin/bash", "-c", "nginx -g \"daemon off;\""]
