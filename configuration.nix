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
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./network-storage.nix
    ./traefik.nix
    ./jellyfin-podman.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "mercurius"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = false;

  networking.nftables.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Vienna";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.flo = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOUOVBT5VOL+/QWjSR8pg8ypM9GOeM+iAclgnr/PLc/Q florian@nixos"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEIeit6QqfmOL0Olb8DA6SJbSMM/rkHktpM+oCHEtHyc u0_a161@localhost"
    ];
  };

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    btop
    eza
    fastfetch
    git
    htop
    ncdu
    wget
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
  };

  programs.bash.shellAliases = {
    ls = "eza --icons=always --color=auto";
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      KbdInteractiveAuthentication = false;
    };
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 ];
  networking.firewall.allowedUDPPorts = [ ];

  networking = {
  interfaces.ens3 = {
    ipv6.addresses = [{
      address = "2a01:4f8:1c1b:16d0::1";
      prefixLength = 64;
    }];
    ipv4.addresses = [{
      address = "192.0.2.2";
      prefixLength = 24;
    }];
  };
  defaultGateway = {
    address = "192.0.2.1";
    interface = "ens3";
  };
  defaultGateway6 = {
    address = "fe80::1";
    interface = "ens3";
  };
};


  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?

}
