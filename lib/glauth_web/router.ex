defmodule GlauthWeb.Router do
  use GlauthWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :jwt_authenticated do
    plug GlauthWeb.MiddleWare.AuthPipeLine
  end

  scope "/api", GlauthWeb do
    pipe_through :api

    post "/users/register", AuthController, :create
    post "/users/login", AuthController, :login
    post "/users/reset_password", AuthController, :reset_password
  end

  scope "/api", GlauthWeb do
    pipe_through [:api, :jwt_authenticated]

    get "/users/profile", UserController, :profile
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
