defmodule Scry.Test.Document.Conn do
  @moduledoc """
  One constructor, `tree/0`, returning a ready `Scry.Document.Conn.t()`
  prefilled with `Scry.Test.Document.Seed`'s own data -- straight into
  `Scry.Document.Executor.run/3`'s own second argument.

  Unlike `Scry.Test.Core.Conn`/`Scry.Test.TimeSeries.Conn` (one
  constructor *per* interchangeable `Scry.Core.EngineBehaviour`
  backend), there's only ever one constructor here: `scry_document` has
  exactly one executor (`Scry.Document.Executor`, operating on `Scry.
  Document.Conn.t()` directly -- confirmed in that package's own
  `CHANGELOG.md`: no existing `EngineBehaviour` callback receives the
  whole document space `DEEP`/`PARENT`/`SIBLINGS`/`ANCESTORS` need),
  not a family of interchangeable pushdown engines to parity-test
  against. This package's own value is a shared, realistic fixture --
  reusable by anything depending on `scry_document` (an application's
  own integration tests, this kind's own future real adapter's own
  test suite, once one exists) -- and `config/config.exs`, wiring
  `scry_core`'s own generic `mix scry.query`/`mix scry.iex` to use it
  for ad-hoc exploration.
  """

  alias Scry.Document.Conn

  @doc "`Scry.Document.Conn.new/1`, prefilled with `Scry.Test.Document.Seed`'s own tree."
  @spec tree() :: Conn.t()
  def tree do
    Conn.new(Scry.Test.Document.Seed.tree())
  end
end
