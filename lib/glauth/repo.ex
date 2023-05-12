defmodule Glauth.Repo do
  use Ecto.Repo,
    otp_app: :glauth,
    adapter: Ecto.Adapters.Postgres
end
