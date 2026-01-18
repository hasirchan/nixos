{ pkgs, ... }:
{
  imports = [
    ../../torii/user
    ./pkgs
  ];

  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5.addons = with pkgs; [
      qt6Packages.fcitx5-chinese-addons
      fcitx5-mozc
    ];
  };

  i18n.inputMethod.fcitx5.settings = {
    inputMethod = {
      GroupOrder."0" = "Default";
      "Groups/0" = {
        Name = "Default";
        "Default Layout" = "us";
        DefaultIM = "keyboard-us";
      };
      "Groups/0/Items/0".Name = "keyboard-us";
      "Groups/0/Items/1".Name = "shuangpin";
      "Groups/0/Items/2".Name = "mozc";
    };
    globalOptions = {
      "Hotkey/TriggerKeys" = {
        "0" = "Control+Alt+Alt_L";
      };
    };
  };
}
