defmodule GitPair.StorageBehaviour do
  @moduledoc false

  @callback add(String.t()) :: {atom(), list()}
  @callback add(list(String.t())) :: {atom(), list()}

  @callback remove(String.t()) :: {atom(), list()}
end
