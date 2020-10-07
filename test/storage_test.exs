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
end
