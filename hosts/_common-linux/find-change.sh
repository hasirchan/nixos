#!/usr/bin/env bash

find /home | while IFS= read -r path; do
  if [ -L "$path" ]; then
    # 是符号链接，跳过
    continue
  elif [ -d "$path" ]; then
    # 是目录，跳过
    continue
  else
    # 普通文件或者其他类型文件，输出
    echo "$path"
  fi
done
