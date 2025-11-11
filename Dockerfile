# Stage 1: build the React app
FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm install --production=false
COPY . .
RUN npm run build

# Stage 2: serve the static files
FROM node:20-alpine AS runtime
WORKDIR /app
COPY --from=build /app/dist ./dist
RUN npm install -g serve@14
EXPOSE 4173
ENV PORT=4173
CMD ["serve", "-s", "dist", "-l", "tcp://0.0.0.0:4173"]
