# SentinelMesh

♻️ **SentinelMesh** adalah platform *development & testing environment* berbasis [Internet Computer Protocol (ICP)](https://internetcomputer.org/) yang menggabungkan:  
- Canisters (`backend`, `frontend`, `internet_identity`) untuk menjalankan aplikasi decentralized.  
- AI Agent berbasis Python FastAPI untuk layanan kecerdasan buatan.

---

## 📖 Table of Contents
- [Fitur](#fitur)
- [Persyaratan](#persyaratan)
- [Instalasi](#instalasi)
- [Menjalankan](#menjalankan)
- [Struktur Folder](#struktur-folder)
- [Lingkungan Development](#lingkungan-development)
- [Tips & Notes](#tips--notes)
- [Lisensi](#lisensi)

---

## ✨ Fitur
✅ Backend canister (Motoko/Did).  
✅ Frontend React + Vite.  
✅ Integrasi Internet Identity untuk autentikasi berbasis ICP.  
✅ AI Agent berbasis Python + Uvicorn (`model/`).  
✅ Skrip otomatis (`./scripts/restart.sh` & `./scripts/dev.sh`) untuk:
- deploy ulang backend, frontend, internet_identity
- memperbaiki permission `.dfx`
- memperbarui `.env`
- membangun & menjalankan semua service

---

## 🧰 Persyaratan
- [Node.js](https://nodejs.org/) >= 18
- [DFX SDK](https://internetcomputer.org/docs/current/developer-docs/quickstart/hello10mins) >= 0.17.0
- Python >= 3.9
- `virtualenv` Python
- Linux/MacOS recommended (Windows WSL bisa)

---

## ⚙️ Instalasi
```bash
git clone https://github.com/namamu/sentinelmesh.git
cd sentinelmesh
```

## 📝 Scripts

| Kebutuhan                                  | Script                |
| ------------------------------------------ | --------------------- |
| Pertama kali setup full dev env (BE+FE+AI) | `./scripts/dev.sh`    |
| Cuma deploy ulang BE & FE                  | `./scripts/deploy.sh` |
| Stop semua service                         | `./scripts/stop.sh`   |

### Run Scripts
buat executable
```bash
chmod +x scripts/dev.sh
```

jalanin
```bash
./scripts/dev.sh
```

### Stop Scripts
buat executable
```bash
chmod +x scripts/stop.sh
```

jalanin
```bash
./scripts/stop.sh
```

### Deploy & Linked Canister ID Scripts
buat executable akses
```bash
chmod +x scripts/deploy.sh
```

jalanin
```bash
./scripts/deploy.sh
```


### Restart Dev

```bash
chmod +x scripts/restart.sh
./scripts/restart.sh
```


### Get Internet Identity Desentralized Auth

```bash
git clone https://github.com/dfinity/internet-identity.git
cd internet-identity
npm install
npm run build
```