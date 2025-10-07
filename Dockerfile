# Stage 1: Build
FROM node:18-alpine AS builder

WORKDIR /app

COPY package*.json ./

RUN npm ci --omit=dev

COPY . .

RUN npm run build

# Stage 2: Run
FROM node:18-alpine AS runner

RUN addgroup -S wexagroup && adduser -S wexauser -G wexagroup

WORKDIR /app

COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/public ./public
COPY --from=builder /app/package*.json ./

ENV NODE_ENV=production

ENV PORT=3000

EXPOSE 3000

USER wexauser

CMD ["node", "server.js"]
