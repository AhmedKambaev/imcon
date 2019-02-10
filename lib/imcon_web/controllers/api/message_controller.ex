defmodule ImconWeb.MessageController do
  use ImconWeb, :controller

  @default_history_count 100

  def index(conn, params = %{"channel_id" => channel_id}) do
    channel = Repo.get_by Imcon.Chat.Channel, id: channel_id
    messages = ImconWeb.MessageService.load_messages(channel, params["ts"] || Imcon.Time.now_ts) |> Repo.preload(:user)

    render(conn, "index.json", messages: messages, count: @default_history_count)
  end
end
