defmodule GlauthWeb.UserController do
  use GlauthWeb, :controller

  alias GlauthWeb.Utils.ResponseUtil
  alias Glauth.Accounts

  def profile(conn, _params) do
    case Guardian.Plug.current_resource(conn) do
      nil ->
        conn
        |> put_status(:unauthorized)
        |> json(ResponseUtil.error_message_response("Please try again later."))

      user ->
        conn
        |> put_status(:ok)
        |> json(ResponseUtil.success_data_response(Accounts.transform_user(user)))
    end
  end
end
