defmodule ImconWeb.UserSocket do
  use Phoenix.Socket

  alias ImconWeb.{BranchChannel, TreeChannel, UserChannel, MessageChannel, EventChannel}
  
  # Channels
  channel "tree:*", TreeChannel
  channel "user:*", UserChannel
  channel "channel:*", MessageChannel
  channel "event:*", EventChannel

  def connect(%{"token" => token}, socket) do
    case Guardian.Phoenix.Socket.authenticate(socket, ImconWeb.Guardian, token) do
      {:ok, user} ->
        {:ok, assign(socket, :current_user, user)}

      {:error, _reason} ->
        :error
    end
  end

  def connect(_params, _socket), do: :error

  def id(socket), do: "user_socket:#{socket.assigns.current_user.id}"
end
