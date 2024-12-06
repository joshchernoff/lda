defmodule LDA.Repo do
  use Ecto.Repo,
    otp_app: :lda,
    adapter: Ecto.Adapters.Postgres
end
