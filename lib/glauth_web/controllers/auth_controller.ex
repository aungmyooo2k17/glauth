defmodule GlauthWeb.AuthController do
  use GlauthWeb, :controller

  alias Glauth.Accounts
  alias GlauthWeb.Utils.ResponseUtil

  @spec create(
          Plug.Conn.t(),
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: Plug.Conn.t()
  def create(conn, params) do
    changeset = Accounts.create_user(params)

    case changeset do
      {:ok, _user} ->
        conn
        |> put_status(:created)
        |> json(ResponseUtil.success_message_response("Successfully created."))

      {:error, changeset} ->
        {_, {message, _}} = List.first(changeset.errors)

        conn
        |> put_status(:unprocessable_entity)
        |> json(ResponseUtil.error_message_response(message))
    end
  end

  def login(conn, %{"email" => email, "password" => password} = _params) do
    if user = Accounts.get_user_by_email_and_password(email, password) do
      token = Accounts.generate_user_session_token(user)
      user = Accounts.transform_user(user, token)

      conn
      |> put_status(:ok)
      |> json(ResponseUtil.success_data_response(user))
    else
      # In order to prevent user enumeration attacks, don't disclose whether the email is registered.
      conn
      |> put_status(:unauthorized)
      |> json(ResponseUtil.error_message_response("Invalid email or password"))
    end
  end

  def reset_password(
        conn,
        %{
          "email" => email,
          "password" => _,
          "password_confirmation" => _
        } = params
      ) do
    with {:ok, user} <- Accounts.get_user_by_email(email),
         {:ok, _} <- Accounts.reset_user_password(user, params) do
      conn
      |> put_status(:ok)
      |> json(ResponseUtil.success_message_response("Password reset successfully."))
    else
      {:error, message} ->
        conn
        |> put_status(:not_found)
        |> json(ResponseUtil.error_message_response(message))
    end
  end
end
