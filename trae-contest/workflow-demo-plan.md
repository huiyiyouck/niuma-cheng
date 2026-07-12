# Workflow Demo 改造方案（v2.1，已应用指挥官 review 5 处修正 —— 见第 11 节修正记录）

调研日期：2026-07-03
前置文件：`research-plan.md`、`submission-checklist.md`、`demo-post-workflow.md`
核心问题：**工作流（agent-workflow）怎么让评委能使用或尝试？**

---

## 1. 核心结论

**把工作流打包成 TRAE 自定义智能体，生成分享链接，评委一键导入试用。** 这是"让评委尝试工作流"的最佳路径，门槛远低于 clone GitHub。

看板已上线（`workboard.huiyiyou.cloud`）解决"看结果"，智能体分享链接解决"自己试"，录屏解决"看怎么跑"。

## 2. TRAE 原生能力调研

### 三个分享机制对比

| 机制 | 评委门槛 | 适合承载 | 来源 |
|---|---|---|---|
| **自定义智能体分享链接** | 极低（点链接→打开 TRAE→立即获取） | 角色切换、核心规则、工具配置 | [创建并管理智能体](https://docs.trae.cn/ide_agent) |
| **Skill 导入**（SKILL.md / .zip） | 中（设置里导入文件） | 详细流程规范、模板 | [技能 Skill](https://docs.trae.cn/ide_skills) |
| **GitHub clone + AGENTS.md** | 中（clone 后零配置，Trae 原生认 agents.md 开放标准，见 F2） | 完整工作流真源 | agent-workflow 现状 |

### 关键发现

1. **智能体分享链接机制**：TRAE IDE 支持把自定义智能体生成分享链接（形如 `https://s.trae.com.cn/a/xxxxxx`），评委点链接 → 浏览器引导打开 TRAE IDE → 点"立即获取" → 导入完成，可直接 @ 使用。
2. **官方已有先例**：TRAE 官方"一键导入智能体"列表已有 `Backend Architect`、`Frontend Architect`、`DevOps Architect`、`API Test Pro`、`AI Integration Eng`、`Performance Expert` 等——与 agent-workflow 的角色（Architect/Developer/DevOps）**天然对应**。工作流角色制不是另起炉灶，是 TRAE 智能体生态的延伸。
3. **Skill 按需加载**：SKILL.md 结构化描述任务目标/场景/指令/示例，按需加载省 Token（vs 规则全量加载）；可 .zip 导入，也支持 `.agents/skills/` 目录。
4. **子智能体原生支持**：TRAE 支持子智能体（独立上下文、可被主智能体调用）；agent-workflow 已有 [subagents/](file:///Users/ck/Project/niuma-cheng/agent-workflow/docs/baseline/subagents) 目录（sub-backend.md、sub-frontend.md），概念直接对应。

## 3. 推荐方案

**主推：TRAE 智能体分享链接**（评委体验入口）
**辅助：GitHub Skill 包**（深度体验）
**补充：看板导览视图**（不试用的评委看懂价值）

### 评委体验路径（5 分钟，零 clone）

1. 评委点帖子里的智能体分享链接
2. 浏览器引导打开 TRAE IDE
3. 点"立即获取" → 智能体导入完成
4. 在 TRAE IDE 里 @ 这个智能体，说"进入团队工作流"或"你是 PM，给一个 TODO 功能写 PRD"
5. 智能体按工作流角色响应（角色切换、PRD 流程、Review 门禁）

### 工作流 → TRAE 形态映射

| agent-workflow 现有 | TRAE 原生形态 | 说明 |
|---|---|---|
| [AGENTS.md](file:///Users/ck/Project/niuma-cheng/agent-workflow/AGENTS.md)（入口角色切换路由） | 主智能体"一人公司 AI 工作流" | 提示词=角色切换逻辑+核心约束 |
| [docs/baseline/role-*.md](file:///Users/ck/Project/niuma-cheng/agent-workflow/docs/baseline)（PM/Architect/Developer/DevOps） | 子智能体 | 每角色一个，独立上下文，主智能体调度 |
| [docs/baseline/multi-agent-workflow.md](file:///Users/ck/Project/niuma-cheng/agent-workflow/docs/baseline/multi-agent-workflow.md)（协作规范） | Skill（按需加载） | 评委真跑迭代时才加载详细流程 |
| [docs/baseline/standard-iteration-quick.md](file:///Users/ck/Project/niuma-cheng/agent-workflow/docs/baseline/standard-iteration-quick.md) | Skill | 标准迭代速查 |
| [docs/templates/*.md](file:///Users/ck/Project/niuma-cheng/agent-workflow/docs/templates) | Skill 资源文件 | PRD/设计/测试模板 |

## 4. 三条改造线（并行）

### 线 1：TRAE 智能体（主推，评委体验入口）

| # | 事项 | 产出 | 执行方 |
|---|---|---|---|
| 1.1 | 在 TRAE IDE 创建主智能体，提示词压缩角色切换路由 + 核心约束 | 智能体配置 | 指挥官（TRAE 里操作，记 Session ID） |
| 1.2 | 每个角色做成子智能体（PM/Architect/Developer/DevOps） | 4 个子智能体 | 指挥官 |
| 1.3 | 详细规则做成 Skill（协作规范+迭代速查+模板） | SKILL.md 包 | 工作流组（规则重构） |
| 1.4 | 设计 5 分钟评委体验场景（示例需求 + 预期响应路径） | 体验脚本 | 参谋长出草稿 |
| 1.5 | 生成分享链接 | s.trae.com.cn 链接 | 指挥官 |
| 1.6 | 录屏 2-3 分钟：演示评委怎么点链接、怎么用、一轮真实迭代 | 视频 | 指挥官 |

### 线 2：GitHub Skill 包（深度体验补充）

| # | 事项 | 产出 | 执行方 |
|---|---|---|---|
| 2.1 | 把 agent-workflow 规则重构为若干 SKILL.md | Skill 包 | 工作流组 |
| 2.2 | 通用化+脱敏（去内部 URL、项目私有信息） | 公开版规则 | 工作流组 |
| 2.3 | 建公开 GitHub 仓库，放 .zip + 快速开始 README | 公开仓库 | 参谋长建壳 + 工作流组填内容 |
| 2.4 | 仓库同时也是"工作流真源"的公开版 | — | 工作流组 |

### 线 3：看板导览视图（不试用的评委看懂）

| # | 事项 | 产出 | 执行方 |
|---|---|---|---|
| 3.1 | 在 workboard 加"工作流导览"视图，或独立单页 | 导览页 | workboard 项目组 |
| 3.2 | 三层架构、双通道、BCR 状态机、游标机制可视化 | 可视化呈现 | workboard 项目组 |
| 3.3 | 配合线上看板，60 秒看懂工作流价值 | — | workboard 项目组 |

## 5. 三件套呈现给评委的层次

```
看板（看结果）  +  智能体链接（自己试）  +  录屏（看怎么跑）
   ↓                    ↓                      ↓
 workboard           TRAE 分享链接           2-3 分钟视频
 已上线              评委一键导入           演示一轮真实迭代
```

帖子"体验地址"写法（待 review 定稿）：
1. 看板（线上直接访问）：`https://workboard.huiyiyou.cloud`
2. 工作流智能体（想自己试）：TRAE 分享链接
3. 演示视频：视频链接

## 6. 未确定 / 待 review 的思考点

以下是我在调研中识别、但需要指挥官拍板的开放问题：

### 6.1 智能体范围（决定工作量）

- **选项 A**：单智能体 + 压缩提示词。工作量小，但详细流程无法全塞入，评委体验浅。
- **选项 B**：主智能体 + 4 角色子智能体 + Skill。体验最完整，但工作量大。
- **选项 C（推荐）**：先做单智能体跑通评委体验，时间够再加子智能体和 Skill。渐进式降风险。

**待定**：选哪个？我倾向 C，但取决于你 7-15 前的时间预算。

### 6.2 智能体提示词 Token 上限

TRAE 智能体提示词能承载多少规则未确认。agent-workflow 的 [AGENTS.md](file:///Users/ck/Project/niuma-cheng/agent-workflow/AGENTS.md) 入口 + [runtime.md](file:///Users/ck/Project/niuma-cheng/agent-workflow/docs/baseline/runtime.md) 路由 + 核心约束，压缩后可能塞得下；但 [multi-agent-workflow.md](file:///Users/ck/Project/niuma-cheng/agent-workflow/docs/baseline/multi-agent-workflow.md) 完整协作规范 + 各角色手册 + 模板，大概率要外置为 Skill。

**待定**：提示词塞到什么粒度？详细规则是否必须做成 Skill 附带？需要实测 Token 上限。

### 6.3 评委体验场景定什么

候选：
- "给 TODO 功能写 PRD"：通用，评委容易理解，但和工作流价值关联弱
- "给一个新闻评分功能写 PRD"：和小报 Demo 交叉引用，但评委不熟业务
- "启动标准迭代"：最贴合工作流本质，但评委可能不知道 PRD 是什么

**待定**：哪个场景既让评委 5 分钟能跑完，又能体现工作流价值？

### 6.4 Skill 包是否独立建公开仓库

- 选项 A：只做智能体附带的 Skill，不建仓库。轻量但无 GitHub 入口。
- 选项 B：建公开仓库放 Skill 包 + README。有 GitHub 入口，也是"工作流真源公开版"，但多一个维护点。

**待定**：是否建公开仓库？若建，仓库归工作流组还是新建？

### 6.5 导览视图位置

- 选项 A：workboard 加"工作流导览"视图。评委在看板上顺手看，但改动 workboard 代码。
- 选项 B：独立单页 HTML（对齐已有 [workflow-proposal.html](file:///Users/ck/Project/trae-contest/workflow-proposal.html) 风格）。独立、不改 workboard，但要单独部署。

**待定**：哪个？

### 6.6 智能体是否配 MCP Server

工作流本身不需要外部工具（角色切换+文档产出）。但配 MCP Server（如文件系统、终端）可能让智能体更"能干"，加分。TRAE 智能体支持配 MCP Server 和内置工具（阅读/文件系统/终端/联网搜索/预览）。

**待定**：配哪些工具？建议至少配"文件系统"+"阅读"，让智能体能真的产出 PRD 文件。

### 6.7 评委门槛实测

智能体分享链接要求评委有 TRAE IDE + 账号。门槛比 clone 低，但不是零。

**待定**：是否需要先实测一遍"评委点链接到能用"的真实路径，确认无卡点？

### 6.8 与小报 Demo 的交叉引用

小报 Demo 走生活娱乐赛道。是否让小报的一个功能迭代用这个 TRAE 智能体跑一轮，作为"工作流产出现实产品"的活证据？

**待定**：两个 Demo 是否在 TRAE 实践环节互相引用？这能互相加分。

### 6.9 脱敏清单

智能体提示词、Skill 内容、录屏里不能有：
- 内部 URL（huiyiyou.cloud 的内部路径、服务器地址）
- API key / token / 数据库连接串
- 项目私有信息（coordination 内部决策细节）
- 个人邮箱、手机号

**待定**：脱敏清单何时过？建议发布前最后一道。

## 7. 风险与备选

| 风险 | 应对 |
|---|---|
| 智能体提示词承载不了完整工作流 | 降级为单智能体 + GitHub 完整规则包（线 2 兜底） |
| 评委不愿意导入智能体 | 录屏 + 看板导览保底（线 3 兜底） |
| TRAE 智能体分享机制变更 | 以官方文档为准，发布前实测一遍导入路径 |
| 7-15 前时间不够做完整三线 | 砍线 3（导览视图），保线 1（智能体）+ 线 2（Skill 包） |

## 8. 边界与执行权分配

按 AGENTS.md 参谋长边界：

| 改造线 | 执行权 | 参谋长角色 |
|---|---|---|
| 线 1 TRAE 智能体 | 指挥官（在 TRAE IDE 操作，Session ID 由此而来） | 出体验脚本草稿、协调 |
| 线 1 规则重构为 Skill | 工作流组 | 协调、不进组 |
| 线 2 GitHub 公开仓库 | 指挥官建仓 + 工作流组填内容 | 不立项（F3：真源 export 发布物，不走立项） |
| 线 3 看板导览视图 | workboard 项目组 | 协调、不进组 |
| 录屏、Session ID | 指挥官 | 不参与 |

## 9. 下一步

1. ~~指挥官 review 本方案，圈定第 6 节未确定点~~ ✅ 已完成，结论见第 10 节。
2. ~~把三条线拆成 step-by-step 可执行清单~~ ✅ 已完成，见第 11 节。
3. ~~指挥官 review 第 11 节可执行清单~~ ✅ 已完成，5 处修正已应用（见第 11 节末修正记录）。
4. 按执行权分配到各项目组；公开仓按第 10 节 F3 结论走"真源发布物"路线，**不立项**。
5. 各线产出回填到 `demo-post-workflow.md` 和 `submission-checklist.md` 证据登记表。

## 10. Review 意见与拍板记录（2026-07-03）

Review 前提：生态当日发生 P14 组织定位升级（BCR-007，指挥官—参谋长制·薄公司）与 P13 Trae IDE 兼容确认（AGENTS.md 零改动复用为 Trae 入口），本节结论已消化这两项变化。方案总体方向**通过**：智能体分享链接主推、三条线并行、渐进式降风险均确认。

### 10.1 四条 review findings 及处置

| # | Finding | 处置（已拍板） |
|---|---------|---------------|
| F1 | 导览与帖子只讲工作流层，与官方角色智能体（Backend Architect 等）同质化风险高；P14 后组织架构层才是差异化卖点 | **分层叙事**：前 60 秒讲工作流层（4 角色 + PRD→Review→部署门禁，配智能体链接立即可试）；压轴讲组织架构层（指挥官—参谋长制、公告板、BCR 闭环，配 xiaobao/workboard/ai 三个真实上线项目为活证据）。对外品牌不变。6.8 交叉引用是两层之间的桥 |
| F2 | 第 2 节把"GitHub clone + AGENTS.md"评为高门槛已过时——P13 确认 Trae 原生认 agents.md 开放标准，clone 后零配置可用 | 线 2 门槛评级下调为**中**；"兼容 agents.md 开放标准"写入帖子，作为标准兼容加分证据 |
| F3 | 方案 2.4"公开仓同时是工作流真源公开版"会产生第二真源，违背 single source of truth | **真源 export 脚本 + 发布物公开仓**：agent-workflow 仓加 `export-public.sh`（照 install-downstream.sh 模式），抽取→脱敏→生成 Skill 包 + README，push 到公开仓。公开仓 README 顶部声明"由真源生成，不接受 PR，反馈走 issue"。归属工作流组的 release 渠道，**不走立项流程**、不进 PROJECTS.md 项目索引；coordination 仅在 agent-workflow 条目下补一行公开仓地址 |
| F4 | baseline 中 `role-tester.md`、`role-ui.md` 仍在（历史保留），但角色已按 BCR-004/006 合并 | Skill 重构（2.1/2.2）以 4 角色为准，不得把已合并角色重新拆出；6.9 脱敏清单加一条：BCR-007/P14 内部决策稿不外发，对外统一用 README 品牌口径 |

### 10.2 第 6 节待定点落定

| 待定点 | 结论 |
|--------|------|
| 6.1 智能体范围 | **C**：先单智能体跑通评委体验，时间够再加子智能体和 Skill |
| 6.2 Token 上限 | 实测，与 6.7 合并执行 |
| 6.3 体验场景 | "你是 PM，给 TODO 功能写 PRD 并走 Review"——把门禁体验进去，门禁是卖点 |
| 6.4 公开仓库 | 按 F3：真源 export 脚本 + 发布物公开仓，不立项 |
| 6.5 导览位置 | **B**：独立单页 HTML（对齐 workflow-proposal.html 风格），不改 workboard；内容按 F1 两层结构组织 |
| 6.6 MCP/工具 | 至少配"文件系统 + 阅读"，让智能体能真产出 PRD 文件 |
| 6.7 评委门槛实测 | 与 6.2 合并为一次**评委路径彩排**：点链接导入 → 验证提示词上限 → 完整跑一轮体验场景 |
| 6.8 交叉引用 | **做**：小报一个小功能用该智能体跑一轮，作为"工作流产出现实产品"的活证据，两 Demo 互相引用 |
| 6.9 脱敏清单 | 发布前最后一道；按 F4 增补内部决策稿条目 |

### 10.3 Review 中发现的生态遗留项（不属于本方案，仅登记）

- `/Users/ck/Project/niuma-cheng/ai/` 存在 untracked 裸目录（仅框架文件，入口与 niuma-cheng-ai 相同），疑似 2026-07-03 修 sync-downstream.sh macOS 兼容时误跑 install-downstream 的产物，会与 niuma-cheng-ai 混淆。**待指挥官确认后删除**。

### 10.4 ai 裸目录核实结论（参谋长核实，2026-07-03）

对比 `/Users/ck/Project/niuma-cheng/ai/` 与 `/Users/ck/Project/niuma-cheng/niuma-cheng-ai/`：

| 项 | `ai/`（裸目录） | `niuma-cheng-ai/`（真项目） |
|---|---|---|
| `docs/progress/` | ❌ 无 | ✅ 有，含 v0.1 迭代、角色日志、INDEX |
| `docs/baseline/project-context.md` | ❌ 只有 template | ✅ 已填项目事实 |
| `.workflow-version` | ❌ 无 | ✅ 有 |
| `src/` 业务代码 | ❌ 无 | ✅ agent_hub 完整实现 |
| `tests/` | ❌ 无 | ✅ 5 个测试文件 |
| `README.md` / `requirements.txt` / `.env.example` | ❌ 无 | ✅ 全有 |
| `docs/knowledge/decisions/` | ❌ 无 | ✅ 2 个 ADR |

**结论**：`ai/` 100% 是 install-downstream.sh 误产出的空框架副本，与真项目严重混淆，**确认应删除**。指挥官与参谋长核实结论一致（10.3 + 10.4），证据充分，**已授权删除**。按参谋长边界不手改下游文件，由指挥官或工作流组执行删除。

---

## 11. 可执行清单（一步 = 一次会话能独立完成的任务包）

粒度定义：每步是一个会话能独立干完的任务包，不下探到代码/diff 级。五栏固定结构：执行方 / 输入 / 动作 / 产出 / 验收。

### 线 1：TRAE 智能体（主推，评委体验入口）

> 依赖关系（v2.1 修正后）：**1.7 → 1.1 → 1.2 → 1.3 → 1.5 → 1.4 → 1.6 → 1.8**；X.1 依赖 1.2，可与 1.3/1.5 并行。
> 理由：1.7 场景脚本须先于 1.1（提示词参照场景写才不返工）；1.4 彩排须用 1.5 生成的链接（评委真实路径），排在 1.5 之后。

- [ ] **1.7 评委体验场景脚本（先行，1.1 提示词须参照本场景写）**
    - 执行方：参谋长
    - 输入：[docs/baseline/role-pm.md](file:///Users/ck/Project/niuma-cheng/agent-workflow/docs/baseline/role-pm.md)、[docs/templates/prd.md](file:///Users/ck/Project/niuma-cheng/agent-workflow/docs/templates/prd.md)、6.3 定的场景"给 TODO 功能写 PRD 并走 Review"
    - 动作：① 写评委 5 分钟操作脚本：第一步说什么、预期智能体响应、第二步说什么 ② 设计预期产出（PRD 文件结构、Review 触发）③ 标注门禁体验点（PM 创建 PRD 后才能启动迭代，门禁即卖点）
    - 产出：`/Users/ck/Project/trae-contest/judge-experience-script.md`
    - 验收：评委照脚本 5 分钟能跑完；门禁体验点至少 2 处

- [ ] **1.1 主智能体提示词草稿**
    - 执行方：参谋长
    - 输入：1.7 产出的体验脚本（**提示词须参照场景写**）、[agent-workflow/AGENTS.md](file:///Users/ck/Project/niuma-cheng/agent-workflow/AGENTS.md)（入口角色切换路由）、[docs/baseline/runtime.md](file:///Users/ck/Project/niuma-cheng/agent-workflow/docs/baseline/runtime.md)（工作流加载后路由）、[docs/baseline/mechanisms.md](file:///Users/ck/Project/niuma-cheng/agent-workflow/docs/baseline/mechanisms.md)（非角色机制）
    - 动作：① 抽取 AGENTS.md 入口角色切换逻辑（General→PM/Architect/Developer/DevOps）② 压缩 runtime.md 加载流程为 3-5 步 ③ 提炼 mechanisms.md 核心约束（Bootstrap/收尾/迭代关闭检查）④ 围绕 1.7 体验场景设计提示词响应路径 ⑤ 拼成单个提示词文本，标注哪些规则因 Token 限制需外置 Skill
    - 产出：`/Users/ck/Project/trae-contest/agent-prompt-draft.md`
    - 验收：提示词覆盖角色切换+核心门禁+工作流加载；标注外置清单；不超过 4000 字（TRAE 提示词实测上限待 1.4 验证）

- [ ] **1.2 主智能体在 TRAE IDE 创建**
    - 执行方：指挥官
    - 输入：1.1 产出的 `agent-prompt-draft.md`、TRAE IDE
    - 动作：① 打开 TRAE IDE → 输入框 @ → 创建智能体 ② 粘贴提示词 ③ 配置工具：勾选"文件系统"+"阅读" ④ 命名"一人公司 AI 工作流"⑤ 创建 → 测试 @ 该智能体说"你是谁"
    - 产出：TRAE IDE 里的主智能体；**记 Session ID**
    - 验收：智能体响应符合角色切换逻辑；Session ID 记入 `submission-checklist.md` 第 4 节 Demo 1 表

- [ ] **1.3 Skill 包结构设计**
    - 执行方：工作流组
    - 输入：[docs/baseline/multi-agent-workflow.md](file:///Users/ck/Project/niuma-cheng/agent-workflow/docs/baseline/multi-agent-workflow.md)、[standard-iteration-quick.md](file:///Users/ck/Project/niuma-cheng/agent-workflow/docs/baseline/standard-iteration-quick.md)、[non-iteration-quick.md](file:///Users/ck/Project/niuma-cheng/agent-workflow/docs/baseline/non-iteration-quick.md)、[docs/templates/](file:///Users/ck/Project/niuma-cheng/agent-workflow/docs/templates) 全部
    - 动作：① 按 TRAE SKILL.md 格式拆分：`workflow-collaboration`（协作规范）、`standard-iteration`（标准迭代速查）、`non-iteration`（非迭代速查）、`templates`（模板资源）② 每个 SKILL.md 写 description（触发条件）+ 指令 ③ 按 F4：以 4 角色为准，不重新拆出 UI/Tester ④ 打包成 .zip
    - 产出：4 个 SKILL.md + 资源文件，.zip 包
    - 验收：每个 SKILL.md 有 name/description/指令三段；.zip 可被 TRAE 导入（设置→技能与命令→创建→上传 .zip）

- [ ] **1.5 生成分享链接**
    - 执行方：指挥官
    - 输入：1.2 主智能体
    - 动作：① 智能体设置→分享 ② 复制链接 ③ 验证链接可被外部账号导入
    - 产出：`https://s.trae.com.cn/a/xxxxxx` 链接
    - 验收：链接能引导打开 TRAE IDE 并导入智能体

- [ ] **1.4 评委路径彩排（合并 6.2/6.7）**
    - 执行方：指挥官
    - 输入：1.2 主智能体、1.3 的 Skill 包、**1.5 生成的链接**、1.7 体验脚本
    - 动作：① 用另一个 TRAE 账号或无痕窗口模拟评委点 1.5 生成的链接 ② 验证提示词 Token 上限：如果创建时报错或截断，记录上限，回 1.1 调整 ③ 完整跑一遍 1.7 体验场景 ④ 记录卡点 ⑤ 若有修正回 1.1/1.2 后重新生成链接并复测
    - 产出：彩排记录（Token 上限、卡点、改进项）
    - 验收：评委从点链接到跑完体验场景无阻塞；或卡点已识别并有应对

- [ ] **1.6 录屏 2-3 分钟**
    - 执行方：指挥官
    - 输入：1.5 分享链接、1.7 体验脚本、workboard.huiyiyou.cloud
    - 动作：① 录制：点链接 → 导入 → @ 智能体 → 跑体验场景 → 看板状态变化 ② 配旁白或字幕 ③ 脱敏检查（无内部 URL/token/邮箱）
    - 产出：视频文件
    - 验收：2-3 分钟；覆盖点链接到跑完一轮；过 `submission-checklist.md` 第 5 节脱敏清单

- [ ] **X.1 小报真实迭代证据（6.8 交叉引用落地，R1 修正新增）**
    - 执行方：指挥官
    - 输入：1.2 主智能体、niuma-cheng-xiaobao 项目
    - 动作：① 在小报项目里挑一个小功能 ② 用主智能体跑一轮标准迭代（PM 出 PRD → Developer 实现 → Review）③ 记录 Session ID、截图、产出物链接 ④ 作为"工作流产出现实产品"的活证据
    - 产出：迭代记录 + Session ID + 截图 + 产出物链接
    - 验收：完成一轮真实迭代；Session ID 喂给 C.1；截图喂给 C.2；产出物链接喂给 1.8
    - **注意**：耗时最不可控，1.2 完成后尽早排进日程；可与 1.3/1.5 并行

- [ ] **1.8 帖子体验地址段撰写**
    - 执行方：参谋长
    - 输入：1.5 分享链接、1.6 录屏、X.1 小报迭代产出物链接（6.8 交叉引用）
    - 动作：① 写 `demo-post-workflow.md` 第 3 节"体验地址"最终版 ② 三层体验：看板+智能体链接+录屏 ③ 加交叉引用：X.1 产出的小报迭代链接
    - 产出：`demo-post-workflow.md` 第 3 节定稿
    - 验收：三层体验地址齐全；交叉引用清晰

### 线 2：GitHub Skill 包（深度体验补充，按 F3 走真源 export 路线）

> 依赖关系：2.1 → 2.2 → 2.3 → 2.4；2.3 不走立项，2.5 是 coordination 补登记。

- [ ] **2.1 export-public.sh 脚本**
    - 执行方：工作流组
    - 输入：[scripts/install-downstream.sh](file:///Users/ck/Project/niuma-cheng/agent-workflow/scripts/install-downstream.sh)（作为范式）、[docs/baseline/](file:///Users/ck/Project/niuma-cheng/agent-workflow/docs/baseline) 全量、[docs/templates/](file:///Users/ck/Project/niuma-cheng/agent-workflow/docs/templates) 全量
    - 动作：① 照 install-downstream.sh 模式写 export-public.sh ② 抽取 baseline+templates ③ 剥离 SOURCE-REPO-ONLY 块 ④ 通用化（去 niuma-cheng 内部引用）⑤ 生成 Skill 包结构（复用 1.3 的 SKILL.md 拆分）⑥ 生成 README（声明"由真源生成，不接受 PR，反馈走 issue"）⑦ 本地验证产物完整性（push 归 2.3，R3 修正）
    - 产出：`agent-workflow/scripts/export-public.sh` + 本地产物目录
    - 验收：脚本在真源仓可执行；产出物无内部 URL/token/项目私有信息；README 顶部有声明；本地验证产物结构完整

- [ ] **2.2 脱敏与通用化**
    - 执行方：工作流组
    - 输入：2.1 产出物
    - 动作：① 过 `submission-checklist.md` 第 5 节脱敏清单 ② 按 F4 增补：BCR-007/P14 内部决策稿不外发 ③ 把 `niuma-cheng-xiaobao` 等内部项目名替换为通用示例 ④ 验证 agents.md 开放标准兼容（F2）
    - 产出：脱敏后的 Skill 包
    - 验收：无内部信息泄漏；agents.md 零改动可用

- [ ] **2.3 公开仓建立与首次发布**
    - 执行方：指挥官（GitHub 建仓）+ 工作流组（push 内容）
    - 输入：2.2 脱敏后产出、GitHub 账号
    - 动作：① 指挥官在 GitHub 建公开仓（建议名 `agent-workflow-starter` 或 `ai-dev-team-workflow`）② 工作流组跑 export-public.sh 生成产物 → push 首版到公开仓 ③ 验证 clone 后零配置可用
    - 产出：公开 GitHub 仓库
    - 验收：仓库公开可访问；README 含快速开始；clone 后 AGENTS.md 直接可用（F2 验证）
    - **注意**：按 F3 不走立项流程、不进 PROJECTS.md 项目索引

- [ ] **2.4 公开仓地址补登记 coordination**
    - 执行方：参谋长（白名单内直写）
    - 输入：2.3 公开仓地址
    - 动作：① 在 `niuma-cheng-coordination/PROJECTS.md` 的 agent-workflow 条目下补一行公开仓地址 ② 不新增项目索引行
    - 产出：PROJECTS.md 更新
    - 验收：agent-workflow 条目下有公开仓地址；无新增项目行

- [ ] **2.5 工作流组 ROADMAP 更新**
    - 执行方：工作流组
    - 输入：2.1-2.4 完成情况
    - 动作：① 在 agent-workflow `docs/ROADMAP.md` 记录 export-public.sh 落地 ② 标注后续维护节奏（每次真源 baseline 合 main 后跑 export）
    - 产出：ROADMAP 更新
    - 验收：ROADMAP 有 export 机制条目

### 线 3：看板导览视图（独立单页 HTML，按 6.5 选 B）

> 依赖关系：3.1 → 3.2 → 3.3 → 3.4。

- [ ] **3.1 导览页内容设计**
    - 执行方：参谋长
    - 输入：本方案第 1-3 节、[workflow-proposal.html](file:///Users/ck/Project/trae-contest/workflow-proposal.html)（风格参照）、F1 分层叙事结论
    - 动作：① 按 F1 两层结构组织内容：前 60 秒讲工作流层（4 角色+门禁+智能体链接）、压轴讲组织架构层（指挥官—参谋长制+BCR 闭环+三个真实上线项目）② 写文本大纲 ③ 标注每段配什么可视化（三层架构图、双通道状态机、BCR 流转、游标机制）
    - 产出：`/Users/ck/Project/trae-contest/tour-page-outline.md`
    - 验收：内容覆盖两层叙事；可视化标注齐全；60 秒能看懂工作流价值

- [ ] **3.2 导览页 HTML 实现**
    - 执行方：workboard 项目组（或指挥官指定）
    - 输入：3.1 大纲、workflow-proposal.html 的 CSS 风格
    - 动作：① 单页 HTML，对齐 proposal 的渐变背景+卡片风格 ② 实现可视化：三层架构图、双通道状态机、BCR 流转、游标机制 ③ 加智能体分享链接入口（待 1.5 完成后回填）④ 加看板入口（workboard.huiyiyou.cloud）
    - 产出：`/Users/ck/Project/trae-contest/workflow-tour.html`
    - 验收：单页可独立打开；可视化清晰；智能体链接+看板链接齐全

- [ ] **3.3 导览页部署**
    - 执行方：指挥官
    - 输入：3.2 HTML 文件
    - 动作：① 部署到服务器（建议 `tour.huiyiyou.cloud` 或 workboard 子路径）② 验证公开访问
    - 产出：导览页公开 URL
    - 验收：URL 公开可访问；无内部路径泄露

- [ ] **3.4 帖子导览入口回填**
    - 执行方：参谋长
    - 输入：3.3 导览页 URL
    - 动作：① 在 `demo-post-workflow.md` 第 3 节加导览页入口 ② 标注"60 秒看懂工作流价值"
    - 产出：demo-post-workflow.md 更新
    - 验收：帖子有导览页入口

### 收尾：证据回填

- [ ] **C.1 Session ID 回填**
    - 执行方：指挥官
    - 输入：1.2、1.4、1.6、X.1 过程记录的 Session ID
    - 动作：填 `submission-checklist.md` 第 4 节 Demo 1 Session ID 表（≥3 个，覆盖工作流移植、迭代实现、跨项目协调；X.1 的小报迭代 Session 可计入）
    - 产出：submission-checklist.md 更新
    - 验收：≥3 个完整 Session ID，每个配一句话说明

- [ ] **C.2 截图回填**
    - 执行方：指挥官
    - 输入：1.2、1.4、1.6、X.1 过程截图
    - 动作：① 选 ≥3 张 TRAE 关键任务截图 + 产品界面截图 ② 过 `submission-checklist.md` 第 5 节脱敏清单 ③ 填第 4 节截图表
    - 产出：submission-checklist.md 更新
    - 验收：≥3 张截图；脱敏完成

- [ ] **C.3 帖子定稿与脱敏终审**
    - 执行方：参谋长
    - 输入：1.8、3.4、C.1、C.2
    - 动作：① 完整填 `demo-post-workflow.md` 所有 `【回填】` 标记 ② 过帖子整体一致性 ③ 交叉引用小报 Demo 帖 ④ **全部对外物料（帖子/链接/录屏/公开仓）过脱敏清单终审**（R5 修正）⑤ **1.7 体验脚本引用脱敏**：对外物料引用体验脚本内容时，只取上半部分（操作步骤+预期产出），🔒 内部区（彩排注意事项/对提示词约束）一律不得引用或截图
    - 产出：`demo-post-workflow.md` 定稿
    - 验收：无 `【回填】` 残留；帖子标签与报名赛道一致；全部对外物料过脱敏清单终审；1.7 体验脚本的 🔒 内部区内容未出现在任何对外物料中

### 关键依赖与并行机会（v2.1 修正后）

```
线 1: 1.7 → 1.1 → 1.2 → 1.3 → 1.5 → 1.4 → 1.6 → 1.8
                         X.1（依赖 1.2，可与 1.3/1.5 并行）

线 2: 2.1 → 2.2 → 2.3 → 2.4
                       2.5（与 2.4 并行）
线 3: 3.1 → 3.2 → 3.3 → 3.4

跨线依赖：
- 1.3 和 2.1 共享 Skill 拆分逻辑，工作流组可一次拆两用
- 1.5 完成后才能回填 3.2 的智能体链接
- 1.6 录屏依赖 1.5 链接和 1.7 脚本
- X.1 产出物链接喂给 1.8；X.1 的 Session/截图喂给 C.1/C.2
- C.1/C.2 依赖 1.2/1.4/1.6/X.1 完成
```

### 风险触发时的降级路径

- 1.4 彩排发现提示词承载不了 → 1.1 降级为更压缩版本，详细规则全外置 Skill
- 7-10 前线 1 还没跑通 1.4 → 砍线 3，保线 1 + 线 2
- 7-13 前线 1 没完成 1.5 → 帖子降级为"看板+录屏+GitHub Skill 包"，不发智能体链接
- X.1 小报迭代跑不完 → 1.8 交叉引用降级为"计划用该智能体跑小报迭代"，不发产出物链接

### 第 11 节修正记录（v2.1，2026-07-03）

| # | 修正项 | 处置 |
|---|--------|------|
| R1 | 6.8 拍板"做"但清单无对应任务 | 新增 X.1 任务包（小报真实迭代证据），依赖 1.2，产出喂给 1.8/C.1/C.2 |
| R2 | 线 1 依赖顺序错误（1.7 与 1.4 并行、1.4 排在 1.5 前） | 依赖链改为 1.7 → 1.1 → 1.2 → 1.3 → 1.5 → 1.4 → 1.6 → 1.8；1.7 改"先行"；1.4 动作 ① 改"点 1.5 生成的链接"；1.1 加输入"1.7 体验脚本" |
| R3 | 2.1 动作 ⑦"push 到公开仓"越位 | 改为"本地验证产物完整性（push 归 2.3）" |
| R4 | 第 8 节执行权表未同步 F3 | 线 2 行改为"指挥官建仓 + 工作流组填内容 / 不立项（F3：真源 export 发布物，不走立项）" |
| R5 | C.3 缺脱敏终审 | C.3 动作 ④ 加"全部对外物料过脱敏清单终审"；验收加对应条目 |
