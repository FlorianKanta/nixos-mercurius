{
  description = "A simple NixOS flake";

  inputs = {
    # NixOS official package source, here using the nixos-26.05 branch
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    {
      # The host with the hostname `my-nixos` will use this configuration
      nixosConfigurations.mercurius = nixpkgs.lib.nixosSystem {
        modules = [
          ./configuration.nix
        ];
      };
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;

    };
}
