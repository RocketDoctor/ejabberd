#!/usr/bin/env bash
set -euo pipefail

echo "🔧 Preparing environment for Ejabberd + Node stack..."

# -------------------------
# 1️⃣ Load environment
# -------------------------
if [ -f .env ]; then
  echo "📦 Loading environment from .env..."
  set -a
  source .env
  set +a
fi


