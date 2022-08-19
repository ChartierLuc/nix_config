final: prev: {
  riced-alacritty = prev.callPackage ./riced-alacritty { };
  riced-firefox = prev.callPackage ./riced-firefox { };
  riced-neovim = prev.callPackage ./riced-neovim { };
  whiplash-gtk-theme = prev.callPackage ./whiplash-gtk-theme {};
}
