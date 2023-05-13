defmodule GlauthWeb.AuthController do
  use GlauthWeb, :controller

  alias Glauth.Accounts
  alias GlauthWeb.Utils.ResponseUtil

  def create(conn, params) do
    changeset = Accounts.create_user(params)

    case changeset do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> json(ResponseUtil.data_message_response("Successfully created."))

      {:error, changeset} ->
        {_, {message, _}} = List.first(changeset.errors)

        conn
        |> put_status(:unprocessable_entity)
        |> json(ResponseUtil.error_message_response(message))
    end
  end

  def login(conn, params) do
    %{"email" => email, "password" => password} = params

    if user = Accounts.get_user_by_email_and_password(email, password) do
      token = Accounts.generate_user_session_token(user)
      user = Accounts.transform_user(user, token)

      conn
      |> put_status(:ok)
      |> json(ResponseUtil.data_message_response(user))
    else
      # In order to prevent user enumeration attacks, don't disclose whether the email is registered.
      conn
      |> put_status(:unauthorized)
      |> json(ResponseUtil.error_message_response("Invalid email or password"))
    end
  end
end
