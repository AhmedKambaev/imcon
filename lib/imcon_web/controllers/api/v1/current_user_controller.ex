defmodule ImconWeb.CurrentUserController do
  use ImconWeb, :controller

  alias ImconWeb.Guardian

  action_fallback(ImconWeb.FallbackController)

  def show(conn, _) do
    user = Guardian.Plug.current_resource(conn)

    conn
    |> put_view(ImconWeb.UserView)
    |> render("show.json", user: user)
  end

end
