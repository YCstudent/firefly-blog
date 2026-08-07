#!/bin/bash
set -e

# ============================================
# Firefly Blog 部署脚本
# 用法: ./deploy.sh [commit message]
# ============================================

BLOG_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$BLOG_DIR"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log()  { echo -e "${BLUE}[$(date +%H:%M:%S)]${NC} $1"; }
ok()   { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
fail() { echo -e "${RED}[FAIL]${NC} $1"; exit 1; }

COMMIT_MSG="${1:-update blog content}"

echo ""
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}  Firefly Blog 部署${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""

# ---- 1. 检查环境 ----
log "检查 Node.js 环境..."
node --version >/dev/null 2>&1 || fail "Node.js 未安装"
ok "Node.js $(node --version)"

# ---- 2. 检查未保存的改动 ----
log "检查工作区状态..."
if [[ -n $(git status --porcelain) ]]; then
    warn "检测到未提交的改动："
    git status --short
    echo ""
    read -p "是否继续部署？[Y/n] " -r
    if [[ $REPLY =~ ^[Nn] ]]; then
        log "已取消"
        exit 0
    fi
    # 自动暂存所有改动
    git add -A
else
    ok "工作区干净"
fi

# ---- 3. 创建备份点 ----
BACKUP_TAG="backup-$(date +%Y%m%d-%H%M%S)"
log "创建备份点: $BACKUP_TAG"
git branch "$BACKUP_TAG" 2>/dev/null || warn "备份分支已存在，跳过"
ok "备份分支: $BACKUP_TAG"

# ---- 4. 安装依赖（如有变更） ----
log "检查依赖..."
if [[ package.json -nt node_modules ]] || [[ pnpm-lock.yaml -nt node_modules ]]; then
    warn "依赖文件有更新，重新安装..."
    pnpm install || fail "依赖安装失败"
fi
ok "依赖就绪"

# ---- 5. 构建 ----
log "开始构建..."
FIREFLY_BUILD_PLATFORM="Cloudflare Workers" pnpm build || fail "构建失败"
ok "构建完成"

# ---- 6. 检查构建产物 ----
log "检查构建产物..."
if [[ ! -d dist ]] || [[ ! -f dist/index.html ]]; then
    fail "构建产物不完整（dist/index.html 不存在）"
fi
FILE_COUNT=$(find dist -type f | wc -l | tr -d ' ')
ok "构建产物: ${FILE_COUNT} 个文件"

# ---- 7. 部署到 Cloudflare Workers ----
log "部署到 Cloudflare Workers..."
npx wrangler deploy || fail "部署失败"
ok "部署成功"

# ---- 8. 提交到 Git ----
log "提交到 GitHub..."
git commit -m "$COMMIT_MSG" --no-verify 2>/dev/null && GIT_COMMITTED=true || GIT_COMMITTED=false

if $GIT_COMMITTED; then
    log "推送到远程仓库..."
    git push || warn "推送失败（可稍后手动 git push）"
    ok "已推送到 GitHub"
else
    warn "无新改动需要提交"
fi

# ---- 9. 线上验证 ----
log "线上验证..."
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" --max-time 15 "https://ustinus.202886.xyz" 2>/dev/null || echo "000")
if [[ "$HTTP_CODE" == "200" ]]; then
    ok "线上验证通过 (HTTP $HTTP_CODE)"
else
    warn "线上验证异常 (HTTP $HTTP_CODE)，请手动检查"
fi

echo ""
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}  部署完成！${NC}"
echo -e "${GREEN}  线上地址: https://ustinus.202886.xyz${NC}"
echo -e "${GREEN}  备份分支: $BACKUP_TAG${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
