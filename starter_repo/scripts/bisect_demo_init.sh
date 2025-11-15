#!/usr/bin/env bash
set -euo pipefail

# Initialize a demo git history with a good state and a buggy regression.
# After running this script inside starter_repo, you can do:
#   git bisect start
#   git bisect bad HEAD
#   git bisect good good_baseline
#   git bisect run scripts/bisect_test.sh

if [ ! -d .git ]; then
  git init -b main
  git config user.email "student@example.com" || true
  git config user.name "Student" || true
fi

# Ensure clean tree
if [ -n "$(git status --porcelain)" ]; then
  echo "[error] Working tree not clean. Commit or stash changes and retry." >&2
  exit 1
fi

# Commit GOOD baseline
cp -f app/calc.py app/calc.py
git add app/calc.py tests/test_calc.py
git commit -m "good: correct add implementation (baseline)"

git tag -f good_baseline

# Introduce BUGGY change: replace calc.py with buggy variant
cp -f app/calc_buggy.py app/calc.py

git add app/calc.py
git commit -m "bad: regression — add() subtracts"

echo "[ok] Created demo history: tag 'good_baseline' marks the good state; HEAD is bad."

