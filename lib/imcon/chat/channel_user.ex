defmodule Imcon.Chat.ChannelUser do
  
  use Ecto.Schema

  schema "channel_user" do
    field :joined_at, :naive_datetime
    belongs_to :channel, Imcon.Chat.Channel
    belongs_to :user, Imcon.Auth.User

    timestamps()
  end

end
