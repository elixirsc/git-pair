defmodule GitPair.ActionsTest do
  use ExUnit.Case, async: true
  import Mox
  alias GitPair.Actions

  setup :verify_on_exit!

  test ".add calls git config add comma" do
    GitPair.SystemMock.expect(:cmd, fn _cmd, _options ->
      {"", 0}
    end)

    {result, message} = Actions.add(["fake-user"])

    assert result == :ok
    assert message == "User fake-user added"
  end
end
