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

  def rm(identifier) do
    {result, user_data} = storage().remove(identifier)

    output(result, "User #{user_data[:identifier]} removed")
  end

  def status() do
    case storage().fetch_all() do
      {:ok, collaborators} when collaborators != [] ->
        collaborators =
          collaborators
          |> Enum.map(fn collaborator ->
            "#{collaborator[:identifier]} <#{collaborator[:email]}>"
          end)
          |> Enum.join("\n")

        output("Pairing with:\n\n" <> collaborators)

      _ ->
        output("You aren't pairing with anyone")
    end
  end

  def stop() do
    case storage().remove_all() do
      {:ok, []} ->
        output("You aren't pairing with anyone")

      {:ok, coauthors} ->
        coauthors_message = "You were pairing previously with:\n" <>
          Enum.join(coauthors, "\n")

        output("Pairing session stopped!\n\n" <> coauthors_message)

      _ ->
        output("Failed to stop pairing session")
    end
  end

  def version() do
    output("You're using v#{GitPair.version()}")
  end

  def _modify_commit_msg(path) do
    {:ok, coauthors} = storage().fetch_all()

    case hook().modify_commit_msg(path, coauthors) do
      {:ok} ->
        {:ok, "Success! Co-authors registered."}
      _ ->
        {:nothing}
    end
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

  def storage() do
    Application.get_env(:git_pair, :storage, Storage)
  end

  def hook() do
    Application.get_env(:git_pair, :hook, Hook)
  end
end
