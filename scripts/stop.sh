#!/bin/bash

echo "🛑 SentinelMesh: Stop All Services"
echo "==================================="

# 🔷 stop ICP replica
echo "🟥 Stopping ICP replica…"
dfx stop || true

# 🔷 kill AI agent (on port 5001)
echo "🟥 Killing AI agent (if running)…"
AI_PID=$(lsof -ti:5001)
if [[ -n "$AI_PID" ]]; then
    kill "$AI_PID"
    echo "✅ AI agent (PID $AI_PID) stopped."
else
    echo "ℹ️ No AI agent process found on port 5001."
fi

echo "✅ All services stopped cleanly."
