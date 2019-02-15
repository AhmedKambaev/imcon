defmodule ImconWeb.UserSocket do
  use Phoenix.Socket

  alias ImconWeb.{BranchChannel, TreeChannel, UserChannel, MessageChannel, EventChannel}
  
  # Channels
  channel "tree:*", TreeChannel
  channel "user:*", UserChannel
  channel "dialog:*", MessageChannel
  channel "event:*", EventChannel
  channel "branch:*", BranchChannel

  def connect(%{"token" => token}, socket) do
    case Guardian.Phoenix.Socket.authenticate(socket, ImconWeb.Guardian, token) do
<<<<<<< HEAD
      {:ok, auth} ->
      {:ok, assign(socket, :current_user, auth)}
=======
      {:ok, user} ->
        {:ok, assign(socket, :current_user, user)}
>>>>>>> 0658036be937888cb658d908fe77b67735cb73b3

      {:error, _reason} ->
        :error
    end
  end

  def connect(_params, _socket), do: :error

  def id(socket), do: "user_socket:#{socket.assigns.current_user.id}"
end
