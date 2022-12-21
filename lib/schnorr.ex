defmodule K256.Schnorr do
  @doc "Generates a random Signing Key"
  defdelegate generate_random_signing_key(),
    to: K256,
    as: :schnorr_generate_random_signing_key

  @doc "Creates an returns a signature of the given `contents` given a signing key"
  defdelegate create_signature(signing_key, contents),
    to: K256,
    as: :schnorr_create_signature

  defdelegate create_verifying_key(signing_key),
    to: K256,
    as: :schnorr_verifying_key_from_signing_key

  defdelegate validate_signature(contents, signature, verifying_key),
    to: K256,
    as: :schnorr_validate_signature
end
