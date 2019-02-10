defmodule ImconWeb.MessageService do
  use ImconWeb, :service

  @default_history_count 100

  def load_messages(channel, max_ts, count \\ @default_history_count) do
    channel
      |> Imcon.Chat.message_before(max_ts, count + 1)
      |> Repo.all
      |> Enum.reverse
  end
end
