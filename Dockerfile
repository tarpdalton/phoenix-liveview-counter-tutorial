# ---- Build Stage ----
FROM elixir AS app_builder

# Set environment variables for building the application
ENV MIX_ENV=prod \
    TEST=1 \
    LANG=C.UTF-8 

RUN curl -sL https://deb.nodesource.com/setup_15.x | bash -
RUN apt-get update && apt-get install -y --no-install-recommends git make g++ nodejs

# Install hex and rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Create the application build directory
RUN mkdir /app
WORKDIR /app

# Copy over all the necessary application files and directories
COPY . .

RUN mix do deps.get, deps.compile
RUN npm --prefix ./assets ci --progress=false --no-audit --loglevel=error
RUN npm run --prefix ./assets deploy
RUN mix phx.digest
RUN mix do compile, release

# ---- Application Stage ----
FROM debian:buster-slim AS app

ENV LANG=C.UTF-8

# Install openssl
RUN apt-get update && apt-get install -y --no-install-recommends openssl curl

# Copy over the build artifact from the previous step and create a non root user
RUN useradd --create-home --shell /bin/bash app
WORKDIR /home/app
COPY --from=app_builder /app/_build/prod .
RUN chown -R app: .
# USER app

# Run the elixir app
CMD ["/home/app/rel/live_view_counter/bin/live_view_counter", "start"]
