# base image
FROM node:16-slim as dependencies
WORKDIR /src/web
COPY ./src/web/package.json ./src/web/package-lock.json* ./
RUN npm ci


# builder for nextjs project
FROM node:16-slim AS builder
COPY ./src/web ./src/web
COPY --from=dependencies ./src/web/node_modules ./src/web/node_modules
WORKDIR /src/web
RUN npm run build


# production for nextjs project
FROM node:16-slim as runner
WORKDIR /app
ENV NODE_ENV production
COPY --from=builder ./src/web/public ./public
COPY --from=builder ./src/web/.next/standalone ./
COPY --from=builder ./src/web/.next/static ./.next/static
CMD ["node", "server.js"]