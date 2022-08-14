final: prev: {
  riced-alacritty = prev.callPackage ./riced-alacritty { };
  riced-firefox = prev.callPackage ./riced-firefox { };
  riced-neovim = prev.callPackage ./riced-neovim { };
  # shell-config = prev.callPackage ./shell-config { };
  zsh-forgit = prev.callPackage ./zsh-forgit { };
}
