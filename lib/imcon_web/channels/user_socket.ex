defmodule ImconWeb.UserSocket do
  use Phoenix.Socket

  alias ImconWeb.{Guardian, TreeChannel, UserChannel, MessageChannel, EventChannel}
  
  # Channels
  channel "tree:*", TreeChannel
  channel "user:*", UserChannel
  channel "channel:*", MessageChannel
  channel "event:*", EventChannel

  def connect(%{"token" => token}, socket) do
    case Guardian.decode_and_verify(token) do
      {:ok, claims} ->
    case Guardian.resource_from_token(claims["sub"]) do
      {:ok, user} ->
        {:ok, assign(socket, :current_user, user)}
      end
      {:error, _reason} ->
        :error
    end
  end

  def connect(_params, _socket), do: :error

  def id(socket), do: "user_socket:#{socket.assigns.current_user.id}"
end
