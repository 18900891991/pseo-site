#!/bin/bash

# 打印执行时间
echo "--- Deployment started at $(date) ---"

# 进入脚本所在目录
cd "$(dirname "$0")"

# 检查 Git 状态并提交
git add .
git commit -m "Auto-deploy: AI generated content $(date +'%Y-%m-%d %H:%M:%S')"

# 推送到 GitHub (确保你已经配置了 SSH 免密登录)
git push origin main

echo "--- Deployment finished ---"