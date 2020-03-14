defmodule GitPair.CLI do
  @moduledoc """
  GitPair.CLI is the entrypoint for the git-pair utility.
  """

  alias GitPair.Actions

  @switches [
    add: :string,
    help: :boolean,
    h: :boolean
  ]

  @aliases [
    a: :add,
    h: :help
  ]

  def main(argv) do
    argv
    |> parse_args
    |> parse_command
    |> execute_command
  end

  defp parse_args(args), do: OptionParser.parse(args, switches: @switches, aliases: @aliases)

  defp parse_command({_, [action | args], _}), do: {action, args}

  defp execute_command({action, args}) do
    apply(Actions, String.to_atom(action), [args])
  end
end
