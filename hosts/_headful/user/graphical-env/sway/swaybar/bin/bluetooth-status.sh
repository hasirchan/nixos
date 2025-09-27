#!/usr/bin/env bash

# 检查是否有蓝牙控制器
if ! command -v bluetoothctl >/dev/null 2>&1; then
    echo ""
    exit 0
fi

# 获取默认蓝牙控制器信息
controller_info=$(bluetoothctl list 2>/dev/null | head -n1)

# 如果没有蓝牙控制器
if [[ -z "$controller_info" ]]; then
    echo ""
    exit 0
fi

# 提取控制器地址
controller_addr=$(echo "$controller_info" | awk '{print $2}')

# 检查控制器是否被禁用 (rfkill)
if command -v rfkill >/dev/null 2>&1; then
    bt_blocked=$(rfkill list bluetooth | grep -E "Soft blocked: yes|Hard blocked: yes")
    if [[ -n "$bt_blocked" ]]; then
        echo "BT?"
        exit 0
    fi
fi

# 获取控制器详细信息
controller_details=$(bluetoothctl show "$controller_addr" 2>/dev/null)

# 检查是否开启
powered=$(echo "$controller_details" | grep -i "Powered:" | awk '{print $2}')
if [[ "$powered" != "yes" ]]; then
    echo "BT-"
    exit 0
fi

# 检查是否有连接的设备
connected_count=$(bluetoothctl info 2>/dev/null | grep -c "Connected: yes")
if [[ "$connected_count" -gt 0 ]]; then
    echo "BT+"
else
    echo "BT"
fi