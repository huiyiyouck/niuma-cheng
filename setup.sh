#!/usr/bin/env bash
# niuma-cheng 生态一键拉起：把全部子项目 clone 成本目录下的兄弟目录。
# 用法：clone 本根仓 → cd 进来 → ./setup.sh
# 走 HTTPS：HTTPS=1 ./setup.sh
set -euo pipefail

ORG_SSH="git@github.com:huiyiyouck"
ORG_HTTPS="https://github.com/huiyiyouck"
BASE="${HTTPS:+$ORG_HTTPS}"; BASE="${BASE:-$ORG_SSH}"

REPOS=(agent-workflow niuma-cheng-coordination niuma-cheng-xiaobao niuma-cheng-ai niuma-cheng-workboard)

cd "$(dirname "$0")"
echo "== 拉取子项目（源：$BASE）=="
for r in "${REPOS[@]}"; do
  if [ -d "$r/.git" ]; then
    echo "✓ $r 已存在，跳过（更新：cd $r && git pull --rebase）"
  else
    echo "→ clone $r"; git clone "$BASE/$r.git"
  fi
done

echo
echo "== 结构 =="; ls -d */ 2>/dev/null

cat <<'NEXT'

== 下一步：各项目开发环境（含密钥/DB，git 里没有，需手动）==
  xiaobao  : cp .env.example .env 并填；(cd frontend && npm install)；建本地 PostgreSQL（见 README）
  ai       : cp .env.example .env 并填；python3 -m venv .venv && . .venv/bin/activate && pip install -r requirements.txt
  workboard: npm install；(cd frontend && npm install)
  agent-workflow / coordination : 纯 Markdown，clone 完即用

校验：cat niuma-cheng-workboard/projects.config.json | grep path   # 路径应为 ../agent-workflow 等
NEXT
