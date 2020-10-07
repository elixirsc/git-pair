defmodule GitPair.Storage do
  @git_config "config"
  @key "pair"
  @github_noreply_email "@users.noreply.github.com"

  def add([identifier, email]) do
    run(["--add", "#{@key}.#{identifier}.identifier", identifier])
    run(["--add", "#{@key}.#{identifier}.email", email])

    {:ok, nil}
  end

  def add(identifier) do
    add([identifier, identifier <> @github_noreply_email])
  end

  def run(command) do
    runner().cmd("git", [@git_config | command])
  end

  def runner() do
    Application.get_env(:git_pair, :command_runner, System)
  end
end
