{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    wget
    tree
    lsof
    inotify-tools
    nix-your-shell
    p7zip
    aria2
    unar
    just
    gettext
    # quickemu
    pass
    unzip
    pciutils
 ];  
  programs.git.enable = true;
  # programs.vim.enable = true;
}
