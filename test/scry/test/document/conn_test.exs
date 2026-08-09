defmodule Scry.Test.Document.ConnTest do
  @moduledoc """
  `Scry.Test.Document.Conn.tree/0` -- confirms it returns a real,
  working `Scry.Document.Conn.t()` (prefilled with `Scry.Test.
  Document.Seed`'s own tree), actually executing `DEEP`/`PARENT`/
  `ANCESTORS` correctly through `Scry.Document.Executor.run/3`.
  """

  use ExUnit.Case, async: true

  alias Scry.Core.Cursor
  alias Scry.Document.Executor
  alias Scry.Test.Document.Conn

  defp run!(source) do
    {:ok, query} = Scry.Document.parse(source)
    {:ok, cursor} = Executor.run(query, Conn.tree())
    Cursor.to_list(cursor)
  end

  test "an ordinary top-level query works with no DEEP/PARENT/etc. at all" do
    assert run!("SELECT library { name }") == [%{"name" => "Main Library"}]
  end

  test "DEEP matches a book at any depth beneath library" do
    titles =
      "SELECT library.book DEEP { title }" |> run!() |> Enum.map(& &1["title"]) |> Enum.sort()

    assert titles == ["Dune", "Foundation", "Sapiens"]
  end

  test "the lang_spec.md §8.3 worked example runs correctly against this fixture" do
    assert [row] =
             run!(
               "SELECT library.catalog.shelves.fiction.books.book WHERE price > 30 AND available = true { title, PARENT { PARENT { category } }, ANCESTORS { region } }"
             )

    assert row["title"] == "Dune"
    assert row["parent"] == %{"parent" => %{"category" => "fiction"}}
    assert List.last(row["ancestors"]) == %{"region" => "north"}
  end

  test "calling tree/0 twice returns independent, identically-seeded connections" do
    assert Conn.tree() == Conn.tree()
  end
end
