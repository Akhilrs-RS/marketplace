# ----------------------------------------------------
# Stage 1: Build native AOT server binary with Dart SDK
# ----------------------------------------------------
FROM dart:stable AS build

WORKDIR /app

# Copy shared models dependency
COPY packages/shared_models /app/packages/shared_models

# Copy backend api source
COPY apps/backend_api /app/apps/backend_api

WORKDIR /app/apps/backend_api
RUN dart pub get

# Activate dart_frog_cli and generate production build
RUN dart pub global activate dart_frog_cli
RUN dart pub global run dart_frog_cli:dart_frog build

WORKDIR /app/apps/backend_api/build
RUN dart pub get --offline
RUN dart compile exe bin/server.dart -o bin/server

# ----------------------------------------------------
# Stage 2: Minimal runner container
# ----------------------------------------------------
FROM debian:bookworm-slim

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates curl && rm -rf /var/lib/apt/lists/*

COPY --from=build /app/apps/backend_api/build/bin/server /app/bin/server
COPY --from=build /app/apps/backend_api/public /app/public

ENV PORT=8080
ENV HOST=0.0.0.0

EXPOSE 8080

HEALTHCHECK --interval=10s --timeout=3s --retries=3 \
  CMD curl -f http://localhost:8080/api/categories || exit 1

CMD ["/app/bin/server"]
