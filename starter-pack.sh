#!/usr/bin/env bash
# OpenClaw starter skill pack — basics only.
# Installs 3 user slash commands into ~/.claude/commands/ :
#   /research       multi-source web research with cited sources
#   /archive        summarize the session, append to a local log (no VPS, no masterlog)
#   /save-session   save resumable session context to ~/.claude/sessions/
# Safe: only writes under ~/.claude/. No deletes, no network calls.

set -euo pipefail

CMD_DIR="$HOME/.claude/commands"
mkdir -p "$CMD_DIR"
mkdir -p "$HOME/.claude/sessions"

echo "Installing starter commands into $CMD_DIR ..."

cat > "$CMD_DIR/research.md" <<'EOF'
---
description: Multi-source web research with cited sources
---
Research this topic: $ARGUMENTS

Steps:
1. Use web search to find 4-6 credible, recent sources.
2. Pull the key facts; note which source each important claim came from.
3. Answer in this shape:
   - **Answer first** — the direct bottom line in 1-2 sentences.
   - **Key findings** — bullets, each with its source in parentheses.
   - **Sources** — list of titles + URLs you actually used.
4. Flag anything where sources disagree or confidence is low. Do not invent sources.
EOF

cat > "$CMD_DIR/archive.md" <<'EOF'
---
description: Summarize this session and append it to a local archive log
---
Summarize what we accomplished in this session, then save it to a local log.

1. Write 3-6 bullets: what changed, which files were touched, key decisions made.
2. Append it to ~/.claude/archive-log.md under a header with today's date and a short title.
   Create the file if it does not exist. Never overwrite or delete prior entries — append only.
3. Confirm the path you wrote to. Keep it concise — this is a personal log, not a report.
EOF

cat > "$CMD_DIR/save-session.md" <<'EOF'
---
description: Save resumable session context so a fresh session can pick up where this left off
---
Write a self-contained session summary to ~/.claude/sessions/session-<today's date>.md.

Include:
- What we were working on (goal).
- Current state — what's done, what's in progress.
- Next steps — the concrete next actions.
- Key file paths and any commands that matter.
- Open questions or decisions still pending.

Make it detailed enough that a brand-new session reading only this file could continue with no other context. Confirm the file path when done.
EOF

echo ""
echo "Done. Installed 3 commands:"
echo "  /research       -> $CMD_DIR/research.md"
echo "  /archive        -> $CMD_DIR/archive.md"
echo "  /save-session   -> $CMD_DIR/save-session.md"
echo ""
echo "Restart Claude Code (quit and run 'claude' again), then type /research to try it."
