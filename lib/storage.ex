defmodule GitPair.Storage do
  @git_config "config"
  @key "pair"
  @github_noreply_email "@users.noreply.github.com"
  @success_exit_status 0

  def add([identifier, email]) do
    run(["--add", "#{@key}.#{identifier}.identifier", identifier])
    run(["--add", "#{@key}.#{identifier}.email", email])

    {:ok,
     [
       identifier: identifier,
       email: email
     ]}
  end

  def add(identifier) do
    add([identifier, identifier <> @github_noreply_email])
  end

  def remove(identifier) do
    {_message, result} = run(["--remove-section", "#{@key}.#{identifier}"])

    build_result(result,
      identifier: identifier
    )
  end

  def remove_all() do
    case fetch_all() do
      {:ok, coauthors} when coauthors != [] ->
        coauthor_identifiers = Enum.map(coauthors, fn coauthor ->
          {:ok, coauthor} = remove(coauthor[:identifier])

          coauthor[:identifier]
        end)

        {:ok, coauthor_identifiers}
      _ ->
        {:ok, []}
    end
  end

  def fetch(identifier) do
    {result, @success_exit_status} = run(["--get", "#{@key}.#{identifier}.email"])

    [email, _tail] = String.split(result, "\n")

    {:ok,
     [
       identifier: identifier,
       email: email
     ]}
  end

  def fetch_all do
    case run(["--get-regexp", "#{@key}.*.identifier"]) do
      {collaborators, @success_exit_status} ->
        collaborators =
          String.split(collaborators, "\n")
          |> (fn collaborators ->
                List.delete_at(collaborators, length(collaborators) - 1)
              end).()
          |> Enum.map(fn collaborator ->
            [_key, collaborator] = String.split(collaborator, " ")

            {:ok, collaborator_data} = fetch(collaborator)

            collaborator_data
          end)

        {:ok, collaborators}

      _ ->
        {:ok, []}
    end
  end

  defp build_result(@success_exit_status, data) do
    {:ok, data}
  end

  defp build_result(_exit_status, data) do
    {:error, data}
  end

  defp run(command) do
    runner().cmd("git", [@git_config | command])
  end

  defp runner() do
    Application.get_env(:git_pair, :command_runner, System)
  end
end
