{ pkgs, ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
        key_bindings = [
          { key = "J"; mods = "Command"; action = "ScrollPageUp"; }
          { key = "K"; mods = "Command"; action = "ScrollPageDown"; }
        ]; 
      };
  };
}
