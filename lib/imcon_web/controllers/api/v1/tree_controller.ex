defmodule ImconWeb.TreeController do
  use ImconWeb, :controller

  plug :scrub_params, "tree" when action in [:create]

  import Imcon.Thorn
  alias Imcon.Repo
  
  plug(Guardian.Plug.EnsureAuthenticated)
  action_fallback(ImconWeb.FallbackController)

  def index(conn, _params) do

    owned_tree = current_user(conn)
      |> assoc(:owned_tree)
      |> tree_preload_all
      |> Repo.all

    invited_tree = current_user(conn)
      |> assoc(:tree)
      |> not_owned_by(owned_tree.id)
      |> tree_preload_all
      |> Repo.all

    render(conn, "index.json", owned_tree: owned_tree, invited_tree: invited_tree)
  end

  def create(conn, %{"tree" => tree_params}) do

    changeset = current_user(conn)
      |> build_assoc(:owned_tree)
      |> tree_changeset(tree_params)

    if changeset.valid? do
      tree = Repo.insert!(changeset)

      tree
      |> build_assoc(:user_tree)
      |> user_tree_changeset(%{user_id: changeset.id})
      |> Repo.insert!

      conn
      |> put_status(:created)
      |> render("show.json", tree: tree)
    else
      conn
      |> put_status(:unprocessable_entity)
      |> render("error.json", changeset: changeset)
    end
  end
  
  defp current_user(conn)  do
    Guardian.Plug.current_resource(conn)
  end

end
