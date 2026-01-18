{ pkgs-unfree, ... }:
{
  programs.vscode = {
    enable = true;
    profiles.default.extensions = with pkgs-unfree.vscode-extensions; [
      ms-vscode-remote.remote-ssh
      ms-vscode-remote.remote-ssh-edit
    ];
  };
}
