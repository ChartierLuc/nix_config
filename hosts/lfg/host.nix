{ config, builtins, lib, pkgs, modulesPath, ... }:
{
  nixpkgs.config.allowUnfree = true;

  networking.useDHCP = lib.mkDefault true;
  networking.hostName = "lfg";

  # users.users.cloudflared = {
  #   group = "cloudflared";
  #   isSystemUser = true;
  # };
  # users.groups.cloudflared = { };

  # systemd.services.my_tunnel = {
  #   wantedBy = [ "multi-user.target" ];
  #   after = [ "network.target" "systemd-resolved.service" ];
  #   serviceConfig = {
  #     ExecStart = "${pkgs.cloudflared}/bin/cloudflared tunnel --no-autoupdate run --token=eyJhIjoiOGY4NmYwYjUxOGFmZWZmZjU4ZDUxNWZlMmEyNTNiMzMiLCJ0IjoiZjZkMWIyNTgtM2M3NC00ZGUwLWFhZmItZmU5ZTIzZTYzZjdhIiwicyI6Ik5qSXhNekl6WmpRdE5EQXpZUzAwWldaaExUZzFZekV0WVdWa056RXpPV1JoTkRFNCJ9";
  #     Restart = "always";
  #     User = "cloudflared";
  #     Group = "cloudflared";
  #   };
  # };
}
