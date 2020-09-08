defmodule GitPair.MixFile do
  use Mix.Project

  def project do
    [
      app: :"git-pair",
      description: "Automatically adds Co-authored-by mark to commits when you're pairing",
      version: "0.2.0",
      elixir: "~> 1.10",
      escript: escript(),
      deps: deps(),
      package: package(),

      # Docs
      name: "GitPair",
      source_url: "https://github.com/elixirsc/git-pair",
      homepage_url: "https://hex.pm/packages/git-pair/",
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [extra_applications: [:logger]]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:mox, "~> 0.5.2", only: :test},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  def escript do
    [main_module: GitPair.CLI]
  end

  defp package do
    [
      name: "git_pair",
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/elixirsc/git-pair"}
    ]
  end

  defp docs do
    [
      main: "GitPair",
      extras: ~w(README.md)
    ]
  end
end
