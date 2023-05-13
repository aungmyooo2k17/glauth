defmodule Glauth.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Glauth.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "some email",
        password_hash: "some password_hash",
        username: "some username"
      })
      |> Glauth.Accounts.create_user()

    user
  end
end
