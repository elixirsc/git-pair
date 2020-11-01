defmodule GitPair.StorageTest do
  use ExUnit.Case, async: true

  import Mox

  alias GitPair.Storage
  alias GitPair.SystemMock

  setup :verify_on_exit!

  describe "add/1" do
    test "store user with identifier with GitHub no-reply email" do
      command_prefix = ["config", "--add"]

      expect(SystemMock, :cmd, fn _cmd, options ->
        assert options == command_prefix ++ ["pair.fake_user.identifier", "fake_user"]
        {"", 0}
      end)

      expect(SystemMock, :cmd, fn _cmd, options ->
        assert options ==
                 command_prefix ++ ["pair.fake_user.email", "fake_user@users.noreply.github.com"]

        {"", 0}
      end)

      {result, user_data} = Storage.add("fake_user")

      assert result == :ok

      assert user_data == [
               identifier: "fake_user",
               email: "fake_user@users.noreply.github.com"
             ]
    end
  end

  describe "add/2" do
    test "stores user with identifier and email" do
      command_prefix = ["config", "--add"]

      expect(SystemMock, :cmd, fn _cmd, options ->
        assert options == command_prefix ++ ["pair.fake_user.identifier", "fake_user"]
        {"", 0}
      end)

      expect(SystemMock, :cmd, fn _cmd, options ->
        assert options == command_prefix ++ ["pair.fake_user.email", "fake@example.com"]
        {"", 0}
      end)

      {result, user_data} = Storage.add(["fake_user", "fake@example.com"])

      assert result == :ok

      assert user_data == [
               identifier: "fake_user",
               email: "fake@example.com"
             ]
    end
  end

  test "remove/1 removes user with identifier" do
    command_prefix = ["config", "--remove-section"]

    expect(SystemMock, :cmd, fn _cmd, options ->
      assert options == command_prefix ++ ["pair.fake_user"]
      {"", 0}
    end)

    {result, user_data} = Storage.remove("fake_user")

    assert result == :ok

    assert user_data == [
             identifier: "fake_user"
           ]
  end

  test "remove/1 fails to remove nonexisting user with identifier" do
    command_prefix = ["config", "--remove-section"]

    expect(SystemMock, :cmd, fn _cmd, options ->
      assert options == command_prefix ++ ["pair.fake_user"]
      {"", 128}
    end)

    {result, user_data} = Storage.remove("fake_user")

    assert result == :error

    assert user_data == [
             identifier: "fake_user"
           ]
  end

  test "remove_all/0 removes all coauthors" do
    fetch_all_command_prefix = ["config", "--get-regexp", "pair.*.identifier"]

    expect(SystemMock, :cmd, fn _cmd, options ->
      assert options == fetch_all_command_prefix

      {"pair.fake_user.identifier fake_user\npair.fake_user_2.identifier fake_user_2\n", 0}
    end)

    fetch_command_prefix = ["config", "--get"]

    expect(SystemMock, :cmd, fn _cmd, options ->
      assert options == fetch_command_prefix ++ ["pair.fake_user.email"]

      {"fake_user@example.com\n", 0}
    end)

    expect(SystemMock, :cmd, fn _cmd, options ->
      assert options == fetch_command_prefix ++ ["pair.fake_user_2.email"]

      {"fake_user_2@example.com\n", 0}
    end)

    command_prefix = ["config", "--remove-section"]

    expect(SystemMock, :cmd, fn _cmd, options ->
      assert options == command_prefix ++ ["pair.fake_user"]
      {"", 0}
    end)

    expect(SystemMock, :cmd, fn _cmd, options ->
      assert options == command_prefix ++ ["pair.fake_user_2"]
      {"", 0}
    end)

    {result, coauthor_identifiers} = Storage.remove_all()

    assert result == :ok

    assert coauthor_identifiers == ["fake_user", "fake_user_2"]
  end

  test "fetch/1 returns pair information with identifier and email" do
    command_prefix = ["config", "--get"]

    expect(SystemMock, :cmd, fn _cmd, options ->
      assert options == command_prefix ++ ["pair.fake_user.email"]
      {"fake_user@example.com\n", 0}
    end)

    {result, user_data} = Storage.fetch("fake_user")

    assert result == :ok

    assert user_data == [
             identifier: "fake_user",
             email: "fake_user@example.com"
           ]
  end

  test "fetch_all/0 returns a list of collaborators" do
    fetch_all_command_prefix = ["config", "--get-regexp", "pair.*.identifier"]

    expect(SystemMock, :cmd, fn _cmd, options ->
      assert options == fetch_all_command_prefix

      {"pair.fake_user.identifier fake_user\npair.fake_user_2.identifier fake_user_2\n", 0}
    end)

    fetch_command_prefix = ["config", "--get"]

    expect(SystemMock, :cmd, fn _cmd, options ->
      assert options == fetch_command_prefix ++ ["pair.fake_user.email"]

      {"fake_user@example.com\n", 0}
    end)

    expect(SystemMock, :cmd, fn _cmd, options ->
      assert options == fetch_command_prefix ++ ["pair.fake_user_2.email"]

      {"fake_user_2@example.com\n", 0}
    end)

    {result, collaborators} = Storage.fetch_all()

    assert result == :ok

    assert collaborators == [
             [
               identifier: "fake_user",
               email: "fake_user@example.com"
             ],
             [
               identifier: "fake_user_2",
               email: "fake_user_2@example.com"
             ]
           ]
  end
end
