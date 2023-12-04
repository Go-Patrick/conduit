#!/usr/bin/env sh
yarn prisma migrate deploy

exec "$@"
