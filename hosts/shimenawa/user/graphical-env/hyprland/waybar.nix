{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        # 基本配置
        layer = "top";
        position = "top";
        height = 15;
        exclusive = false; # 非排他性
        margin-top = 0;
        margin-bottom = 0;

        # 模块布局
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [
          "hyprland/submap"
          "idle_inhibitor"
        ];

        # 工作区模块配置
        "hyprland/workspaces" = {
          format = "{id}";
          on-click = "activate";
          sort-by-number = true;
        };

        # 时钟模块配置 (秒级别)
        "clock" = {
          format = "{:%Y-%m-%d %H:%M:%S}";
          interval = 1;
          tooltip = false;
        };

        # Hyprland submap 模块配置
        "hyprland/submap" = {
          format = "{}";
          tooltip = false;
        };

        # Idle Inhibitor 模块配置
        "idle_inhibitor" = {
          format = "{icon}";
          format-icons = {
            activated = "󰅶";
            deactivated = "󰾪";
          };
          tooltip = false;
        };
      };
    };

    style = ''
      * {
        border: none;
        border-radius: 0;
        /* 使用 JetBrains Mono 或 Noto Sans，小字体下依然清晰 */
        font-family: "JetBrains Mono", "Noto Sans", sans-serif;
        font-size: 10px;
        min-height: 0;
      }

      window#waybar {
        /* 整体背景完全透明 */
        background-color: transparent;
      }

      /* 所有模块的通用样式 */
      #workspaces,
      #clock,
      #submap,
      #idle_inhibitor {
        /* 半透明深色背景 */
        background-color: rgba(30, 30, 46, 0.8);
        /* 白色边框 */
        border: 1px solid rgba(255, 255, 255, 0.3);
        /* 白色文字 */
        color: #ffffff;
        /* 内边距 */
        padding: 0 8px;
      }

      /* 工作区按钮 */
      #workspaces button {
        background-color: transparent;
        color: #ffffff;
        padding: 0 6px;
        border: none;
        transition: all 0.3s ease;
      }

      #workspaces button:hover {
        background-color: rgba(255, 255, 255, 0.1);
      }

      #workspaces button.active {
        background-color: rgba(255, 255, 255, 0.2);
        font-weight: bold;
      }

      #workspaces button.urgent {
        background-color: rgba(255, 100, 100, 0.3);
      }

      /* 时钟样式 */
      #clock {
        font-weight: 500;
      }

      /* Submap 只在激活时显示 */
      #submap {
        background-color: rgba(150, 120, 255, 0.8);
        font-weight: bold;
      }

      /* Idle Inhibitor 不同状态的样式 */
      #idle_inhibitor.activated {
        background-color: rgba(100, 200, 100, 0.8);
      }

      #idle_inhibitor.deactivated {
        background-color: rgba(30, 30, 46, 0.8);
      }
    '';
  };
}
