defmodule Exremit.Repo do
  use Ecto.Repo, otp_app: :exremit
  import Ecto.Query

  def commits do
    from _ in Exremit.Commit,
      order_by: [ desc: :id ],
      preload:  [ :author, :reviewed_by_author ]
  end
end
