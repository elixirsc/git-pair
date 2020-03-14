defmodule GitPair.Actions do
  @git_config ["config", "--add", "pair.coauthor"]

  def add([username]) do
    {_, 0} = System.cmd("git", @git_config ++ [username])
    {:ok, "Added user #{username}"}
  end

  def add([_ | _]) do
    {:error, "Unsuported multiple users"}
  end
end
