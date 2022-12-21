mod atoms {
    rustler::atoms! {
        ok,
        signing_key_decoding_failed,
        verifying_key_decoding_failed,
        signature_decoding_failed,
        invalid_signature,
    }
}

type Ok = rustler::Atom;

#[rustler::nif]
fn schnorr_generate_random_signing_key() -> Vec<u8> {
    schnorr::get_random_signing_key()
}

#[rustler::nif]
fn schnorr_create_signature(
    signing_key: Vec<u8>,
    contents: rustler::Binary,
) -> Result<(Ok, Vec<u8>), rustler::Error> {
    schnorr::create_signature(&signing_key, &contents)
        .map_err(Into::into)
        .map(|signature| (atoms::ok(), signature))
}

#[rustler::nif]
fn schnorr_verifying_key_from_signing_key(
    signing_key: Vec<u8>,
) -> Result<(Ok, Vec<u8>), rustler::Error> {
    schnorr::verifying_key_from_signing_key(&signing_key)
        .map_err(Into::into)
        .map(|verifying_key| (atoms::ok(), verifying_key))
}

#[rustler::nif]
fn schnorr_validate_signature(
    message: rustler::Binary,
    signature: Vec<u8>,
    verifying_key: Vec<u8>,
) -> Result<Ok, rustler::Error> {
    match schnorr::validate_signature(&message, &signature, &verifying_key) {
        Ok(_) => Ok(atoms::ok()),
        Err(error) => Err(error.into()),
    }
}

mod schnorr {
    use k256::schnorr::{
        signature::{Signer, Verifier},
        Signature, SigningKey, VerifyingKey,
    };
    use rand_core::OsRng;

    use super::atoms;

    pub enum Error {
        SigningKeyDecodingFailed,
        VerifyingKeyDecodingFailed,
        SignatureDecodingFailed,
        InvalidSignature,
    }
    impl Into<rustler::Error> for Error {
        fn into(self) -> rustler::Error {
            rustler::Error::Term(Box::new(match self {
                Error::SigningKeyDecodingFailed => atoms::signing_key_decoding_failed(),
                Error::VerifyingKeyDecodingFailed => atoms::verifying_key_decoding_failed(),
                Error::SignatureDecodingFailed => atoms::signature_decoding_failed(),
                Error::InvalidSignature => atoms::invalid_signature(),
            }))
        }
    }

    pub fn get_random_signing_key() -> Vec<u8> {
        SigningKey::random(&mut OsRng).to_bytes().to_vec()
    }

    pub fn create_signature(key: &[u8], contents: &[u8]) -> Result<Vec<u8>, Error> {
        let signing_key =
            SigningKey::from_bytes(&key).map_err(|_| Error::SigningKeyDecodingFailed)?;
        let signature = signing_key.sign(&contents).as_bytes().to_vec();

        Ok(signature)
    }

    pub fn verifying_key_from_signing_key(signing_key: &[u8]) -> Result<Vec<u8>, Error> {
        let signing_key =
            SigningKey::from_bytes(&signing_key).map_err(|_| Error::SigningKeyDecodingFailed)?;
        let verifying_key = signing_key.verifying_key().to_bytes().to_vec();

        Ok(verifying_key)
    }

    pub fn validate_signature(
        message: &[u8],
        signature: &[u8],
        verifying_key: &[u8],
    ) -> Result<(), Error> {
        let verifying_key = VerifyingKey::from_bytes(&verifying_key)
            .map_err(|_| Error::VerifyingKeyDecodingFailed)?;

        let signature =
            Signature::try_from(signature).map_err(|_| Error::SignatureDecodingFailed)?;

        match verifying_key.verify(message, &signature) {
            Ok(_) => Ok(()),
            Err(_) => Err(Error::InvalidSignature),
        }
    }
}

rustler::init!(
    "Elixir.K256",
    [
        schnorr_generate_random_signing_key,
        schnorr_create_signature,
        schnorr_verifying_key_from_signing_key,
        schnorr_validate_signature,
    ]
);
