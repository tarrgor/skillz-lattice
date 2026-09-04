#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
test_root="$(mktemp -d)"
trap 'rm -rf "$test_root"' EXIT

legacy_output="$(HOME="$test_root/legacy" "$repo_dir/install.sh" --dry-run)"
[[ "$legacy_output" == *".claude/skills"* ]]
[[ "$legacy_output" == *".agents/skills"* ]]
[[ "$legacy_output" == *".claude/agents"* ]]

codex_output="$(HOME="$test_root/codex" "$repo_dir/install-codex.sh" --dry-run)"
[[ "$codex_output" == *".agents/skills"* ]]
[[ "$codex_output" == *".codex/agents"* ]]

case "$(uname -s)" in
  MINGW*|MSYS*|CYGWIN*)
    echo "POSIX dry-run contracts passed; symlink behavior is tested on Linux CI."
    exit 0
    ;;
esac

HOME="$test_root/codex" "$repo_dir/install-codex.sh" >/dev/null
[[ -L "$test_root/codex/.agents/skills/kick-off" ]]
[[ -L "$test_root/codex/.codex/agents/verify-implementation.toml" ]]

HOME="$test_root/codex" "$repo_dir/install-codex.sh" --uninstall >/dev/null
[[ ! -e "$test_root/codex/.agents/skills/kick-off" ]]
[[ ! -e "$test_root/codex/.codex/agents/verify-implementation.toml" ]]

echo "POSIX installer tests passed."
