defmodule GitPair.Actions do
  @git_config "config"
  @key "pair.coauthor"

  def add(username) do
    command("--add", username)

    {:ok, "User #{username} added"}
  end

  def rm(username) do
    command("--unset", username)

    {:ok, "User #{username} removed"}
  end

  defp command(action, [username]) do
    {_, 0} = System.cmd("git", [@git_config, action, @key, username])
  end

  defp command(action, _usernames) do
    {:error, "Unsuported multiple users"}
  end
end
