{ pkgs, ... }:
{
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "sops" ''
      exec env SOPS_AGE_KEY_CMD="sudo ${pkgs.ssh-to-age}/bin/ssh-to-age -private-key -i /etc/ssh/ssh_host_ed25519_key" "${pkgs.sops}/bin/sops" "$@"
    '')
  ];
}
