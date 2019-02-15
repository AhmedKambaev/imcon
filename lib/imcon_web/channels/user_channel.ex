defmodule ImconWeb.UserChannel do
  use ImconWeb, :channel

  def join("user:" <> user_id, _params, socket) do
    current_user = socket.assigns.current_user
IO.inspect(current_user["sub"])
    if String.to_integer(user_id) == current_user.id do
      {:ok, socket}
    else
      {:error, %{reason: "Invalid user"}}
    end
  end
end
