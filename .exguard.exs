use ExGuard.Config

guard("unit-test", run_on_start: false)
|> command("mix test --color")
|> watch(~r{\.(ex|exs)\z}i)
|> ignore(~r{deps})
|> notification(:auto)
