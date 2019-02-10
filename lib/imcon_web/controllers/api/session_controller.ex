defmodule ImconWeb.SessionController do
  use ImconWeb, :controller

  alias ImconWeb.Guardian

  plug :scrub_params, "session" when action in [:create]

  def create(conn, %{"session" => session_params}) do
    case Imcon.Auth.authenticate(session_params) do
      {:ok, user} ->
        {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user)

        conn
        |> put_status(:created)
        |> render("show.json", jwt: jwt, user: user)

      :error ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json")
    end
  end

  def delete(conn, _) do
    {:ok, claims} = Guardian.Plug.current_claims(conn)

    conn
    |> Guardian.Plug.current_token
    |> Guardian.revoke(claims)

    conn
    |> render("delete.json")
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_status(:forbidden)
    |> render(ImconWeb.SessionView, "forbidden.json", error: "Not Authenticated")
  end
end
