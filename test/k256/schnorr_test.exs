defmodule K256.SchnorrTest do
  use ExUnit.Case
  doctest K256.Schnorr

  alias K256.Schnorr

  describe "generate_random_signing_key/0" do
    test "generated keys are 32 bytes in size" do
      key = Schnorr.generate_random_signing_key()
      assert 32 = length(key)
    end
  end

  describe "use cases" do
    test "generating and validating a signature" do
      signing_key = Schnorr.generate_random_signing_key()
      message = "This is some content to sign"
      assert {:ok, signature} = Schnorr.create_signature(signing_key, message)
      assert {:ok, verifying_key} = Schnorr.create_verifying_key(signing_key)
      assert :ok = Schnorr.validate_signature(message, signature, verifying_key)
    end
  end
end
