# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Imcon.Repo.insert!(%Imcon.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Imcon.Auth.User
alias Imcon.Auth

alias Imcon.Repo

[
  %{
    first_name: "John",
    last_name: "Doe",
    email: "john@caix.ru",
    role: "admin",
    password: "12345678"
  },
]
|> Enum.map(&Auth.create_user(%User{}, &1))
|> Enum.each(&Repo.insert!(&1))
