import Config

config :git_pair,
  command_runner: GitPair.SystemMock

config :git_pair,
  storage: GitPair.StorageMock
