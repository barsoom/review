defmodule Exremit.AcceptanceCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Hound.Helpers

      alias Exremit.Repo
      import Ecto.Model
      import Ecto.Query, only: [from: 2]

      import Exremit.Router.Helpers
      import AcceptanceTestHelpers

      # The default endpoint for testing
      @endpoint Exremit.Endpoint

      hound_session
    end
  end

  setup tags do
    unless tags[:async] do
      Ecto.Adapters.SQL.restart_test_transaction(Exremit.Repo, [])
    end

    :ok
  end
end
