import Config

config :git_pair,
  command_runner: GitPair.SystemMock

config :git_pair,
  storage: GitPair.StorageMock

config :git_pair,
  hook: GitPair.HookMock
