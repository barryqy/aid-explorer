#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

request_body='{"model":"gpt-5-nano","messages":[{"role":"user","content":"{{prompt}}"}]}'
response_path='choices[0].message.content'

if [ -t 1 ] && [ "${NO_COLOR:-}" = "" ]; then
  c_ok=$'\033[1;32m'
  c_info=$'\033[1;36m'
  c_label=$'\033[1;34m'
  c_dim=$'\033[0;37m'
  c_reset=$'\033[0m'
else
  c_ok=''
  c_info=''
  c_label=''
  c_dim=''
  c_reset=''
fi

say_ok() {
  printf '%s%s%s\n' "${c_ok}" "$1" "${c_reset}"
}

say_info() {
  printf '%s%s%s\n' "${c_info}" "$1" "${c_reset}"
}

say_label() {
  printf '%s%s%s %s\n' "${c_label}" "$1" "${c_reset}" "${2:-}"
}

target_url() {
  if [ -n "${DEVENV_APP_8080_URL:-}" ]; then
    printf '%s/v1/chat/completions' "${DEVENV_APP_8080_URL%/}"
  else
    printf 'Public target URL unavailable in this shell'
  fi
}

check_local_health() {
  curl -fsS http://127.0.0.1:8080/healthz >/dev/null
}

check_public_health() {
  if [ -n "${DEVENV_APP_8080_URL:-}" ]; then
    curl -fsS "${DEVENV_APP_8080_URL%/}/healthz" >/dev/null
  else
    check_local_health
  fi
}

print_details() {
  printf '\n'
  say_info 'Explorer Target Details'
  say_label 'URL:' "$(target_url)"
  say_label 'Auth:' 'None'
  say_label 'Request:' "${request_body}"
  say_label 'Response path:' "${response_path}"
  printf '%sUse the default request and response mapping in Explorer.%s\n' "${c_dim}" "${c_reset}"
  printf '\n'
}

show_health() {
  check_public_health
  printf '\n'
  say_ok '[OK] Target is healthy.'
  printf '\n'
}

start_target() {
  pkill -f 'aid_explorer_target.py' >/dev/null 2>&1 || true
  nohup python3 "${repo_dir}/aid_explorer_target.py" >"${repo_dir}/target.log" 2>&1 &
  sleep 2
  check_local_health
  printf '\n'
  say_ok '[OK] Target started on port 8080.'
  print_details
}

case "${1:-start}" in
  start)
    start_target
    ;;
  --details|details)
    print_details
    ;;
  --health|health)
    show_health
    ;;
  *)
    printf 'Usage: %s [--details|--health]\n' "$0" >&2
    exit 1
    ;;
esac
