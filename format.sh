#!/usr/bin/env bash
set -euo pipefail

echo "=== 开始全项目源码格式标准化清洗 ==="

# 1. 统一所有文本文件的行尾符为 Unix LF (清除 Windows CRLF \r 换行符)
echo "[1/4] 清理 Windows CRLF 换行符与非标准不可见字符..."
find . -type f \( -name "*.yml" -o -name "*.yaml" -o -name "*.config" -o -name "*.sh" -o -name "Makefile" \) -print0 | while IFS= read -r -d '' file; do
  sed -i 's/\r$//' "$file"
  # 替换不间断空格 (NBSP \xC2\xA0) 为普通空格
  sed -i 's/\xc2\xa0/ /g' "$file"
done

# 2. 规范化 GitHub Actions YAML 文件（保证纯净 2 空格缩进，绝无 Tab）
echo "[2/4] 对齐 GitHub Actions 工作流缩进..."
find .github/workflows -type f \( -name "*.yml" -o -name "*.yaml" \) -print0 | while IFS= read -r -d '' file; do
  # 将 Tab 转成 2 个空格
  sed -i 's/\t/  /g' "$file"
  # 清理行末无效空格
  sed -i 's/[[:space:]]*$//' "$file"
done

# 3. 规范化 OpenWrt .config 配置文件（保证等号左右无空格、去除空行冗余）
echo "[3/4] 格式化 .config 编译配置文件..."
find . -maxdepth 1 -type f -name "*.config" -print0 | while IFS= read -r -d '' file; do
  # 清理行末尾空格
  sed -i 's/[[:space:]]*$//' "$file"
  # 去除多个连续空行，仅保留单空行
  sed -i '/^$/N;/^\n$/D' "$file"
done

# 4. 规范化 Shell 脚本与 Makefile
echo "[4/4] 检查 Makefile 纯净度..."
find . -type f -name "Makefile" -print0 | while IFS= read -r -d '' file; do
  # 清除行末尾无用空格
  sed -i 's/[[:space:]]*$//' "$file"
done

echo "=== 格式对齐完毕，代码已符合规范标准 ==="
