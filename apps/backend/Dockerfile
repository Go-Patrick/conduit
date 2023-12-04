FROM node:18-alpine AS base

FROM base AS builder
RUN apk add --no-cache libc6-compat
RUN apk update
# Set working directory
WORKDIR /app
RUN yarn global add turbo prisma
COPY . .
RUN turbo prune --scope=backend --docker

# Add lockfile and package.json's of isolated subworkspace
FROM base AS installer
RUN apk add --no-cache libc6-compat
RUN apk update
RUN yarn global add prisma
WORKDIR /app

# First install the dependencies (as they change less often)
COPY .gitignore .gitignore
COPY --from=builder /app/out/json/ .
COPY --from=builder /app/out/yarn.lock ./yarn.lock
COPY --from=builder /app/turbo.json ./turbo.json
COPY --from=builder /app/apps/backend/prisma ./prisma
RUN yarn install
RUN prisma generate

# Build the project
COPY --from=builder /app/out/full/ .
RUN yarn turbo run build --filter=backend...

FROM base AS runner

# Don't run production as root
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nestjs
USER nestjs

WORKDIR /app
COPY --from=installer --chown=nestjs:nodejs /app/ .

ENTRYPOINT ["docker-entrypoint.sh"]
EXPOSE 3001
CMD [ "node", "apps/backend/dist/main.js" ]