defmodule C.Repo do
  use Ecto.Repo,
    otp_app: :conway_ex,
    adapter: Ecto.Adapters.SQLite3
end
