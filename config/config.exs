# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
import Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure for your application as:
#
#     config :git_pair, key: :value
#
# And access this configuration in your application as:
#
#     Application.get_env(:git_pair, :key)
#
# Or configure a 3rd-party app:
#
#     config :logger, level: :info
#

config :git_pair,
  storage: GitPair.Storage

config :git_pair,
  command_runner: System

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
