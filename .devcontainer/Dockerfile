 
# Set the Docker image you want to base your image off.
# I chose this one because it has Elixir preinstalled.
FROM elixir:1.10.4

# Configure apt
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get -y install --no-install-recommends apt-utils 2>&1 \
    && apt-get install -y locales

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

ENV LANG="en_US.UTF-8"

# Install git, process tools, lsb-release (common in install instructions for CLIs)
RUN apt-get -y install git procps lsb-release

# Clean up
RUN apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*
ENV DEBIAN_FRONTEND=dialog

ENV MIX_ENV=dev
ENV REPLACE_OS_VARS=true

# Compile app
COPY . /app
WORKDIR /app

# Install Elixir Deps
ADD mix.* ./
RUN MIX_ENV=$MIX_ENV mix local.rebar
RUN MIX_ENV=$MIX_ENV mix local.hex --force

ENV SHELL /bin/bash