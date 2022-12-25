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
      assert {:ok, signature} = Schnorr.create_signature(message, @signing_key)
      assert {:ok, verifying_key} = Schnorr.verifying_key_from_signing_key(@signing_key)
      assert :ok = Schnorr.verify_message(message, signature, verifying_key)
    end

    test "generating and validating a signature" do
      signing_key = Schnorr.generate_random_signing_key()
      message = "This is some content to sign"
      assert {:ok, signature} = Schnorr.create_signature(message, signing_key)
      assert {:ok, verifying_key} = Schnorr.verifying_key_from_signing_key(signing_key)
      assert :ok = Schnorr.verify_message(message, signature, verifying_key)
    end
  end

  describe "test-vectors.csv" do
    @test_vectors File.read!("./test/resources/test-vectors.csv")
                  |> NimbleCSV.RFC4180.parse_string()
                  |> Enum.map(fn [
                                   _index,
                                   _secret_key,
                                   public_key,
                                   _aux_rand,
                                   message,
                                   signature,
                                   verification,
                                   _result
                                 ] ->
                    [
                      Base.decode16!(public_key),
                      Base.decode16!(message),
                      Base.decode16!(signature),
                      case verification do
                        "TRUE" -> true
                        "FALSE" -> false
                      end
                    ]
                  end)

    test "test cases hold" do
      validate = fn [
                      public_key,
                      message,
                      signature,
                      verification
                    ] ->
        result = Schnorr.verify_message_digest(message, signature, public_key)

        case verification do
          true -> assert :ok = result
          false -> assert {:error, _} = result
        end
      end

      @test_vectors
      |> Enum.map(&validate.(&1))
    end
  end
end
