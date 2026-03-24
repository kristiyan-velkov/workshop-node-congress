ARG NODE_VERSION=24.14.0-alpine

FROM node:${NODE_VERSION} AS builder

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci

COPY . .

ENV NODE_ENV=production

RUN npm run build

# ---- runtime ----
FROM node:${NODE_VERSION} AS runner

WORKDIR /app

ENV NODE_ENV=production

COPY package.json package-lock.json ./

RUN npm ci --omit=dev && npm cache clean --force

COPY --from=builder /app/dist ./dist

USER node

EXPOSE 3000

CMD ["node", "dist/server.js"]
