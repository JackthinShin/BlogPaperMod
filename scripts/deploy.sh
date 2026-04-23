#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: ./scripts/deploy.sh [-m "commit message"] [-b branch] [-n]

Options:
  -m  Commit message. If omitted, a timestamped default message is used.
  -b  Target branch. If omitted, current branch is used.
  -n  Dry-run mode. Build and commit, but do not push.
  -h  Show this help.
EOF
}

COMMIT_MSG=""
TARGET_BRANCH=""
DRY_RUN=false

while getopts ":m:b:nh" opt; do
  case "$opt" in
    m) COMMIT_MSG="$OPTARG" ;;
    b) TARGET_BRANCH="$OPTARG" ;;
    n) DRY_RUN=true ;;
    h)
      usage
      exit 0
      ;;
    :) 
      echo "Error: option -$OPTARG requires an argument." >&2
      usage
      exit 1
      ;;
    \?)
      echo "Error: unknown option -$OPTARG" >&2
      usage
      exit 1
      ;;
  esac
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$REPO_ROOT"

if ! command -v git >/dev/null 2>&1; then
  echo "Error: git is not installed." >&2
  exit 1
fi

if ! command -v hugo >/dev/null 2>&1; then
  echo "Error: hugo is not installed." >&2
  exit 1
fi

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Error: current directory is not a git repository." >&2
  exit 1
fi

if ! git remote get-url origin >/dev/null 2>&1; then
  echo "Error: git remote 'origin' is not configured." >&2
  exit 1
fi

if [[ -z "$TARGET_BRANCH" ]]; then
  TARGET_BRANCH="$(git branch --show-current)"
fi

if [[ -z "$TARGET_BRANCH" ]]; then
  echo "Error: could not detect target branch." >&2
  exit 1
fi

if [[ -z "$COMMIT_MSG" ]]; then
  COMMIT_MSG="chore: deploy $(date +'%Y-%m-%d %H:%M:%S')"
fi

echo "[1/4] Building site with Hugo..."
hugo

echo "[2/4] Staging changes..."
git add -A

if git diff --staged --quiet; then
  echo "[3/4] No changes to commit."
else
  echo "[3/4] Creating commit..."
  git commit -m "$COMMIT_MSG"
fi

if [[ "$DRY_RUN" == true ]]; then
  echo "[4/4] Dry-run enabled. Skipping push."
  echo "Would run: git push origin $TARGET_BRANCH"
  exit 0
fi

echo "[4/4] Pushing to origin/$TARGET_BRANCH..."
git push origin "$TARGET_BRANCH"

echo "Done. Deployment pipeline completed."
