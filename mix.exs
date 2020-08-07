defmodule GitPair.MixFile do
  use Mix.Project

  def project do
    [
      app: :git_pair,
      version: "0.1.0",
      elixir: "~> 1.10",
      escript: escript(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [extra_applications: [:logger]]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:mox, "~> 0.5.2", only: :test}
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end

  def escript do
    [main_module: GitPair.CLI]
  end
end
