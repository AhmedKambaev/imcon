defmodule ImconWeb.ChannelController do
  use ImconWeb, :controller

  alias ImconWeb.{ChannelView, ChannelUserService, UnreadService, EventChannel, ChangesetView}
  alias Imcon.Chat
  alias Imcon.Chat.Channel

  plug(Guardian.Plug.EnsureAuthenticated)
  plug :scrub_params, "channel" when action in [:create, :update]

  def index(conn, _params) do

    channels = Repo.all(Chat.public)

    joined_status = ChannelUserService.joined_channels_status(Guardian.Plug.current_resource(conn))
    render(conn, "index.json", channels: channels, joined_status: joined_status)
  end

  def create(conn, %{"channel" => channel_params}) do

    case ChannelUserService.insert_channel(channel_params, Guardian.Plug.current_resource(conn)) do
      {:ok, channel} ->
        payload = ChannelView.render("show.json", channel: channel, joined: false)
        notify_channel_created(payload)
        conn
        |> put_status(:created)
        |> json(Map.put(payload, :joined, true))
      {:error, changeset} ->
        conn
        |> put_status(:bad_request)
        |> render(ChangesetView, :message, changeset: changeset)
    end
  end

  def read(conn, %{"channel_id" => channel_id, "ts" => ts}) do
    channel = Repo.get(Channel, channel_id)

    case UnreadService.mark_read(Guardian.Plug.current_resource(conn), channel, ts) do
      {:ok, _struct} ->
        conn
        |> put_status(:ok)
        |> json(%{})
      {:error, message} ->
        conn
        |> put_status(:bad_request)
        |> json(%{message: message})
    end
  end

  defp notify_channel_created(payload) do
    EventChannel.push_out("channel_created", payload)
  end
end
