defmodule GitPair.ActionsTest do
  use ExUnit.Case, async: true

  import Mox

  alias GitPair.Actions
  alias GitPair.StorageMock
  alias GitPair.SystemMock

  setup :verify_on_exit!

  test ".add calls git config add command passing username" do
    expect(StorageMock, :add, fn identifier ->
      {:ok,
       [
         identifier: identifier,
         email: "fake_user@users.noreply.github.com"
       ]}
    end)

    {result, message} = Actions.add(["fake_user"])

    assert result == :ok
    assert message == "User fake_user (fake_user@users.noreply.github.com) added"
  end

  test ".add calls git config add command passing identifier and email" do
    expect(StorageMock, :add, fn [identifier, email] ->
      {:ok,
       [
         identifier: identifier,
         email: email
       ]}
    end)

    {result, message} = Actions.add(["fake_user", "fake_user@example.com"])

    assert result == :ok
    assert message == "User fake_user (fake_user@example.com) added"
  end

  test ".rm removes identity from storage" do
    expect(StorageMock, :remove, fn identifier ->
      {:ok,
       [
         identifier: identifier
       ]}
    end)

    {result, message} = Actions.rm(["fake-user"])

    assert result == :ok
    assert message == "User fake-user removed"
  end

  test ".status calls git config get-all command" do
    expect(SystemMock, :cmd, fn _cmd, _options ->
      {"fake-user\n", 0}
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

  test ".version displays current app version" do
    {result, message} = Actions.version()

    assert result == :ok
    assert message == "You're using v#{GitPair.version()}"
  end
end
