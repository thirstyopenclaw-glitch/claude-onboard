#!/usr/bin/env bash
# OpenClaw onboarding — BOOTSTRAP (run this once on the NEW Mac).
# Double-click this file. It does ONLY the two things that open the door for
# remote setup, then hands off to Joel:
#   1. Installs Joel's SSH key so he can connect (no password needed).
#   2. Turns on Remote Login (SSH).
# Everything else (Homebrew, Ghostty, Claude Code, skills) Joel does remotely.
#
# Tailscale is handled by you, by hand (install from the App Store, sign in,
# then Share this Mac to thirstyopenclaw@gmail.com) — see the printed steps.

set -uo pipefail

CONTROLLER_KEY='ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIR53ZRuoueZsXilUGBVVv0It+fS+9+vqkWs4FzT9ssu joelpanchevre@Joels-Mac-mini.local'

bold() { printf "\033[1m%s\033[0m\n" "$1"; }
ok()   { printf "\033[32m✓ %s\033[0m\n" "$1"; }
warn() { printf "\033[33m! %s\033[0m\n" "$1"; }

clear
bold "OpenClaw — Claude Code onboarding bootstrap"
echo "This opens remote access so the rest can be done for you."
echo

# --- 1. Install controller SSH key ---
bold "Step 1/2 — installing remote access key"
mkdir -p "$HOME/.ssh" && chmod 700 "$HOME/.ssh"
AUTH="$HOME/.ssh/authorized_keys"
touch "$AUTH" && chmod 600 "$AUTH"
if grep -qF "$CONTROLLER_KEY" "$AUTH" 2>/dev/null; then
  ok "Key already present."
else
  echo "$CONTROLLER_KEY" >> "$AUTH"
  ok "Key installed."
fi
echo

# --- 2. Enable Remote Login (SSH) ---
bold "Step 2/2 — turning on Remote Login (you'll be asked for your Mac password)"
if sudo systemsetup -setremotelogin on >/dev/null 2>&1 && \
   sudo systemsetup -getremotelogin 2>/dev/null | grep -qi "on"; then
  ok "Remote Login is ON."
else
  warn "Couldn't enable it from here (macOS blocks the shortcut on a fresh Mac)."
  echo "  Turn it on by hand — it's one toggle:"
  echo "    System Settings -> General -> Sharing -> Remote Login = ON"
  echo "  Opening that panel for you now..."
  open "x-apple.systempreferences:com.apple.Sharing-Settings.extension" 2>/dev/null || \
  open "x-apple.systempreferences:com.apple.preferences.sharing" 2>/dev/null || true
fi
echo

# --- Whoami / hand-off info ---
WHO="$(whoami)"
HOSTSHORT="$(scutil --get LocalHostName 2>/dev/null || hostname -s)"
bold "Almost done — finish these by hand, then text Joel:"
echo "  A. Install Tailscale (App Store), open it, SIGN IN."
echo "  B. In the Tailscale admin (login.tailscale.com) Share this Mac"
echo "     to:  thirstyopenclaw@gmail.com"
echo "  C. Text Joel this line so he can connect:"
echo
bold "     ssh ${WHO}@<your-tailscale-ip>   (host: ${HOSTSHORT})"
echo
ok "Bootstrap complete. Joel takes it from here remotely."
echo
echo "(You can close this window.)"
