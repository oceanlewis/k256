defmodule K256.Native do
  @moduledoc """
  Houses the configuration and initialization of `Rustler`'s required
  OTP Application.

  All implemented NIFs can be found here and are delegated to by their logical
  modules. `Rustler` expects its NIFs to be instantiated in a single place.
  """

  use Rustler,
    otp_app: :k256,
    crate: "k256_rs"

  def schnorr_generate_random_signing_key(), do: error()
  def schnorr_create_signature(_, _), do: error()
  def schnorr_verifying_key_from_signing_key(_), do: error()
  def schnorr_validate_signature(_, _, _), do: error()

  defp error(), do: :erlang.nif_error(:nif_not_loaded)
end
