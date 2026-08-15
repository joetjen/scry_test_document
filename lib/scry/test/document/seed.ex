defmodule Scry.Test.Document.Seed do
  @moduledoc """
  A small library document tree, deliberately shaped after a worked
  example
  (`library.catalog.shelves.shelf.books.book`) -- a real hierarchy deep
  enough to exercise `DEEP` (matching at any depth) and `PARENT`/
  `SIBLINGS`/`ANCESTORS` (multiple sibling shelves/books at more than
  one level) meaningfully, not just a two-level toy.

  ```
  library
    catalog
      shelves
        fiction (shelf)
          books
            book: Dune, Foundation
        nonfiction (shelf)
          books
            book: Sapiens
  ```
  """

  @doc "The `Scry.Document.Conn.data()` fixture -- a real, multi-segment-keyed tree."
  @spec tree() :: Scry.Document.Conn.data()
  def tree do
    %{
      ["library"] => [%{"name" => "Main Library", "region" => "north"}],
      ["library", "catalog"] => [%{"name" => "Full Catalog"}],
      ["library", "catalog", "shelves"] => [%{"code" => "S1"}],
      ["library", "catalog", "shelves", "fiction"] => [%{"category" => "fiction"}],
      ["library", "catalog", "shelves", "nonfiction"] => [%{"category" => "nonfiction"}],
      ["library", "catalog", "shelves", "fiction", "books"] => [%{"count" => 2}],
      ["library", "catalog", "shelves", "nonfiction", "books"] => [%{"count" => 1}],
      ["library", "catalog", "shelves", "fiction", "books", "book"] => [
        %{"title" => "Dune", "price" => 45, "available" => true},
        %{"title" => "Foundation", "price" => 25, "available" => true}
      ],
      ["library", "catalog", "shelves", "nonfiction", "books", "book"] => [
        %{"title" => "Sapiens", "price" => 35, "available" => true}
      ]
    }
  end
end
