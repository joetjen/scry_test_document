# Changelog

## [Unreleased]

### Added

- Initial project scaffold: `mix.exs` (app `:scry_test_document`, `{:scry_core, path: "../scry_core"}`/`{:scry_document, path: "../scry_document"}` real, unscoped dependencies until both are published to Hex), `.credo.exs`/`.formatter.exs`/`.tool-versions`, `AGENTS.md`/`CLAUDE.md`.
- `Scry.Test.Document.Seed`: a small library document tree, deliberately shaped after `lang_spec.md` §8.3's own worked example (`library.catalog.shelves.shelf.books.book`) -- real enough hierarchy (two shelves, each with their own books) to exercise `DEEP` (matching at any depth) and `PARENT`/`SIBLINGS`/`ANCESTORS` (multiple sibling levels) meaningfully, not just a two-level toy.
- `Scry.Test.Document.Conn.tree/0` -- the sole constructor, prefilled with the seed above. Deliberately just one, not one per interchangeable backend the way `Scry.Test.Core.Conn`/`Scry.Test.TimeSeries.Conn` have: `scry_document` has exactly one executor (`Scry.Document.Executor`, operating on `Scry.Document.Conn.t()` directly, not dispatching through `Scry.Core.EngineBehaviour`), so there's no cross-backend parity to prove -- this package's own value is a shared, realistic fixture plus CLI wiring, not a parity suite.
- `Scry.Test.Document.Adapter`: bridges `scry_core`'s own `Scry.Core.QueryTool` config contract (`backends:` returning `{engine_module, conn}`; `executor:` called as `(query, engine, conn)`) to `Scry.Document.Executor`'s own `(query, conn, params)` shape, since `scry_document` has no separate "engine module" concept at all. `config/config.exs` registers `Scry.Document` as the parser and this adapter as both the sole backend and the executor, so `scry_core`'s own `mix scry.query`/`mix scry.iex` work against this fixture with no `--backend` flag needed.
- `test/scry/test/document/conn_test.exs`: confirms `tree/0` returns a real, working connection, `DEEP` and the full `lang_spec.md` §8.3 worked example both run correctly through it. `test/mix/tasks/scry.query_test.exs`: a light smoke test confirming this package's own `config/config.exs` wires `scry_core`'s already-tested generic tasks correctly end to end (not a re-test of the tasks themselves).
