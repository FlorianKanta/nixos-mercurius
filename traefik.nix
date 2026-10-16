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

  services.traefik = {
    enable = true;

    staticConfigOptions = {
      entryPoints = {
        web = {
          address = ":80";
          asDefault = true;
          http.redirections.entrypoint = {
            to = "websecure";
            scheme = "https";
          };
        };

        websecure = {
          address = ":443";
          asDefault = true;
          http.tls.certResolver = "letsencrypt";
        };
      };

      log = {
        level = "INFO";
        filePath = "${config.services.traefik.dataDir}/traefik.log";
        format = "json";
      };

      certificatesResolvers.letsencrypt.acme = {
        email = "8kzvwjr15@mozmail.com";
        storage = "${config.services.traefik.dataDir}/acme.json";
        httpChallenge.entryPoint = "web";
      };

      api.dashboard = false;
      # Access the Traefik dashboard on <Traefik IP>:8080 of your server
      # api.insecure = true;
    };

    dynamicConfigOptions = {
      http = {
        services = {
          jellyfin.loadBalancer.servers = [
            { url = "http://localhost:8096"; }
          ];
        };
        routers = {
          jellyfin = {
            entryPoints = [ "websecure" ];
            service = "jellyfin";
            rule = "Host(`jellyfin.glados.kbytes.at`)";
            tls.certResolver = "letsencrypt";
          };
        };
      };
    };
  };
}
