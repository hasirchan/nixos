{ config, lib, pkgs, ... } :

{
  services.mako = {
  enable = true;
  
  # 使用 settings 而不是 extraConfig（新版本 home-manager 已弃用 extraConfig）
  settings = {
    # 基本外观设置
    background-color = "#282a36";  # Dracula 背景色
    text-color = "#f8f8f2";     # 白色文字
    border-color = "#6272a4";     # 暗紫色边框
    progress-color = "#bd93f9";   # 进度条亮紫色
    
    # 边框和形状
    border-size = 2;
    border-radius = 8;
    
    # 尺寸设置
    width = 350;
    height = 120;
    margin = "10";
    padding = "15";
    
    # 字体
    font = "JetBrains Mono 11";
    
    # 图标
    icons = 1;
    max-icon-size = 48;
    
    # 行为
    default-timeout = 8000;
    ignore-timeout = 1;
    
    # 位置和层级
    anchor = "top-right";
    layer = "overlay";
    
    # 排序
    sort = "-time";
    
    # 标记和动作
    markup = 1;
    actions = 1;
  };
  
  # 额外配置用于不同优先级的通知
  extraConfig = ''
    [urgency=low]
    background-color=#282a36
    text-color=#6272a4
    border-color=#44475a
    
    [urgency=critical]
    background-color=#ff5555
    text-color=#f8f8f2
    border-color=#ff5555
    default-timeout=0
    
    [app-name="Spotify"]
    background-color=#282a36
    text-color=#50fa7b
    border-color=#50fa7b
    
    [app-name="Battery"]
    background-color=#f1fa8c
    text-color=#282a36
    border-color=#f1fa8c
  '';
  };
}
