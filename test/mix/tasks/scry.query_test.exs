defmodule Mix.Tasks.Scry.QueryConfigTest do
  @moduledoc """
  `mix scry.query`/`mix scry.iex` themselves live in `scry_core` (a
  generic, config-driven pair -- see that package's own `Scry.Core.
  QueryTool` moduledoc) and are already fully tested there. This is
  just a smoke test that THIS package's own `config/config.exs` wires
  them correctly end to end -- `Scry.Document.parse/1` as the parser,
  `Scry.Test.Document.Adapter` bridging `Scry.Document.Executor`'s own
  `(query, conn, params)` shape to the `(query, engine, conn)` one
  `Scry.Core.QueryTool` expects, and `Scry.Test.Document.Conn.tree/0`
  as the sole named backend.
  """

  use ExUnit.Case, async: false

  import ExUnit.CaptureIO

  test "a DEEP query runs correctly through the configured backend" do
    output =
      capture_io(fn -> Mix.Tasks.Scry.Query.run(["SELECT library.book DEEP { title }"]) end)

    assert output =~ ~s("title" => "Dune")
  end

  test "the sole configured backend is used implicitly, with no --backend flag needed" do
    output = capture_io(fn -> Mix.Tasks.Scry.Query.run(["SELECT library { name }"]) end)
    assert output =~ ~s("name" => "Main Library")
  end
end
