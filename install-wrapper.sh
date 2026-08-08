#!/bin/bash
# ============================================================
#  Local AI Painter v3.0 — Gradle Wrapper 安装脚本
#  将已下载的 gradle-8.7-bin.zip 中的 gradle-wrapper.jar
#  提取到项目的 gradle/wrapper/ 目录
# ============================================================

set -e

PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"
WRAPPER_DIR="${PROJECT_ROOT}/gradle/wrapper"
TARGET_JAR="${WRAPPER_DIR}/gradle-wrapper.jar"

# 颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}══════════════════════════════════════════${NC}"
echo -e "${BLUE}  Local AI Painter v3.0 — Wrapper 安装器${NC}"
echo -e "${BLUE}══════════════════════════════════════════${NC}"
echo ""

# 1. 查找用户已下载的 gradle zip
echo -e "${YELLOW}[1/4]${NC} 查找 Gradle 8.7 压缩包..."
GRADLE_ZIP=""
SEARCH_PATHS=(
    "${PROJECT_ROOT}/gradle-8.7-bin.zip"
    "${PROJECT_ROOT}/../gradle-8.7-bin.zip"
    "${HOME}/Downloads/gradle-8.7-bin.zip"
    "${HOME}/Desktop/gradle-8.7-bin.zip"
    "${HOME}/gradle-8.7-bin.zip"
)

for p in "${SEARCH_PATHS[@]}"; do
    if [ -f "$p" ]; then
        GRADLE_ZIP="$p"
        echo -e "      找到: ${GREEN}${GRADLE_ZIP}${NC}"
        break
    fi
done

# 如果没找到，提示用户手动指定
if [ -z "$GRADLE_ZIP" ]; then
    echo -e "      ${RED}未自动找到 gradle-8.7-bin.zip${NC}"
    echo ""
    echo "请通过以下方式之一提供："
    echo "  a) 将 gradle-8.7-bin.zip 放到项目根目录"
    echo "  b) 设置环境变量：export GRADLE_ZIP=/path/to/gradle-8.7-bin.zip"
    echo "  c) 手动运行：unzip -j gradle-8.7-bin.zip '*/gradle-wrapper.jar' -d gradle/wrapper/"
    echo ""
    if [ -n "$GRADLE_ZIP_ENV" ]; then
        GRADLE_ZIP="$GRADLE_ZIP_ENV"
    else
        exit 1
    fi
fi

# 2. 确保目录存在
echo ""
echo -e "${YELLOW}[2/4]${NC} 准备目录..."
mkdir -p "${WRAPPER_DIR}"
echo -e "      目录: ${WRAPPER_DIR}"

# 3. 提取 gradle-wrapper.jar
echo ""
echo -e "${YELLOW}[3/4]${NC} 提取 gradle-wrapper.jar..."
unzip -j "${GRADLE_ZIP}" '*/gradle-wrapper.jar' -d "${WRAPPER_DIR}/"

if [ -f "${TARGET_JAR}" ]; then
    SIZE=$(du -h "${TARGET_JAR}" | cut -f1)
    echo -e "      ${GREEN}成功!${NC} 文件大小: ${SIZE}"
else
    echo -e "      ${RED}提取失败!${NC} 请检查 zip 文件完整性"
    exit 1
fi

# 4. 验证
echo ""
echo -e "${YELLOW}[4/4]${NC} 验证..."
if jar tf "${TARGET_JAR}" | grep -q "GradleWrapperMain.class"; then
    echo -e "      ${GREEN}✓${NC} gradle-wrapper.jar 验证通过"
else
    echo -e "      ${RED}✗${NC} gradle-wrapper.jar 内容异常"
    exit 1
fi

echo ""
echo -e "${GREEN}══════════════════════════════════════════${NC}"
echo -e "${GREEN}  安装完成! 现在可以运行构建脚本了${NC}"
echo -e "${GREEN}══════════════════════════════════════════${NC}"
echo ""
echo "  下一步:"
echo "    ./gradlew assembleRelease    # 构建 Release APK"
echo "    ./gradlew assembleDebug      # 构建 Debug APK"
echo "    ./gradlew clean              # 清理构建缓存"
echo ""
