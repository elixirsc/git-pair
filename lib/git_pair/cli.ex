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
    |> print_result
  end

  defp parse_args(args), do: OptionParser.parse(args, switches: @switches, aliases: @aliases)

  defp parse_command({_, [action | args], _}), do: {action, args}

  defp execute_command({action, []}) do
    apply(Actions, String.to_atom(action), [])
  end

  defp execute_command({action, args}) do
    apply(Actions, String.to_atom(action), [args])
  end

  defp print_result({:ok, message}) do
    IO.puts(message)
  end

  defp print_result({:error, message}) do
    IO.puts("Fail: #{message}")
  end
end
