defmodule Imcon.Chat do
  @moduledoc """
  The boundary for the Chat system.
  """
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]

  alias Imcon.Chat.{Message, Channel}
  alias Imcon.Auth.User
  alias Imcon.Time, as: Extime

  # UserReadMessage
  
  @required_fields ~w(latest_ts channel_id user_id)a
  @optional_fields ~w(message_id)a
  @allowed_fields Enum.concat([@required_fields, @optional_fields])

  def user_read_changeset(user_read, params \\ %{}) do
    user_read
    |> cast(params, @allowed_fields)
    |> validate_required(@required_fields)
  end

  def latest_ts_of(user, channel) do
    from Channel, where: [user_id: ^user.id, channel_id: ^channel.id], select: [:latest_ts]
  end

  # ChannelUser
  
  @allowed_fields ~w(joined_at channel_id user_id)a
  @required_fields ~w(channel_id user_id)a

  def channel_user_changeset(channel_user, params \\ %{}) do
    channel_user
    |> cast(params, @allowed_fields)
    |> validate_required(@required_fields)
  end

  # Channel
  
  @type_public 1
  @type_direct 2

  @allowed_fields ~w(name type)a

  def public_changeset(channel, params \\ %{}) do
    changeset(channel, params)
    |> put_change(:type, @type_public)
    |> validate_required([:type])
    |> validate_format(:name, ~r/\A[\w\-]+\z/)
  end

  def direct_changeset(channel, params \\ %{}) do
    changeset(channel, params)
    |> put_change(:type, @type_direct)
    |> validate_required([:type])
  end

  defp changeset(channel, params) do
    channel
    |> cast(params, @allowed_fields)
    |> validate_required([:name])
    |> unique_constraint(:name)
  end

  def public(query \\ __MODULE__) do
    from query, where: [type: @type_public]
  end

  def direct(query \\ __MODULE__) do
    from query, where: [type: @type_direct]
  end

  # Message
  
  @required_fields ~w(text channel_id user_id)a
  @allowed_fields @required_fields

  def message_changeset(message, params \\ %{}) do
    message
    |> cast(params, @allowed_fields)
    |> validate_required(@required_fields)
  end

  def ts(message) do
    message.inserted_at |> Extime.to_timestamp
  end

  def message_before(channel, ts, limit \\ 100)
  def message_before(channel, ts, limit) when is_number(ts) do
    time = Extime.to_datetime(ts)
    message_before(channel, time, limit)
  end
  def message_before(channel, time, limit) do
    from m in Message,
      where: m.channel_id == ^channel.id and m.inserted_at < ^time,
      limit: ^limit,
      order_by: [desc: m.inserted_at]
  end

  def message_count_after(channel, ts) when is_number(ts) do
    time = Extime.to_datetime(ts)
    message_count_after(channel, time)
  end
  def message_count_after(channel, time) do
    from m in Message,
      where: m.channel_id == ^channel.id and m.inserted_at > ^time,
      select: count(m.id)
  end

  # User
  def direct_name(user_id1, user_id2) do
    [user_id1, user_id2] |> Enum.sort |> Enum.join(",")
  end

  def direct_user_ids(channel) do
    case channel.type do
      @type_direct -> channel.name |> String.split(",") |> Enum.map(&String.to_integer/1)
      _            -> raise ArgumentError, message: "#{inspect channel} is not a direct channel!"
    end
  end

  def opposite_direct_user_id(channel, user_id) when is_integer(user_id) do
    channel
      |> direct_user_ids
      |> List.delete(user_id)
      |> List.first
  end

  def is_direct?(channel) do
    channel.type == @type_direct
  end

end