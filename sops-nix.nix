{ config, lib, pkgs, ... }:
{
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";

  system.activationScripts.fix-sops-perm = {
    deps = [ "setupSecrets" ];
    text = ''
      mkdir -p /var/lib/sops-nix/
      
      if [ -f /etc/ssh/ssh_host_ed25519_key ]; then
        ${pkgs.ssh-to-age}/bin/ssh-to-age -private-key -i /etc/ssh/ssh_host_ed25519_key > /var/lib/sops-nix/key.txt
        chmod 600 /var/lib/sops-nix/key.txt
      fi

      mkdir -p /home/saya/.config/sops/age
      if [ -f /var/lib/sops-nix/key.txt ]; then
        cp /var/lib/sops-nix/key.txt /home/saya/.config/sops/age/keys.txt
        chown saya:users /home/saya/.config/sops/age/keys.txt
        chmod 600 /home/saya/.config/sops/age/keys.txt
      fi
    '';
  };
}
