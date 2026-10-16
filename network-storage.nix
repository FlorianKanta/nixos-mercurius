# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [ ];

  fileSystems."/mnt/jellyfin" = {
  device = "u290540-sub6@u290540.your-storagebox.de:";
  fsType = "sshfs";
  options = [
    "nodev"
    "noatime"
    "allow_other"
    "IdentityFile=/root/.ssh/id_ed25519"
    "port=23"
  ];
};

}
