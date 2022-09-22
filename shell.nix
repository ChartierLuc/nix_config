{ pkgs ? import <nixpkgs> {config = { allowUnfree = true; };} }:
  pkgs.mkShell {
    # nativeBuildInputs is usually what you want -- tools you need to run
    nativeBuildInputs = [ pkgs.git pkgs.emacs ];
}