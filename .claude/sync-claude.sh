#!/bin/bash
# .claude/sync-claude.sh

AGENT_REPO="https://github.com/your-org/agent-repo.git"
AGENT_REPO="https://github.com/mattgi/example-skillz.git"

TMPDIR=$(mktemp -d)

# Shallow clone just the .claude folder
git clone --depth 1 --filter=blob:none --sparse "$AGENT_REPO" "$TMPDIR/agent"
cd "$TMPDIR/agent"
git sparse-checkout set .claude

# Copy files that don't already exist, creating subdirs as needed
cd "$TMPDIR/agent/.claude"
find . -type f | while read -r file; do
  dest="$CLAUDE_PROJECT_DIR/.claude/$file"
  if [ ! -f "$dest" ]; then
    mkdir -p "$(dirname "$dest")"
    cp "$file" "$dest"
  fi
done

# Cleanup
rm -rf "$TMPDIR"

exit 0
