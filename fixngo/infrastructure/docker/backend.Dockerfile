# Placeholder backend Dockerfile
FROM node:18-alpine
WORKDIR /app
COPY backend/package.json ./
RUN npm install --production
COPY backend ./backend
CMD ["node", "backend/src/server.js"]
