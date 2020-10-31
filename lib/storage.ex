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

  def rm(identifier) do
    {_message, result} = run(["--remove-section", "#{@key}.#{identifier}"])

    build_result(result,
      identifier: identifier
    )
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
