ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Trihard.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Trihard.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Trihard.Repo)

