defmodule GitPair.Hook do
  def modify_commit_msg(_path, []), do: {:nothing}

  def modify_commit_msg(path, coauthors) do
    co_authors_message = make_co_authored_by(coauthors)

    File.open(path, [:append])
    |> elem(1)
    |> IO.binwrite(co_authors_message)

    {:ok}
  end

  defp make_co_authored_by(coauthors) do
    "\n" <>
      (Enum.map(coauthors, fn coauthor ->
         "Co-authored-by: #{coauthor[:identifier]} <#{coauthor[:email]}>"
       end)
       |> Enum.join("\n"))
       |> IO.iodata_to_binary
  end
end
