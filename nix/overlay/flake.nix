{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-e046.url = "github:NixOS/nixpkgs/e0464e47880a69896f0fb1810f00e0de469f770a";
  };

  outputs = { self, nixpkgs, nixpkgs-e046, ... }: let
    system = "x86_64-linux";
    pkgs-e046 = import nixpkgs-e046 {
      inherit system;
    };
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [
        (self: super: {
          azure-cli = pkgs-e046.azure-cli;
        })
      ];
    };
  in {
    devShells.${system}.default = pkgs.mkShell {
      packages = with pkgs; [
        zsh
        terraform
        dotnetCorePackages.sdk_9_0
        azure-cli
      ];

      shellHook = ''
        export LOGLEVEL="info"
        echo "LOGLEVEL set to $LOGLEVEL"
        zsh
      '';
    };
  };
}
