defmodule GitPair.Main do
  use Bakeware.Script

  @impl Bakeware.Script
  def main(args) do
    GitPair.CLI.main(args)

    0
  end
end
