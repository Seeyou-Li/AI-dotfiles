# AI-dotfiles

Claude Code 配置文件仓库，用于跨电脑同步 Claude Code 设置、全局指令和 Skills。

## 目录结构

```
dotfiles/
├── install.sh                     # 一键安装脚本
├── claude/                        # Claude Code 配置
│   ├── CLAUDE.md                  # 全局用户指令（所有项目生效）
│   ├── RTK.md                     # RTK (Rust Token Killer) CLI 代理配置
│   ├── settings.template.json     # settings.json 模板（不含 API Token）
│   └── skills/                    # 手动维护的 Skills（非 ccswitch 管理）
│       ├── skill-creator/         # Skill 创建器：用于编写新 Skill
│       └── embedded-code-review/  # 嵌入式 C/C++ 代码审查 Skill
└── cc-switch/                     # ccswitch 配置
    ├── settings.json              # ccswitch 自身设置
    └── skills/                    # ccswitch 管理的 32 个 Skills
        ├── docx/                  # Word 文档处理
        ├── pptx/                  # PPT 文档处理
        ├── pdf/                   # PDF 文档处理
        ├── xlsx/                  # Excel 表格处理
        ├── frontend-design/       # 前端 UI 设计
        ├── canvas-design/         # 画布视觉设计（海报/艺术作品）
        ├── algorithmic-art/       # 算法艺术（p5.js 生成艺术）
        ├── brand-guidelines/      # 品牌风格指南
        ├── theme-factory/         # 主题工厂
        ├── slack-gif-creator/     # Slack GIF 制作
        ├── webapp-testing/        # Web 应用测试
        ├── web-artifacts-builder/ # Web 构建产物
        ├── claude-api/            # Claude API / Anthropic SDK 开发
        ├── mcp-builder/           # MCP Server 构建
        ├── internal-comms/        # 内部沟通文档撰写
        ├── brainstorming/         # 头脑风暴
        ├── executing-plans/       # 执行实施计划
        ├── writing-plans/         # 编写实施计划
        ├── test-driven-development/     # 测试驱动开发
        ├── systematic-debugging/        # 系统化调试
        ├── subagent-driven-development/ # Subagent 驱动开发
        ├── dispatching-parallel-agents/ # 并行 Agent 调度
        ├── finishing-a-development-branch/  # 完成开发分支
        ├── requesting-code-review/      # 请求代码审查
        ├── receiving-code-review/       # 接收代码审查
        ├── verification-before-completion/ # 完成前验证
        ├── using-git-worktrees/         # Git Worktree 使用
        ├── using-superpowers/           # Superpowers 使用
        ├── writing-skills/              # Skill 编写
        ├── skills/                      # 需求澄清 Skill
        ├── doc-coauthoring/             # 文档协作
        └── template/                    # Skill 模板
```

## 文件说明

| 文件 | 作用 |
|------|------|
| [CLAUDE.md](claude/CLAUDE.md) | Claude Code 全局指令，引用 RTK.md，设定中文交流、Karpathy 编码规范等 |
| [RTK.md](claude/RTK.md) | RTK CLI 代理配置，用于减少开发命令的 Token 消耗 |
| [settings.template.json](claude/settings.template.json) | settings.json 模板，安装后需填入 `ANTHROPIC_AUTH_TOKEN` 和 `ANTHROPIC_BASE_URL` |
| [embedded-code-review](claude/skills/embedded-code-review/SKILL.md) | 嵌入式 C/C++ 代码审查 Skill，覆盖内存安全、中断上下文、DMA/cache、实时性等检查 |
| [skill-creator](claude/skills/skill-creator/) | Anthropic 官方 Skill 创建器，用于编写和管理 Skills |
| [cc-switch/skills/](cc-switch/skills/) | ccswitch 统一管理的 32 个 Skills，覆盖文档、设计、开发、调试等场景 |

## 安装

在新电脑上：

```bash
# 1. 克隆仓库
git clone git@github.com:Seeyou-Li/AI-dotfiles.git ~/dotfiles

# 2. 运行安装脚本
cd ~/dotfiles && bash install.sh

# 3. 编辑 settings.json，填入你的 API Token
vim ~/.claude/settings.json
```

## 更新同步

修改配置或 Skills 后：

```bash
cd ~/dotfiles
git add -A
git commit -m "描述改动"
git push
```

换电脑后拉取更新：

```bash
cd ~/dotfiles && git pull
```
