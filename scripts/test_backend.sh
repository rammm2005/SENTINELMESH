#!/bin/bash

set -e

echo "🔷 SentinelMesh Backend Test Script"
echo "==================================="

CANISTER_ID=$(dfx canister id backend)

echo "✅ Backend canister ID: $CANISTER_ID"
echo ""

echo "📄 Checking 'hello' endpoint…"
dfx canister call $CANISTER_ID hello

echo ""
echo "📝 Registering node…"
dfx canister call $CANISTER_ID registerNode '(record { id = "node-1"; ip = "192.168.1.10" })'

echo ""
echo "📄 Listing nodes…"
dfx canister call $CANISTER_ID listNodes

echo ""
echo "🔄 Updating node status…"
dfx canister call $CANISTER_ID updateNodeStatus '(record { id = "node-1"; status = "offline" })'

echo ""
echo "📄 Listing nodes after update…"
dfx canister call $CANISTER_ID listNodes

echo ""
echo "🗑️ Deregistering node…"
dfx canister call $CANISTER_ID deregisterNode '(record { id = "node-1" })'

echo ""
echo "📄 Listing nodes after removal…"
dfx canister call $CANISTER_ID listNodes

echo ""
echo "✅ All tests done!"
