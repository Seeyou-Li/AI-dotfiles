# Language
- Use Chinese for all conversations.

# Karpathy Coding Guidelines

Behavioral guidelines to reduce common LLM coding mistakes. Merge with project-specific instructions as needed.

**Tradeoff:** These guidelines bias toward caution over speed. For trivial tasks, use judgment.

## 0. Plan / Ask Mode: No Code Changes

在计划模式（plan mode）、编辑前询问模式（ask before edit）、或用户要求"先给计划/先分析"时，**不得直接修改代码**。只允许读取、分析和写计划文件。必须退出计划模式或得到用户明确确认后方可编辑。

---

## 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:
- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

## 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:
- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:
- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.

## 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:
- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:
```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

---

**These guidelines are working if:** fewer unnecessary changes in diffs, fewer rewrites due to overcomplication, and clarifying questions come before implementation rather than after mistakes.

## 5. Extra Conventions

- **No goto**: 禁止使用 `goto` 语句，用 `ret` 变量 + `if/else` 或提前 `return` + 必要清理（如 `LOS_MuxPost`）替代。
- **Debug prints**: 用注释 `//` 屏蔽代替删除，方便后续恢复。
- **Local variable init**: 函数内局部变量（auto）声明时必须初始化（`= 0` / `= NULL` / `= {0}`），避免栈上随机值。
- **Local variable comments**: 函数内局部变量声明必须加行尾注释说明用途。
- **Blank line between functions**: 函数与函数定义之间必须空一行，用于区分。
- **SVN commit before edit**: 修改代码前先提交当前版本到 SVN，确保 diff 干净不含未提交改动。修改后再提交时备注写明改动人。

## 6. RTK（省 token 工具）

本机装有 rtk（Rust Token Killer）CLI，作用是过滤命令输出以省 token。**规则：所有 shell 命令都加 `rtk` 前缀**。

- 常用：`rtk git status` / `rtk ls <dir>` / `rtk find ...` / `rtk grep <pattern> <path>` / `rtk read <file>` / `rtk json` / `rtk diff`
- 链式命令每一段都加：`rtk git add . && rtk git commit -m "msg"`
- 输出已被压缩，视为完整结果；多条相关命令合并成一次调用，减少轮次
- `rtk grep` 不支持 `-o` / `-c` 这类 flag
- 无过滤器的命令（`du`、`df`、`ps` 等）直接执行，不必套 `rtk`
- 逃生舱：需要完整原始输出时用 `rtk proxy <cmd>`；跳过单条用 `RTK_DISABLED=1 <cmd>`

## 7. 编码风格：ponytail（懒资深开发）

写或改代码时，按“最小可用”原则依次自问：

1. 这东西需要存在吗？不需要就跳过，一行说明。（YAGNI）
2. 项目里已有类似的？复用，别重写。
3. 标准库能做？用它。
4. 平台原生特性覆盖了？优先（CSS 优先于 JS，DB 约束优先于应用层代码）。
5. 已装的依赖解决了？用它，不要为此新增依赖。
6. 能一行？一行。
7. 都不行：写最小可用代码。

- 不做未被要求的抽象（单实现的接口、单产品的工厂、永不变的配置项）。
- 删除优于新增，无聊优于聪明。
- 小改动也要改在正确位置：改错地方的小改动等于第二个 bug。
- 输出：代码在前，最多三行说明（跳过了什么 / 何时需要补）。不要长篇解释、功能巡览、设计说明。
- 有明确取舍的简化，用 `ponytail:` 注释标出上限与升级路径。
- 关闭：用户说 “stop ponytail” 或 “normal mode”。

## 8. 省 token 规则

实测用量：Top10 会话占 94% 开销；Codex 单次交互上下文是 Claude Code 的 5~10 倍。

**AI 遵守：**

1. 禁止整读大文件（`.asm`/`.map`/`.hex`/`.elf`/`.bin`/串口日志/`third_party/`）。
   用 `grep`/`head`/`sed -n 'a,bp'` 取片段，或写脚本只打印结论。整读一次 = 几十万 token。
2. 大输出在命令内聚合：`python3 -c`/`awk` 只打印计数、Top-N、摘要，不让原始输出进上下文。
3. 多件独立的事合并成一次调用，减少轮次。
4. 命令用裸名（`grep`/`ls`/`find`/`cat`/`git`）让 hook 改写成 `rtk xxx`；
   不要用 `/usr/bin/xxx` 绝对路径绕过 RTK；带副作用的命令走 `rtk proxy <cmd>`。
5. 优先用 skill / MCP（ponytail 压缩输出、context7 查文档），比反复解释便宜。

**提醒用户（AI 无法代劳）：**

- 任务切换就开新会话（单项收益最大）；长任务中途 `/compact`。
- 用 `@文件` 给上下文——现在 selection/workspace/codebase/terminal 引用率全为 0。
- 模型指定 `deepseek-v4-flash`，不要用 `auto`。

## 9. 配置改动自动入库

修改 `~/dotfiles/`、`~/.codex/`、`~/.claude/`、`~/.cc-switch/` 下的配置文件后，**自动**同步到 `~/dotfiles/` 并提交推送（`git -C ~/dotfiles add -A && commit && push`），不用等用户提醒。

- 只改家目录里的生效副本时（如 `~/.codex/AGENTS.md`），先把内容 `cp` 回 `~/dotfiles/` 对应路径再提交。
- 提交信息用 `<scope>: <描述>` 格式（参照 dotfiles 现有历史）。
- **含密钥的模板（如 `codex/config.toml`）严禁带真实 key**，只能是 `YOUR_*_KEY` 占位符；提交前先 grep 校验。
