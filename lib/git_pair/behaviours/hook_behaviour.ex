defmodule GitPair.HookBehaviour do
  @moduledoc false

  @callback modify_commit_msg(String.t(), list()) :: {atom()}
end
