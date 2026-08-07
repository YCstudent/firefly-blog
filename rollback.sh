#!/bin/bash
set -e

# ============================================
# Firefly Blog 回退脚本
# 用法:
#   ./rollback.sh             交互模式，列出所有回退点
#   ./rollback.sh <备份名>     直接回退到指定备份
#   ./rollback.sh --last      回退到上一次部署前的状态
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

# ============================================
# 列出所有回退点
# ============================================
list_backups() {
    echo ""
    echo -e "${YELLOW}可用的回退点:${NC}"
    echo "──────────────────────────────────────────────"

    # 列出 backup- 分支
    echo ""
    echo -e "${GREEN}【部署备份分支】${NC}"
    git branch | grep "^  backup-" | sed 's/^  /  /' | sort -r | while read branch; do
        local date_part=$(echo "$branch" | sed 's/backup-//')
        local formatted=$(echo "$date_part" | sed 's/\(....\)\(..\)\(..\)-\(..\)\(..\)\(..\)/\1-\2-\3 \4:\5:\6/')
        echo "  $branch  ($formatted)"
    done

    # 列出最近的 git 提交
    echo ""
    echo -e "${GREEN}【最近 Git 提交（可 SHA 回退）】${NC}"
    git log --oneline -10 | while read line; do
        echo "  $line"
    done

    echo ""
    echo -e "${GREEN}【初始备份】${NC}"
    git branch | grep "backup-20260807" | sed 's/^  /  /' || echo "  (未找到)"
    echo "──────────────────────────────────────────────"
    echo ""
}

# ============================================
# 恢复单个文件
# ============================================
restore_file() {
    local file="$1"
    local ref="${2:-HEAD}"

    if [[ ! -f "$file" ]]; then
        fail "文件不存在: $file"
    fi

    log "恢复文件: $file (来源: $ref)"
    git checkout "$ref" -- "$file" || fail "恢复失败"
    ok "文件已恢复: $file"
}

# ============================================
# 回退工作区（未提交的改动）
# ============================================
rollback_workspace() {
    echo ""
    echo -e "${YELLOW}当前未提交的改动:${NC}"
    git status --short
    echo ""
    read -p "确认丢弃所有未提交的改动？[y/N] " -r
    if [[ ! $REPLY =~ ^[Yy] ]]; then
        log "已取消"
        exit 0
    fi

    log "丢弃工作区改动..."
    git checkout -- .
    git clean -fd
    ok "工作区已恢复干净"
}

# ============================================
# 回退到指定分支/提交
# ============================================
rollback_to_ref() {
    local ref="$1"
    local skip_build="${2:-false}"

    # 验证 ref 存在
    if ! git rev-parse --verify "$ref" >/dev/null 2>&1; then
        fail "回退点不存在: $ref"
    fi

    echo ""
    echo -e "${YELLOW}即将回退到: ${GREEN}$ref${NC}"
    git log --oneline -1 "$ref"
    echo ""
    echo -e "${YELLOW}当前: ${GREEN}$(git rev-parse --short HEAD)${NC} $(git log --oneline -1 HEAD | cut -d' ' -f2-)"
    echo ""
    read -p "确认回退？[y/N] " -r
    if [[ ! $REPLY =~ ^[Yy] ]]; then
        log "已取消"
        exit 0
    fi

    # 创建安全备份
    SAFE_TAG="safe-$(date +%Y%m%d-%H%M%S)"
    log "创建安全备份: $SAFE_TAG"
    git branch "$SAFE_TAG"
    ok "当前状态已保存到分支: $SAFE_TAG"

    # 执行回退
    log "正在回退到: $ref..."
    git checkout "$ref" -- .
    ok "文件已回退"

    if $skip_build; then
        warn "跳过构建。请手动运行: pnpm build && npx wrangler deploy"
        return
    fi

    # 重新构建
    log "重新构建..."
    pnpm build || fail "构建失败，正在恢复..."

    # 重新部署
    log "重新部署..."
    npx wrangler deploy || fail "部署失败"

    # 提交回退记录
    git add -A
    git commit -m "rollback to $ref" --no-verify || true

    ok "回退完成，已部署上线"
}

# ============================================
# 主入口
# ============================================

echo ""
echo -e "${YELLOW}============================================${NC}"
echo -e "${YELLOW}  Firefly Blog 回退工具${NC}"
echo -e "${YELLOW}============================================${NC}"

case "${1:-}" in
    --list|-l)
        list_backups
        ;;

    --workspace|-w)
        rollback_workspace
        ;;

    --last)
        # 回退到最近一次 backup- 分支
        LAST_BACKUP=$(git branch | grep "^  backup-" | sort -r | head -1 | sed 's/^  //')
        if [[ -z "$LAST_BACKUP" ]]; then
            fail "没有找到备份分支"
        fi
        rollback_to_ref "$LAST_BACKUP"
        ;;

    --file|-f)
        if [[ -z "$2" ]]; then
            echo "用法: $0 --file <文件路径> [git引用]"
            echo "示例: $0 --file src/config/siteConfig.ts"
            echo "示例: $0 --file src/config/siteConfig.ts HEAD~1"
            exit 1
        fi
        restore_file "$2" "${3:-HEAD}"
        ;;

    "")
        # 交互模式
        list_backups

        echo -e "${YELLOW}选择操作:${NC}"
        echo "  1) 回退到备份分支"
        echo "  2) 回退到某个 git 提交"
        echo "  3) 恢复单个文件"
        echo "  4) 丢弃未提交的改动"
        echo "  5) 只回退文件，不重新构建部署"
        echo "  q) 退出"
        echo ""
        read -p "请输入选项 [1-5/q]: " -r OPT

        case "$OPT" in
            1)
                echo ""
                read -p "输入备份分支名: " -r REF
                rollback_to_ref "$REF"
                ;;
            2)
                echo ""
                read -p "输入 git 提交 SHA（可用上面列表里的短 SHA）: " -r REF
                rollback_to_ref "$REF"
                ;;
            3)
                echo ""
                read -p "输入文件路径（如 src/config/siteConfig.ts）: " -r FILE
                echo ""
                read -p "输入 git 引用（默认 HEAD，即最近一次提交）: " -r REF
                restore_file "$FILE" "${REF:-HEAD}"
                ;;
            4)
                rollback_workspace
                ;;
            5)
                echo ""
                read -p "输入回退点（分支名或 SHA）: " -r REF
                rollback_to_ref "$REF" true
                ;;
            q|Q)
                log "已退出"
                exit 0
                ;;
            *)
                fail "无效选项"
                ;;
        esac
        ;;

    *)
        # 直接指定回退点
        rollback_to_ref "$1"
        ;;
esac

echo ""
ok "操作完成"
