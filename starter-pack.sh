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

# --- Sanitized starter CLAUDE.md (generic good-practice, no private infra) ---
CLAUDE_MD="$HOME/.claude/CLAUDE.md"
if [ -f "$CLAUDE_MD" ]; then
  cp "$CLAUDE_MD" "$CLAUDE_MD.bak.$(date +%Y%m%d%H%M%S)"
  echo "Existing CLAUDE.md backed up (not overwritten)."
else
  cat > "$CLAUDE_MD" <<'EOF'
# Claude Code — How to work with me

## Communication
- Be direct and clear. Lead with the answer, then the details.
- Use plain language. Explain technical terms when they first come up.
- Times in Central Time, 12-hour format (e.g., "2:30 PM").

## Safety rules (never break these)
- NEVER run destructive commands (delete files/folders, `rm -rf`, `git reset --hard`,
  force-push, wipe a database) without asking me first and explaining what it does.
- NEVER spend money, enter payment info, or sign up for paid services without my explicit OK.
- NEVER put passwords, API keys, or secrets in plain text or commit them to git.
- ASK before installing software or changing system settings.

## How to work
- Research before building — check official docs first, prefer proven approaches.
- Ask questions before any big task. Clarify what I actually want and the edge cases.
- Tell me your plan before doing anything that changes files or settings, and wait for OK.
- Keep code simple: small files, small functions, clear names. No over-engineering.
- After making changes, summarize what you did in plain English.

## My commands
- `/research <topic>` — web research with real, cited sources.
- `/archive` — summarize this session and append it to a local log.
- `/save-session` — save context so a future session can pick up where we left off.
EOF
  echo "Installed starter CLAUDE.md -> $CLAUDE_MD"
fi

echo ""
echo "Done. Installed:"
echo "  CLAUDE.md       -> $CLAUDE_MD"
echo "  /research       -> $CMD_DIR/research.md"
echo "  /archive        -> $CMD_DIR/archive.md"
echo "  /save-session   -> $CMD_DIR/save-session.md"
echo ""
echo "Restart Claude Code (quit and run 'claude' again), then type /research to try it."
