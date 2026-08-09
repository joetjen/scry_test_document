import Config

# Wires this package's own single Scry.Test.Document.Conn.tree/0
# fixture into scry_core's generic mix scry.query/mix scry.iex -- see
# Scry.Core.QueryTool's own moduledoc for the full config shape.
# parser: points at Scry.Document.parse/1, since this package
# exercises the document kind, not core's own degenerate one.
# executor: is Scry.Test.Document.Adapter, not Scry.Document.Executor
# directly -- the adapter bridges QueryTool's own (query, engine, conn)
# calling convention to Scry.Document.Executor's (query, conn, params)
# shape (that module's own moduledoc has the full "why" -- scry_document
# has no separate "engine" concept at all).
config :scry_core, :query_tool,
  parser: Scry.Document,
  executor: {Scry.Test.Document.Adapter, :run},
  backends: %{
    "document" => {Scry.Test.Document.Adapter, :conn}
  }
