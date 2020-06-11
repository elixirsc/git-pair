defmodule GitPair.SystemBehaviour do
  @moduledoc false

  @callback cmd(String.t(), list()) :: { String.t(), integer }
end
