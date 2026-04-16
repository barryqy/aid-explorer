#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

pkill -f 'aid_explorer_target.py' >/dev/null 2>&1 || true
nohup python3 "${repo_dir}/aid_explorer_target.py" >"${repo_dir}/target.log" 2>&1 &
sleep 2
curl -sS http://127.0.0.1:8080/healthz
