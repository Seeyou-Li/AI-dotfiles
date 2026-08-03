#!/bin/bash
set -e

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

echo "==> 安装 Claude Code 配置文件..."

# --- Claude Code 全局配置 ---
mkdir -p ~/.claude
ln -sf "$DOTFILES/claude/CLAUDE.md" ~/.claude/CLAUDE.md
ln -sf "$DOTFILES/claude/RTK.md" ~/.claude/RTK.md

# settings.json: 如果不存在则从模板创建
if [ ! -f ~/.claude/settings.json ]; then
  cp "$DOTFILES/claude/settings.template.json" ~/.claude/settings.json
  echo "  -> 已创建 ~/.claude/settings.json，请填入你的 API Token"
fi

# MCP 服务器配置
if [ ! -f ~/.claude/.mcp.json ]; then
  cp "$DOTFILES/claude/.mcp.json" ~/.claude/.mcp.json
  echo "  -> 已创建 ~/.claude/.mcp.json（MCP 服务器配置）"
fi

# --- 手动 Skills ---
mkdir -p ~/.claude/skills
ln -sfn "$DOTFILES/claude/skills/skill-creator" ~/.claude/skills/skill-creator
ln -sfn "$DOTFILES/claude/skills/embedded-code-review" ~/.claude/skills/embedded-code-review

# --- cc-switch ---
if [ -d "$DOTFILES/cc-switch/skills" ]; then
  mkdir -p ~/.cc-switch
  if [ ! -f ~/.cc-switch/settings.json ]; then
    cp "$DOTFILES/cc-switch/settings.json" ~/.cc-switch/settings.json 2>/dev/null || true
  fi
  echo "  -> cc-switch 配置文件已就位"
  echo "  -> 请手动安装 cc-switch 后运行 'ccswitch sync' 恢复 skills"
fi

# --- Codex CLI ---
mkdir -p ~/.codex
if [ ! -f ~/.codex/config.toml ]; then
  cp "$DOTFILES/codex/config.toml" ~/.codex/config.toml
  echo "  -> 已创建 ~/.codex/config.toml，请填入 API Key"
fi
if [ ! -f ~/.codex/models.json ]; then
  cp "$DOTFILES/codex/models.json" ~/.codex/models.json
fi
if [ ! -f ~/.codex/AGENTS.md ]; then
  cp "$DOTFILES/codex/AGENTS.md" ~/.codex/AGENTS.md
fi
# Codex skills：从 Claude skills 源复制（Codex 需要平铺目录）
mkdir -p ~/.codex/skills
cp -Lr "$DOTFILES/cc-switch/skills/"* ~/.codex/skills/ 2>/dev/null || true
cp -Lr "$DOTFILES/claude/skills/embedded-code-review" ~/.codex/skills/ 2>/dev/null || true
cp -Lr "$DOTFILES/claude/skills/skill-creator" ~/.codex/skills/ 2>/dev/null || true
echo "  -> Codex skills 已复制（cc-switch + 手动 skills）"

# --- Continue (VSCode 代码补全) ---
if [ ! -f ~/.continue/config.yaml ]; then
  mkdir -p ~/.continue
  cp "$DOTFILES/continue/config.yaml" ~/.continue/config.yaml
  echo "  -> 已创建 ~/.continue/config.yaml，请填入 API Key"
fi

echo ""
echo "==> 安装完成！"
echo "    1. 编辑 ~/.claude/settings.json 填入 API Token"
echo "    2. 编辑 ~/.claude/.mcp.json 填入 TAVILY_API_KEY 和 GITHUB_TOKEN"
echo "    3. 编辑 ~/.codex/config.toml 填入 DEEPSEEK API Key"
echo "    4. 编辑 ~/.continue/config.yaml 填入 DEEPSEEK API Key"
echo "    5. 安装 ccswitch 后运行 cccswitch sync"
