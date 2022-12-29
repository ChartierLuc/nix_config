{ config, pkgs, lib, ... }:

{
  users.users."luc".openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOS0gfgZSClZ2panUC995JSeEBwcrvSjzRSa3lOGABk8 luc"
    # note: ssh-copy-id will add user@clientmachine after the public key
    # but we can remove the "@clientmachine" part
  ];
  services.openssh = {
    enable = true;
    # require public key authentication for better security
    passwordAuthentication = false;
    kbdInteractiveAuthentication = false;
    #permitRootLogin = "yes";
  };

  networking.firewall = {
    allowedTCPPorts = [ 22 ];
  };
}
