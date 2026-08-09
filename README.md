# scry_test_document

Shared test fixtures for
[`scry_document`](https://github.com/joetjen/scry_document): one seed
dataset (`Scry.Test.Document.Seed`) — a small library document tree,
shaped after `lang_spec.md` §8.3's own worked example
(`library.catalog.shelves.shelf.books.book`) — servable through
`Scry.Test.Document.Conn.tree/0`.

**Only one constructor, not a family of interchangeable backends.**
Unlike [`scry_test_core`](https://github.com/joetjen/scry_test_core)/
[`scry_test_time_series`](https://github.com/joetjen/scry_test_time_series)
(one constructor *per* interchangeable `Scry.Core.EngineBehaviour`
backend, for genuine cross-backend parity testing), `scry_document`
has exactly one executor (`Scry.Document.Executor`, operating on
`Scry.Document.Conn.t()` directly — that package's own `CHANGELOG.md`
has the full "no existing `EngineBehaviour` callback receives the
whole document space `DEEP`/`PARENT`/`SIBLINGS`/`ANCESTORS` need"
reasoning). There's nothing to parity-test *against* yet. This
package's own value is narrower and still real: a shared, realistic
fixture (reusable by an application's own integration tests, or this
kind's own future real adapter's test suite, once one exists) plus
`scry_core`'s own `mix scry.query`/`mix scry.iex`, configured here, for
ad-hoc exploration.

Source: <https://github.com/joetjen/scry_test_document>. Specs live in
the separate [`scry`](https://github.com/joetjen/scry) repository; the
kind this exercises lives in
[`scry_document`](https://github.com/joetjen/scry_document).

## Usage

```elixir
{:ok, query} =
  Scry.Document.parse(~s"""
  SELECT library.catalog.shelves.fiction.books.book
      WHERE price > 30 AND available = true
  {
      title,
      PARENT { PARENT { category } },
      ANCESTORS { region }
  }
  """)

{:ok, cursor} = Scry.Document.Executor.run(query, Scry.Test.Document.Conn.tree())
Scry.Core.Cursor.to_list(cursor)
# [%{"title" => "Dune", "parent" => %{"parent" => %{"category" => "fiction"}}, "ancestors" => [...]}]
```

## `mix scry.query`/`mix scry.iex`

Both tasks live in `scry_core` itself (a generic, config-driven pair —
see that package's own README/`Scry.Core.QueryTool` moduledoc). This
package's own `config/config.exs` wires them to `Scry.Document.parse/1`
and `Scry.Test.Document.Conn.tree/0` via a small `Scry.Test.Document.
Adapter` (bridging `Scry.Document.Executor`'s own `(query, conn,
params)` shape to the `(query, engine, conn)` one `Scry.Core.QueryTool`
expects — `scry_document` has no separate "engine" concept at all, so
there's nothing real for that middle argument to be):

```console
$ mix scry.query 'SELECT library.book DEEP { title }'
$ mix scry.iex
```

No `--backend` flag needed — this package registers exactly one named
backend, used implicitly.

## Installation

```elixir
def deps do
  [
    {:scry_test_document, "~> 0.1.0", only: :test}
  ]
end
```

## Documentation

Documentation is generated with [ExDoc](https://github.com/elixir-lang/ex_doc):

- Released versions are published to [HexDocs](https://hexdocs.pm) once the
  package ships, at <https://hexdocs.pm/scry_test_document>.
- Latest `main` is built and deployed automatically by
  [`.github/workflows/docs.yml`](.github/workflows/docs.yml) to
  [GitHub Pages](https://joetjen.github.io/scry_test_document/) on every push to `main`.
