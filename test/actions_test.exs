defmodule GitPair.ActionsTest do
  use ExUnit.Case, async: true

  import Mox

  alias GitPair.Actions
  alias GitPair.StorageMock

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

  test ".status prints a list of collaborators when pairing" do
    expect(StorageMock, :fetch_all, fn ->
      {:ok,
       [
         [
           identifier: "fake_user",
           email: "fake_user@example.com"
         ],
         [
           identifier: "fake_user_2",
           email: "fake_user_2@example.com"
         ]
       ]}
    end)

    {result, message} = Actions.status()

    assert result == :ok

    assert message ==
             "Pairing with:\n\nfake_user <fake_user@example.com>\nfake_user_2 <fake_user_2@example.com>"
  end

  test ".status prints a message when not pairing" do
    expect(StorageMock, :fetch_all, fn ->
      {:ok, []}
    end)

    {result, message} = Actions.status()

    assert result == :ok

    assert message == "You aren't pairing with anyone"
  end

  test ".stop stops pairing session by removing coauthors from storage" do
    expect(StorageMock, :remove_all, fn ->
      {:ok, ["fake_user", "fake_user_2"]}
    end)

    {result, message} = Actions.stop()

    assert result == :ok
    assert message == "Pairing session stopped!\n\nYou were pairing previously with:\nfake_user\nfake_user_2"
  end

  test ".version displays current app version" do
    {result, message} = Actions.version()

    assert result == :ok
    assert message == "You're using v#{GitPair.version()}"
  end
end
