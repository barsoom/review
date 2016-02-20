{:ok, _} = Application.ensure_all_started(:hound)
{:ok, _} = Application.ensure_all_started(:ex_machina)
ExUnit.start

Code.require_file "test/support/factory.exs"
Code.require_file "test/support/acceptance_test_helpers.exs"

Mix.Task.run "ecto.create", ["--quiet"]
Mix.Task.run "ecto.migrate", ["--quiet"]
Ecto.Adapters.SQL.begin_test_transaction(Exremit.Repo)
