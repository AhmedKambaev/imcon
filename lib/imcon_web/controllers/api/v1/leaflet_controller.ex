defmodule Imcon.LeafletController do
  use ImconWeb, :controller

  plug(Guardian.Plug.EnsureAuthenticated)
  action_fallback(ImconWeb.FallbackController)

  def show(conn, %{"tree_id" => tree_id, "id" => leaflet_id}) do
    leaflet = Imcon.Thorn.Leaflet
        
     |> Imcon.Thorn.get_by_user_and_tree(leaflet_id, current_user(conn).id, tree_id)
     |> Imcon.Repo.one!

    render(conn, "show.json", leaflet: leaflet)
  end

  defp current_user(conn)  do
    Guardian.Plug.current_resource(conn)
  end

end
