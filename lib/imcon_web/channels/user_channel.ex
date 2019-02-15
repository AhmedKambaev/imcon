defmodule ImconWeb.UserChannel do
  use ImconWeb, :channel

  def join("user:" <> user_id, _params, socket) do

    if user_id == Guardian.Phoenix.Socket.current_resource(socket).id do
      {:ok, socket}
    else
      {:error, %{reason: "Invalid user"}}
    end
  end
end
