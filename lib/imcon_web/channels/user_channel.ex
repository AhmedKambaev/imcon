defmodule ImconWeb.UserChannel do
  use ImconWeb, :channel

  def join("user:" <> user_id, _params, socket) do
    current_user = socket.assigns.current_user

    if String.to_integer(user_id) == current_user.id do
      {:ok, socket}
    else
      {:error, %{reason: "Неправильный пользователь"}}
    end
  end
end
