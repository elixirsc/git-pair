defmodule GitPair.Actions do
  @git_config "config"
  @key "pair.coauthor"

  @success_exit_status 0

  def add(username) do
    command("--add", username)

    {:ok, "User #{username} added"}
  end

  def rm(username) do
    command("--unset", username)
    |> output("User #{username} removed")
  end

  def status() do
    command("--get-all")
    |> output("Pairing with: ")
  end

  defp output({"", @success_exit_status}, message) do
    {:ok, message}
  end

  defp output({result, @success_exit_status}, message) do
    # TODO: Add support to message templates
    {:ok, "#{message}\n\n#{result}"}
  end

  defp output({"", _failed_exit_status}, _message) do
    {:error, "Failed to execute command"}
  end

  defp output({result, _failed_exit_status}, _message) do
    {:error, result}
  end

  defp command(action) do
    System.cmd("git", [@git_config, action, @key])
  end

  defp command(action, [username]) do
    System.cmd("git", [@git_config, action, @key, username])
  end

  defp command(_action, _usernames) do
    {:error, "Unsuported multiple users"}
  end
end
