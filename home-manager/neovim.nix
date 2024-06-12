{ pkgs, ... }:

{
    programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
        vim-airline
        vim-nix
        nerdtree
        tokyonight-nvim
    ]
    };
}
