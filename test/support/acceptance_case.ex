defmodule Review.AcceptanceCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Hound.Helpers

      alias Review.Repo
      import Ecto.Schema
      import Ecto.Query, only: [from: 2]

      import Review.Router.Helpers
      import AcceptanceTestHelpers

      # The default endpoint for testing
      @endpoint Review.Endpoint

      hound_session
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Review.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Review.Repo, {:shared, self})
    end

    :ok
  end
end
