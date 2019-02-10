defmodule ImconWeb.ChannelUserController do

  use ImconWeb, :controller

  def create(conn, %{"channel_id" => channel_id}) do
    channel = Repo.get_by!(Imcon.Chat.Channel, id: channel_id)
    case ImconWeb.ChannelUserService.create_channel_user(channel, conn.assigns.current_user) do
      {:ok, _} ->
        conn
        |> put_status(:ok)
        |> json(%{message: "You've joined the channel!"})
      {:error, _} ->
        conn
        |> put_status(:bad_request)
        |> json(%{message: "You can't join the channel!"})
    end
  end
end
