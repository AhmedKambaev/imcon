defmodule Imcon.Chat.Channel do

  use Ecto.Schema

  schema "channel" do
    field :name, :string
    field :type, :integer
    has_many :message, Imcon.Chat.Message
    many_to_many :user, Imcon.Auth.User, join_through: Imcon.Chat.ChannelUser

    timestamps usec: true
  end

end
