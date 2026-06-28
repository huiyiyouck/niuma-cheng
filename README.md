# niuma-cheng 生态 · 根编排仓

牛马程多项目生态的**根入口**：索引枢纽（`CLAUDE.md`）+ 一键拉起脚本（`setup.sh`）。

> 本仓**只编排**，不含子项目代码。5 个子项目各自是独立 GitHub 仓库、独立部署/演进；`agent-workflow` 是可复用的工作流框架真源（会被复制到各项目）。所以**不合并、保持多仓**，本仓负责把它们在本地组装成一棵树。

## 在新机器上拉起整个生态

```bash
git clone git@github.com:huiyiyouck/<本仓名>.git niuma-cheng
cd niuma-cheng
./setup.sh            # 把 5 个子项目 clone 成兄弟目录（HTTPS=1 ./setup.sh 走 https）
```

## 结构（setup.sh 跑完后）

```text
niuma-cheng/                      ← 本根仓（CLAUDE.md + setup.sh）
├── CLAUDE.md                     ← 生态索引枢纽（导航视图，真源是 coordination/PROJECTS.md）
├── agent-workflow/               ← 工作流框架真源（独立仓，被各项目复制使用）
├── niuma-cheng-coordination/     ← 跨项目协调真源台账（契约/需求池/BCR/状态）
├── niuma-cheng-xiaobao/          ← 主产品：AI 新闻聚合
├── niuma-cheng-ai/               ← L1 LLM 处理服务（Agent Hub）
└── niuma-cheng-workboard/        ← 跨项目 Agent 工作看板
```

> 子项目目录名**不可改**：`workboard/projects.config.json` 用 `../agent-workflow` 等相对路径，跨项目联动靠它。

## 注意
- 各项目的 `.env` / 密钥 / 数据库 / `node_modules` 不在 git，需按 setup.sh 提示手动配。
- 生产/部署（systemd、线上库、域名）留在服务器，本仓只管开发环境组装。
- 本仓不纳入 5 个子项目（见 `.gitignore`），它们各自 clone、各自独立。
