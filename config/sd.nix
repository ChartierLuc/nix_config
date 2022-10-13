{ config, pkgs, lib, ... }:

{
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 ];
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "admin@distored.audio";
  };

  services.nginx.enable = true;
  services.nginx.virtualHosts = 
#    let
#    SSL = {
#      enableACME = true;
#      forceSSL = true;
#    }; in {
#      "frieza.bee.hive" = (SSL // {
#        locations."/".proxyPass = "http://127.0.0.1:7862/";
#
#        serverAliases = [
#          "frieza.bee.hive"
#        ];
#      });
#    };
  {
    "frieza.bee.hive" = ({
      locations."/".proxyPass = "http://127.0.0.1:7862/";
      serverAliases = [
        "frieza.bee.hive"
      ];
    });
  };
}
