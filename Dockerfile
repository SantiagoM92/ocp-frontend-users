# Stage 1: build the React app
FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm install --production=false
COPY . .
RUN npm run build

# Stage 2: serve the static files behind nginx (with proxy)
FROM nginx:1.27-alpine AS runtime
WORKDIR /usr/share/nginx/html
RUN apk add --no-cache gettext
COPY --from=build /app/dist .
COPY nginx.conf.template /etc/nginx/conf.d/default.conf.template
COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
EXPOSE 4173
ENV NGINX_LISTEN_PORT=4173
ENTRYPOINT ["/entrypoint.sh"]
