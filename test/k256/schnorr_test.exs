defmodule K256.SchnorrTest do
  use ExUnit.Case
  doctest K256.Schnorr

  alias K256.Schnorr

  describe "generate_random_signing_key/0" do
    test "generated keys are 32 bytes in size" do
      key = Schnorr.generate_random_signing_key()
      assert 32 = byte_size(key)
    end
  end

  describe "use cases" do
    @signing_key <<55, 14, 109, 176, 3, 155, 215, 40, 96, 24, 255, 181, 207, 8, 199, 33, 58, 17,
                   64, 82, 84, 80, 175, 39, 191, 149, 226, 164, 70, 119, 212, 206>>

    test "validating a signature" do
      message = "This is some content to sign"
      assert {:ok, signature} = Schnorr.create_signature(@signing_key, message)
      assert {:ok, verifying_key} = Schnorr.verifying_key_from_signing_key(@signing_key)
      assert :ok = Schnorr.validate_signature(message, signature, verifying_key)
    end

    test "generating and validating a signature" do
      signing_key = Schnorr.generate_random_signing_key()
      message = "This is some content to sign"
      assert {:ok, signature} = Schnorr.create_signature(signing_key, message)
      assert {:ok, verifying_key} = Schnorr.verifying_key_from_signing_key(signing_key)
      assert :ok = Schnorr.validate_signature(message, signature, verifying_key)
    end
  end
end
