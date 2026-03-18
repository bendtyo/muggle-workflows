#!/usr/bin/env bash
# Muggle Workflows Installer
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/bendtyo/muggle-workflows/main/install.sh | bash
#   or: ./install.sh (from repo root)
#   or: ./install.sh --claude-only | --cursor-only

set -euo pipefail

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

REPO_URL="https://github.com/bendtyo/muggle-workflows"
TEMP_DIR=""

# --- Helpers ---

info()  { echo -e "${BLUE}[info]${NC} $1"; }
ok()    { echo -e "${GREEN}[done]${NC} $1"; }
warn()  { echo -e "${YELLOW}[warn]${NC} $1"; }

cleanup() { [[ -n "$TEMP_DIR" ]] && rm -rf "$TEMP_DIR"; }
trap cleanup EXIT

# --- Detect source (local clone vs remote) ---

if [[ -f "claude-code/commands/workflow.md" ]]; then
  SRC="."
  info "Installing from local clone"
else
  TEMP_DIR=$(mktemp -d)
  info "Downloading from $REPO_URL..."
  git clone --depth 1 --quiet "$REPO_URL" "$TEMP_DIR"
  SRC="$TEMP_DIR"
  ok "Downloaded"
fi

# --- Parse args ---

INSTALL_CLAUDE=true
INSTALL_CURSOR=true

for arg in "$@"; do
  case "$arg" in
    --claude-only) INSTALL_CURSOR=false ;;
    --cursor-only) INSTALL_CLAUDE=false ;;
    --help|-h)
      echo "Usage: install.sh [--claude-only | --cursor-only]"
      echo "  Installs Muggle Workflows into the current directory."
      echo "  Default: installs both Claude Code and Cursor files."
      exit 0
      ;;
  esac
done

# --- Install ---

if $INSTALL_CLAUDE; then
  info "Installing Claude Code agents and commands..."
  mkdir -p .claude/agents .claude/commands
  cp "$SRC"/claude-code/agents/*.md .claude/agents/
  cp "$SRC"/claude-code/commands/*.md .claude/commands/
  ok "Claude Code: .claude/agents/ + .claude/commands/"
fi

if $INSTALL_CURSOR; then
  info "Installing Cursor rule files..."
  cp "$SRC"/cursor/*.mdc ./
  ok "Cursor: *.mdc files in project root"
fi

info "Installing sync script..."
mkdir -p scripts
cp "$SRC"/scripts/sync-agents.sh scripts/
chmod +x scripts/sync-agents.sh
ok "Sync script: scripts/sync-agents.sh"

# --- Verify ---

echo ""
echo -e "${GREEN}Muggle Workflows installed.${NC}"
echo ""

if $INSTALL_CLAUDE; then
  echo "  Claude Code:  type /workflow to start"
fi
if $INSTALL_CURSOR; then
  echo "  Cursor:       reference @agent-workflow.mdc in your prompt"
fi

echo ""
echo "  Sync check:   ./scripts/sync-agents.sh"
echo "  Customize:    edit agent files to match your project structure"
echo ""
