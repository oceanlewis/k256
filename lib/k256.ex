defmodule K256 do
  @moduledoc """
  Documentation for `K256`.
  """

  use Rustler, otp_app: :k256, crate: "k256"

  def add(_, _), do: :erlang.nif_error(:nif_not_loaded)
end
