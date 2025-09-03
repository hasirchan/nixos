{ config, lib, pkgs, ... } :

{
  imports = [
    ./i3status-rust.nix
  ];

/*
  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };
    cursorTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };
  };
*/
  wayland.windowManager.sway.config.bars = [{
    position = "top";
    statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-default.toml & pid=\$!; echo \$pid > /dev/shm/i3status-rs.pid; wait \$pid";
    fonts = {
      names = [ "JetBrainsMono Nerd Font" ];
      size = 10.0;
    };
    colors = {
      # 状态栏背景色 - 与窗口背景保持一致
      background = "#282a36";
      
      # 当前活跃工作区 - 使用亮紫色突出显示
      activeWorkspace = {
        background = "#bd93f9";
        border = "#bd93f9";
        text = "#282a36";  # 深色文字确保在亮紫色背景上可读
      };
      
      # 非活跃但可见的工作区 - 使用暗紫色
      inactiveWorkspace = {
        background = "#44475a";
        border = "#44475a";
        text = "#f8f8f2";  # 白色文字
      };
      
      # 聚焦但非当前工作区 - 中等紫色调
      focusedWorkspace = {
        background = "#6272a4";
        border = "#6272a4";
        text = "#f8f8f2";
      };
      
      # 紧急状态工作区 - 红色警告
      urgentWorkspace = {
        background = "#ff5555";
        border = "#ff5555";
        text = "#f8f8f2";
      };
      
      # 绑定模式指示器 - 使用青色突出显示
      bindingMode = {
        background = "#8be9fd";
        border = "#8be9fd";
        text = "#282a36";
      };
      
      # 聚焦状态下的状态栏背景
      focusedBackground = "#282a36";
      
      # 聚焦状态下的分隔符 - 使用紫色
      focusedSeparator = "#bd93f9";
      
      # 聚焦状态下的状态行文字
      focusedStatusline = "#f8f8f2";
      
      # 普通分隔符 - 使用深灰色
      separator = "#44475a";
      
      # 普通状态行文字
      statusline = "#f8f8f2";
    };

    extraConfig = ''
      id default
      icon_theme Adwaita
    '';
  }];
}
