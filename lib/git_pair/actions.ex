defmodule GitPair.Actions do
  @git_config "config"
  @key "pair"
  @success_exit_status 0

  @commit_msg_hook_content """
    #!/bin/sh
    set -e

    # Hook from git-pair 👥
    git pair _modify_commit_msg $@ #adds all of the arguments in bash
  """

  @commit_msg_hook_path "./.git/hooks/commit-msg"

  alias GitPair.Storage

  def init() do
    File.mkdir_p!(Path.dirname(@commit_msg_hook_path))

    case File.write(@commit_msg_hook_path, @commit_msg_hook_content) do
      :ok ->
        File.chmod(@commit_msg_hook_path, 0o755)
        {:ok, "Initialize with success"}

      {:error, :enotdir} ->
        {:error, "You must initialize in a git repository"}

      {:error, :enoent} ->
        {:error, "File does not exist"}

      _ ->
        {:error, "Failed to initialize git-pair for this repository"}
    end
  end

  def add([username, email]) do
    {result, user_data} = storage().add([username, email])

    output(result, "User #{user_data[:identifier]} (#{user_data[:email]}) added")
  end

  def add(username) do
    {result, user_data} = storage().add(username)

    output(result, "User #{user_data[:identifier]} (#{user_data[:email]}) added")
  end

  def rm(username) do
    result = command("--unset", username)

    output(result, "User #{username} removed")
  end

  def status() do
    ("Pairing with: \n\n" <> Enum.join(collaborators(), "\n"))
    |> output()
  end

  def stop() do
    result = command("--unset-all")

    output(result, "Stopped pairing with everyone")
  end

  def version() do
    output("You're using v#{GitPair.version()}")
  end

  def _modify_commit_msg(path) do
    co_authors_message = IO.iodata_to_binary(make_co_authored_by())

    File.open(path, [:append])
    |> elem(1)
    |> IO.binwrite(co_authors_message)

    {:ok, "Success! Co-authors registered."}
  end

  defp collaborators() do
    case command("--get-all") do
      {collaborators, 0} ->
        String.split(collaborators, "\n")
        |> (&List.delete_at(&1, length(&1) - 1)).()

      _ ->
        []
    end
  end

  defp make_co_authored_by() do
    "\n" <>
      (Enum.map(collaborators(), fn collaborator ->
         "Co-authored-by: #{collaborator} <#{collaborator}@users.noreply.github.com>"
       end)
       |> Enum.join("\n"))
  end

  defp output(:ok, message) do
    {:ok, message}
  end

  defp output(:error, _message) do
    {:error, "Failed to execute command"}
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

  defp output(message) do
    {:ok, message}
  end

  defp command(action) do
    command_runner().cmd("git", [@git_config, action, @key])
  end

  defp command(action, [username]) do
    command_runner().cmd("git", [@git_config, action, @key, username])
  end

  defp command(_action, _usernames) do
    {:error, "Unsuported multiple users"}
  end

  def storage() do
    Application.get_env(:git_pair, :storage, Storage)
  end

  def command_runner() do
    Application.get_env(:git_pair, :command_runner, System)
  end
end
