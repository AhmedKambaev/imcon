use Mix.Config

# In this file, we keep production configuration that
# you'll likely want to automate and keep away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or yourself later on).
config :imcon, ImconWeb.Endpoint,
  secret_key_base: "CqjiWk0xQ3oWd81bN9efRpG1ZqCOax/TXg99rIJbgkcLewhF/eEPfou0w0e1F7zX"

# Configure your database
config :imcon, Imcon.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "pavelz",
  password: "bOOm757s#",
  database: "im_con",
  hostname: "82.146.44.66",
  pool_size: 15
