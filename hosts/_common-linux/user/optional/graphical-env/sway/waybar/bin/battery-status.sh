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

# 确定CSS类
css_class=""
if [[ "$ac_online" == "yes" ]]; then
    css_class="charging"
elif [[ "$percentage" -le 30 ]]; then
    css_class="critical"
elif [[ "$percentage" -le 50 ]]; then
    css_class="warning"
else
    css_class="good"
fi

# 输出JSON格式
printf '{"text":"%s %s%%","class":"%s","percentage":%d}\n' \
        "$clean_state_text" "$percentage" "$css_class" "$percentage"