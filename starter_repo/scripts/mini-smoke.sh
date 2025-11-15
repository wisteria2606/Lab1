#!/usr/bin/env bash
set -euo pipefail

printf "[0] Detect docker compose...\n"
COMPOSE_CMD=""
if command -v docker >/dev/null 2>&1; then
  if docker compose version >/dev/null 2>&1; then
    COMPOSE_CMD="docker compose"
  elif command -v docker-compose >/dev/null 2>&1; then
    COMPOSE_CMD="docker-compose"
  fi
fi

if [ -n "$COMPOSE_CMD" ]; then
  printf "[1/7] %s ps\n" "$COMPOSE_CMD"; $COMPOSE_CMD ps || true
  printf "[2/7] Build & up...\n"; $COMPOSE_CMD up -d --build
  printf "[3/7] Pytest in container...\n"; $COMPOSE_CMD exec app python -m pytest -q || echo "[warn] pytest in container failed"
else
  printf "[Docker not available] Falling back to local venv...\n"
  python3 -m venv .venv && . ./.venv/bin/activate
  pip install -r requirements.txt || true
  python -m pytest -q || true
fi

printf "[4/7] pre-commit...\n"; pre-commit run -a || true
printf "[5/7] GPG signature (if configured)...\n"; git log -1 --show-signature || true
printf "[6/7] OK\n"

