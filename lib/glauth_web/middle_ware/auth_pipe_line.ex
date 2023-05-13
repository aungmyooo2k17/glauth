defmodule GlauthWeb.MiddleWare.AuthPipeLine do
  use Guardian.Plug.Pipeline, otp_app: :glauth,
  module: Glauth.Guardian,
  error_handler: GlauthWeb.Handler.AuthErrorHandler

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
