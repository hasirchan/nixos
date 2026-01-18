{ ... }:
{
  users.users.saya = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };
}
