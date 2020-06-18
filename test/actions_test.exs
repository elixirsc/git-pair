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

  test ".rm calls git config unset command" do
    expect(SystemMock, :cmd, fn _cmd, _options ->
      {"", 0}
    end)

    {result, message} = Actions.rm(["fake-user"])

    assert result == :ok
    assert message == "User fake-user removed"
  end

  test ".status calls git config get-all command" do
    expect(SystemMock, :cmd, fn _cmd, _options ->
      {"fake-user", 0}
    end)

    {result, message} = Actions.status()

    assert result == :ok
    assert message == "Pairing with: \n\nfake-user"
  end

  test ".stop calls git config --unset-all command" do
    expect(SystemMock, :cmd, fn _cmd, _options ->
      {"", 0}
    end)

    {result, message} = Actions.stop()

    assert result == :ok
    assert message == "Stopped pairing with everyone"
  end
end
