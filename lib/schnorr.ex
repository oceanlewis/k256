defmodule K256.Schnorr do
  @opaque signing_key :: binary()
  @opaque verifying_key :: binary()
  @type signature :: binary()

  @type errors ::
          :signing_key_decoding_failed
          | :verifying_key_decoding_failed
          | :signature_decoding_failed
          | :invalid_signature

  @doc "Generates a random Signing Key"
  @spec generate_random_signing_key() :: signing_key()
  defdelegate generate_random_signing_key(),
    to: K256,
    as: :schnorr_generate_random_signing_key

  @doc "Creates an returns a signature of the given `contents` given a signing key"
  @spec create_signature(
          signing_key :: signing_key(),
          contents :: binary()
        ) ::
          {:ok, signature()}
          | {:error, :signing_key_decoding_failed}
  defdelegate create_signature(signing_key, contents),
    to: K256,
    as: :schnorr_create_signature

  @doc "Creates a verifying key given a signing key"
  @spec verifying_key_from_signing_key(signing_key :: signing_key()) ::
          {:ok, verifying_key()}
          | {:error, :signing_key_decoding_failed}
  defdelegate verifying_key_from_signing_key(signing_key),
    to: K256,
    as: :schnorr_verifying_key_from_signing_key

  @doc "Validates the signature of some content given a verifying key"
  @spec validate_signature(
          contents :: binary(),
          signature :: signature(),
          verifying_key :: verifying_key()
        ) ::
          :ok
          | {:error, :invalid_signature}
          | {:error, :signature_decoding_failed}
          | {:error, :verifying_key_decoding_failed}
  defdelegate validate_signature(contents, signature, verifying_key),
    to: K256,
    as: :schnorr_validate_signature
end
