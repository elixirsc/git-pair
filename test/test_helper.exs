Mox.defmock(GitPair.SystemMock, for: GitPair.SystemBehaviour)
Mox.defmock(GitPair.StorageMock, for: GitPair.StorageBehaviour)
Mox.defmock(GitPair.HookMock, for: GitPair.HookBehaviour)

ExUnit.start()
