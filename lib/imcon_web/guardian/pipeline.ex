defmodule ImconWeb.Guardian.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :imcon,
    error_handler: ImconWeb.Guardian.ErrorHandler,
    module: ImconWeb.Guardian

  plug(Guardian.Plug.VerifyHeader, realm: "Bearer")
  plug(Guardian.Plug.LoadResource, allow_blank: true)
end
