#!/bin/bash
# .claude/fetch-rules.sh

AGENT_REPO="https://github.com/mattgi/example-skillz.git"
TMPDIR=$(mktemp -d)

# Shallow clone just the .claude folder
git clone --depth 1 --filter=blob:none --sparse "$AGENT_REPO" "$TMPDIR/agent"
cd "$TMPDIR/agent"
git sparse-checkout set .claude

# Merge into product repo's .claude, never overwriting existing files
rsync -a --ignore-existing "$TMPDIR/agent/.claude/" "$CLAUDE_PROJECT_DIR/.claude/"

# Cleanup
rm -rf "$TMPDIR"

# Echo any rules to stdout for guaranteed context injection
for f in $(find "$CLAUDE_PROJECT_DIR/.claude/rules" -name "*.md" 2>/dev/null); do
  cat "$f"
done

exit 0