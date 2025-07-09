#!/bin/bash

set -e

GREEN="\033[0;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
CYAN="\033[0;36m"
RESET="\033[0m"

echo -e "${GREEN}♻️  SentinelMesh: Restart Script${RESET}"
echo -e "${GREEN}================================${RESET}"

CURRENT_USER=$(whoami)
DFX_DIR=".dfx"

echo -e "${CYAN}🔷 Stopping services…${RESET}"
./scripts/stop.sh || true

echo -e "${CYAN}🔷 Checking .dfx directory ownership & permission…${RESET}"
if [ -d "$DFX_DIR" ]; then
    OWNER=$(stat -c '%U' "$DFX_DIR")
    PERMS=$(stat -c '%a' "$DFX_DIR")

    if [ "$OWNER" != "$CURRENT_USER" ] || [ "$PERMS" != "700" ]; then
        echo -e "${YELLOW}⚠️  .dfx owned by $OWNER with permission $PERMS → fixing…${RESET}"
        sudo chown -R "$CURRENT_USER":"$CURRENT_USER" "$DFX_DIR"
        chmod -R 700 "$DFX_DIR"
        echo -e "${GREEN}✅ .dfx ownership & permissions fixed.${RESET}"
    else
        echo -e "${GREEN}✅ .dfx permissions OK.${RESET}"
    fi
fi

echo ""
echo -e "${CYAN}🚀 Starting ICP replica…${RESET}"
dfx start --background --clean
sleep 3

echo -e "${CYAN}🛠️  Deploying canisters…${RESET}"
dfx deploy backend
dfx deploy frontend
dfx deploy internet_identity

echo ""
echo -e "${CYAN}📝 Generating canister declarations for frontend…${RESET}"
dfx generate backend

if [ -d "src/declarations/backend" ]; then
    echo -e "${CYAN}🔷 Moving generated declarations to frontend/src…${RESET}"
    rm -rf frontend/src/declarations/backend
    mkdir -p frontend/src/declarations
    mv src/declarations/backend frontend/src/declarations/
    echo -e "${GREEN}✅ Declarations moved to: frontend/src/declarations/backend${RESET}"
else
    echo -e "${YELLOW}⚠️  No declarations found at src/declarations/backend${RESET}"
fi

FRONTEND_ID=$(dfx canister id frontend)
FRONTEND_URL="http://127.0.0.1:8000/?canisterId=$FRONTEND_ID"
II_CANISTER_ID=$(dfx canister id internet_identity)
II_URL="http://127.0.0.1:8000/?canisterId=${II_CANISTER_ID}"

echo ""
echo -e "${BLUE}🌐 Frontend (DFX asset server): ${FRONTEND_URL}${RESET}"
echo -e "${BLUE}🆔 Internet Identity: ${II_URL}${RESET}"

echo ""
echo -e "${CYAN}🔷 Updating frontend/.env…${RESET}"
ENV_FILE="frontend/.env"
touch "$ENV_FILE"

SED_OPT="-i"
if [[ "$OSTYPE" == "darwin"* ]]; then
    SED_OPT="-i ''"
fi

# Hapus baris lama
sed $SED_OPT '/^VITE_IDENTITY_PROVIDER_LOCAL=/d' "$ENV_FILE"
# Tambahkan yang baru
echo "VITE_IDENTITY_PROVIDER_LOCAL=${II_URL}" >> "$ENV_FILE"

echo -e "${GREEN}✅ frontend/.env updated with Identity Provider.${RESET}"

# 🔷 Info frontend dev URL
FE_DEV_URL="http://localhost:5173"
echo -e "${GREEN}🌐 Frontend dev server will run at: ${FE_DEV_URL}${RESET}"

# 🔷 Start frontend dev server
echo -e "${CYAN}🚀 Starting frontend dev server…${RESET}"
cd frontend
npm install
npm run dev &
cd ..

echo ""
echo -e "${CYAN}🤖 Starting AI agent…${RESET}"

if lsof -i:5001 -t >/dev/null; then
    echo -e "${YELLOW}🟥 Found existing AI process on port 5001 → killing…${RESET}"
    kill -9 $(lsof -i:5001 -t)
    sleep 1
    echo -e "${GREEN}✅ Port 5001 cleared.${RESET}"
fi

cd model
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
uvicorn app:app --reload --port 5001 &
AI_PID=$!
cd ..

echo ""
echo -e "${GREEN}✅ All services restarted!${RESET}"
echo -e "${BLUE}🔷 Frontend (DFX asset): ${FRONTEND_URL}${RESET}"
echo -e "${BLUE}🔷 Frontend (dev server): ${FE_DEV_URL}${RESET}"
echo -e "${BLUE}🔷 Identity Provider: ${II_URL}${RESET}"
echo -e "${BLUE}🔷 To stop again, run: ./scripts/stop.sh${RESET}"
echo -e "${BLUE}🧹 To stop AI manually: kill $AI_PID${RESET}"
