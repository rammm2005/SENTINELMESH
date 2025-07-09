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