#!/usr/bin/env bash

# 冷却时间变量（每个监听器独立）
NETWORK_LAST_SIGNAL=0
BLUETOOTH_LAST_SIGNAL=0
POWER_LAST_SIGNAL=0
UDEV_LAST_SIGNAL=0
COOLDOWN=1  # 1秒冷却时间

# 向i3status发送信号的函数（带冷却检查）
notify_i3status() {
    local monitor_type="$1"
    local current_time=$(date +%s)
    local last_signal_var="${monitor_type}_LAST_SIGNAL"
    local last_signal_time
    
    # 获取对应监听器的上次信号时间
    case "$monitor_type" in
    "NETWORK")
        last_signal_time=$NETWORK_LAST_SIGNAL
        ;;
    "BLUETOOTH")
        last_signal_time=$BLUETOOTH_LAST_SIGNAL
        ;;
    "POWER")
        last_signal_time=$POWER_LAST_SIGNAL
        ;;
    "UDEV")
        last_signal_time=$UDEV_LAST_SIGNAL
        ;;
    *)
        echo "$(date): Unknown monitor type: $monitor_type"
        return
        ;;
    esac
    
    # 检查是否在冷却期内
    if [ $((current_time - last_signal_time)) -lt $COOLDOWN ]; then
    echo "$(date): $monitor_type signal ignored (cooling down)"
    return
    fi
    
    # 更新对应监听器的上次信号时间
    case "$monitor_type" in
    "NETWORK")
        NETWORK_LAST_SIGNAL=$current_time
        ;;
    "BLUETOOTH")
        BLUETOOTH_LAST_SIGNAL=$current_time
        ;;
    "POWER")
        POWER_LAST_SIGNAL=$current_time
        ;;
    "UDEV")
        UDEV_LAST_SIGNAL=$current_time
        ;;
    esac
    
    # 查找所有i3status进程并发送USR1信号
    pgrep i3status | while read pid; do
    if [ -n "$pid" ]; then
        echo "$(date): $monitor_type - Sending USR1 signal to i3status (PID: $pid)"
        kill -USR1 "$pid" 2>/dev/null || true
    fi
    done
}

# 监听NetworkManager事件（WiFi和以太网）
monitor_network() {
    dbus-monitor --system \
    "type='signal',interface='org.freedesktop.NetworkManager',member='StateChanged'" \
    "type='signal',interface='org.freedesktop.NetworkManager.Connection.Active',member='StateChanged'" \
    "type='signal',interface='org.freedesktop.NetworkManager.Device',member='StateChanged'" \
    "type='signal',interface='org.freedesktop.DBus.Properties',member='PropertiesChanged',arg0='org.freedesktop.NetworkManager'" \
    "type='signal',interface='org.freedesktop.DBus.Properties',member='PropertiesChanged',arg0='org.freedesktop.NetworkManager.Device'" \
    "type='signal',interface='org.freedesktop.DBus.Properties',member='PropertiesChanged',arg0='org.freedesktop.NetworkManager.Connection.Active'" |
    while read -r line; do
    if echo "$line" | grep -q "StateChanged\|PropertiesChanged"; then
        echo "$(date): Network state changed"
        notify_i3status "NETWORK"
    fi
    done &
}

# 监听蓝牙事件
monitor_bluetooth() {
    dbus-monitor --system \
    "type='signal',interface='org.freedesktop.DBus.Properties',member='PropertiesChanged',arg0='org.bluez.Adapter1'" \
    "type='signal',interface='org.freedesktop.DBus.Properties',member='PropertiesChanged',arg0='org.bluez.Device1'" |
    while read -r line; do
    if echo "$line" | grep -q "PropertiesChanged"; then
        echo "$(date): Bluetooth state changed"
        notify_i3status "BLUETOOTH"
    fi
    done &
}

# 监听电源事件（充电器接入/移除）
monitor_power() {
    dbus-monitor --system \
    "type='signal',interface='org.freedesktop.DBus.Properties',member='PropertiesChanged',arg0='org.freedesktop.UPower.Device'" |
    while read -r line; do
    if echo "$line" | grep -q "PropertiesChanged"; then
        echo "$(date): Power state changed"
        notify_i3status "POWER"
    fi
    done &
}

# 使用udev监听硬件事件作为补充（特别关注以太网）
monitor_udev() {
    udevadm monitor --udev --subsystem-match=power_supply --subsystem-match=net --subsystem-match=bluetooth |
    while read -r line; do
    if echo "$line" | grep -E "(ADD|REMOVE|CHANGE).*(/power_supply/|/net/|/bluetooth/)"; then
        echo "$(date): Hardware event detected: $line"
        notify_i3status "UDEV"
    # 特别处理以太网载波状态变化
    elif echo "$line" | grep -E "CHANGE.*(/class/net/.*eth|/class/net/.*enp)"; then
        echo "$(date): Ethernet carrier event detected: $line"
        notify_i3status "UDEV"
    fi
    done &
}

echo "$(date): Starting network status monitor..."

# 启动所有监听器
monitor_network
monitor_bluetooth  
monitor_power
monitor_udev

# 等待所有后台进程
wait
