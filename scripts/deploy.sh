#!/bin/bash

set -e

GREEN="\033[0;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
CYAN="\033[0;36m"
RESET="\033[0m"

echo -e "${GREEN}🟢 SentinelMesh: Development Environment Starter${RESET}"
echo -e "${GREEN}===============================================${RESET}"

CURRENT_USER=$(whoami)
DFX_DIR=".dfx"

# 🔷 step 0: fix .dfx permission if needed
if [ -d "$DFX_DIR" ]; then
    echo -e "${CYAN}🔷 Checking .dfx directory ownership & permission…${RESET}"
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
else
    echo -e "${BLUE}ℹ️ No .dfx directory yet — clean start.${RESET}"
fi

# 🔷 clean port 8000 if busy
if lsof -i :8000 >/dev/null 2>&1; then
    echo -e "${YELLOW}⚠️  Port 8000 is already in use — killing process…${RESET}"
    kill -9 $(lsof -t -i :8000)
    sleep 1
    echo -e "${GREEN}✅ Port 8000 cleared.${RESET}"
fi

# 🔷 start ICP replica
echo -e "${CYAN}🚀 Starting ICP replica…${RESET}"
dfx stop || true
rm -rf .dfx
dfx start --background --clean
sleep 3

# 🔷 deploy backend
echo -e "${CYAN}🛠️ Deploying backend canister…${RESET}"
dfx deploy backend

# 🔷 generate declarations
echo -e "${CYAN}📝 Generating canister declarations for frontend…${RESET}"
dfx generate backend

if [ -d "src/declarations/backend" ]; then
    echo -e "${CYAN}🔷 Moving generated declarations to frontend/src…${RESET}"
    rm -rf frontend/src/declarations/backend
    mkdir -p frontend/src/declarations
    mv src/declarations/backend frontend/src/declarations/
    echo -e "${GREEN}✅ Declarations moved to: frontend/src/declarations/backend${RESET}"
fi

# 🔷 deploy internet_identity
echo -e "${CYAN}🆔 Deploying Internet Identity…${RESET}"
dfx deploy internet_identity

II_CANISTER_ID=$(dfx canister id internet_identity)
II_URL="http://127.0.0.1:8000/?canisterId=${II_CANISTER_ID}"

echo -e "${GREEN}✅ Internet Identity deployed at: ${II_URL}${RESET}"

# 🔷 update frontend/.env
echo -e "${CYAN}🔷 Updating frontend/.env…${RESET}"
ENV_FILE="frontend/.env"
touch "$ENV_FILE"

SED_OPT="-i"
[[ "$OSTYPE" == "darwin"* ]] && SED_OPT="-i ''"

sed $SED_OPT '/^VITE_IDENTITY_PROVIDER_LOCAL=/d' "$ENV_FILE"
echo "VITE_IDENTITY_PROVIDER_LOCAL=${II_URL}" >> "$ENV_FILE"

echo -e "${GREEN}✅ frontend/.env updated.${RESET}"

# 🔷 frontend dev server URL
FE_DEV_URL="http://localhost:5173"
echo -e "${GREEN}🌐 Frontend dev server will run at: ${FE_DEV_URL}${RESET}"

# 🔷 start frontend dev server
echo -e "${CYAN}🚀 Starting frontend dev server…${RESET}"
cd frontend
npm install
npm run dev &
cd ..

# 🔷 start AI agent
echo -e "${CYAN}🤖 Starting AI agent…${RESET}"
if lsof -i:5001 -t >/dev/null; then
    echo -e "${YELLOW}⚠️  AI agent port 5001 is already in use — killing…${RESET}"
    kill -9 $(lsof -t -i :5001)
    sleep 1
fi

cd model
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
uvicorn app:app --reload --port 5001 &
AI_PID=$!
cd ..

# 🔷 open browser to frontend dev
echo -e "${CYAN}🌐 Opening browser…${RESET}"
xdg-open "$FE_DEV_URL" >/dev/null 2>&1 || open "$FE_DEV_URL" || echo -e "${YELLOW}🔷 Open manually: $FE_DEV_URL${RESET}"

echo ""
echo -e "${GREEN}✅ All services running!${RESET}"
echo -e "${BLUE}🔷 Frontend: ${FE_DEV_URL}${RESET}"
echo -e "${BLUE}🔷 Identity Provider: ${II_URL}${RESET}"
echo -e "${BLUE}🧹 To stop AI agent: kill $AI_PID${RESET}"
