{ config, lib, pkgs, ...}:{
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "susops" ''
      export SOPS_AGE_KEY_CMD="${pkgs.ssh-to-age}/bin/ssh-to-age -private-key -i /etc/ssh/ssh_host_ed25519_key"
      exec sudo -E ${pkgs.sops}/bin/sops "$@"
    '')
    pkgs.sops
  ];
}
