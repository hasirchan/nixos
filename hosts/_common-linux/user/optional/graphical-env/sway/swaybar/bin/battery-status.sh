#!/usr/bin/env bash

# 清洗state值的函数
clean_state() {
    local state="$1"
    if [[ "$state" == *"-"* ]]; then
        first_word=$(echo "$state" | cut -d'-' -f1)
        rest_words=$(echo "$state" | cut -d'-' -f2-)
        first_word_cap="$(tr '[:lower:]' '[:upper:]' <<< "${first_word:0:1}")${first_word:1}"
        echo "$first_word_cap $rest_words"
    else
        echo "$(tr '[:lower:]' '[:upper:]' <<< "${state:0:1}")${state:1}"
    fi
}


# 获取电池信息
battery_info=$(upower -i $(upower -e | grep BAT))
ac_info=$(upower -i $(upower -e | grep line))

# 提取电池状态和电量
state=$(echo "$battery_info" | grep -E "state" | awk '{print $2}')
percentage=$(echo "$battery_info" | grep -E "percentage" | awk '{print $2}' | sed 's/%//')

# 提取AC状态
ac_online=$(echo "$ac_info" | grep -E "online" | awk '{print $2}')

# 清洗状态文本
clean_state_text=$(clean_state "$state")

# 确保percentage是数字
if ! [[ "$percentage" =~ ^[0-9]+$ ]]; then
    percentage=0
fi

# 根据条件确定颜色状态
if [[ "$ac_online" == "yes" ]]; then
    # 接入电源，绿色
    i3_state="Good"
elif [[ "$percentage" -lt 30 ]]; then
    # 电量小于30%，红色
    i3_state="Critical"
elif [[ "$percentage" -lt 50 ]]; then
    # 电量在30-50之间，黄色
    i3_state="Warning"
else
    # 电量大于50%，蓝色
    i3_state="Info"
fi

# 输出JSON格式
cat << EOF
{
    "state": "$i3_state", 
    "text": "$clean_state_text $percentage%"
}
EOF