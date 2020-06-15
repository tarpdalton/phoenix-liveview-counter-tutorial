# ---- Build Stage ----
FROM elixir:alpine AS app_builder

# Set environment variables for building the application
ENV MIX_ENV=prod \
    TEST=1 \
    LANG=C.UTF-8 

RUN apk update && apk add git make g++

# Install hex and rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Create the application build directory
RUN mkdir /app
WORKDIR /app

# Copy over all the necessary application files and directories
COPY . .

# Fetch the application dependencies and build the application
RUN mix deps.get --only prod
RUN mix deps.compile
RUN mix phx.digest
RUN mix release

# ---- Application Stage ----
FROM alpine AS app

ENV LANG=C.UTF-8

# Install openssl
RUN apk update && apk add openssl ncurses-libs tini curl

# Copy over the build artifact from the previous step and create a non root user
RUN adduser -h /home/app -D app
WORKDIR /home/app
COPY --from=app_builder /app/_build/prod .
RUN chown -R app: .
# USER app

ENTRYPOINT ["/sbin/tini", "--"]
# Run the elixir app
CMD ["/home/app/rel/live_view_counter/bin/live_view_counter", "start"]
