defmodule GitPair.ActionsTest do
  use ExUnit.Case, async: true

  import Mox

  alias GitPair.Actions
  alias GitPair.SystemMock

  setup :verify_on_exit!

  test ".add calls git config add command" do
    expect(SystemMock, :cmd, fn _cmd, _options ->
      {"", 0}
    end)

    {result, message} = Actions.add(["fake-user"])

    assert result == :ok
    assert message == "User fake-user added"
  end
end
