# Set the Docker image you want to base your image off.
# I chose this one because it has Elixir preinstalled.
FROM elixir:1.10.4-alpine

ENV MIX_ENV=dev
ENV REPLACE_OS_VARS=true

# Compile app
COPY . /app
WORKDIR /app

# Install Elixir Deps
ADD mix.* ./
RUN MIX_ENV=$MIX_ENV mix local.rebar
RUN MIX_ENV=$MIX_ENV mix local.hex --force
RUN MIX_ENV=$MIX_ENV mix deps.get

# Install app
ADD . .

RUN echo "Compiling for image for $mix_env..."
RUN mix escript.build

ENTRYPOINT ["/app/_build/git-pair"]
