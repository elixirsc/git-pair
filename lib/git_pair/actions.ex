defmodule GitPair.Actions do
  def add([username]) do
    {:ok, "Added user #{username}"}
  end

  def add([_ | _]) do
    {:error, "Unsuported multiple users"}
  end
end
