{ config, pkgs, lib, ... }:

{
  users.users."luc".openssh.authorizedKeys.keys = [
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAILXYgGFE3f+Kw3WyCHAIIehJOsUotgEfEOsB/VqAcIckAAAABHNzaDo= ssh:" # content of authorized_keys file
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
}
