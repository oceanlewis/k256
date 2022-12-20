{ pkgs }:

with pkgs; let

  nativeBuildInputs =
    lib.optional stdenv.isLinux pkgs.inotify-tools ++
    lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
      CoreServices
      Foundation
    ]);

  beamPackages = beam.packagesWith beam.interpreters.erlangR25;

  buildInputs = [
    elixir_1_14
    elixir_ls
    rust-bin.stable.latest.complete
  ];

  # define shell startup command
  shellHook = ''
    # Set up `mix` to save dependencies to the local directory
    mkdir -p .nix-mix
    mkdir -p .nix-hex
    export MIX_HOME=$PWD/.nix-mix
    export HEX_HOME=$PWD/.nix-hex
    export PATH=$MIX_HOME/bin:$PATH
    export PATH=$HEX_HOME/bin:$PATH

    # Beam-specific
    export LANG=en_US.UTF-8
    export ERL_AFLAGS="-kernel shell_history enabled"
  '';

in
mkShell {
  inherit
    buildInputs
    nativeBuildInputs
    shellHook;
}
