# Jumpcoin ElectrumX Server

ElectrumX Server für Jumpcoin (JUMP) - mit korrigierter Konfiguration.

## Was wurde korrigiert?

Die ursprüngliche Jumpcoin-Konfiguration in `electrumx/lib/coins.py` hatte folgende Fehler:

| Parameter | Original (FALSCH) | Korrigiert (RICHTIG) |
|-----------|-------------------|---------------------|
| P2SH_VERBYTES | `0x2C` (44) | `0x7A` (122) |
| RPC_PORT | `31242` (P2P Port) | `31240` (RPC Port) |
| TX_COUNT | `10,802,426` | `822,190` |
| TX_COUNT_HEIGHT | `3,431,329` | `942,293` |
| TX_PER_BLOCK | `3` | `1` |

Zusätzlich wurden **PEERS** hinzugefügt für bessere Peer-Discovery.

## Schnellstart mit Docker

### Voraussetzungen
- Docker & Docker Compose installiert
- Jumpcoin Daemon läuft (RPC Port 31240)
- SSL-Zertifikate (oder selbst-signierte erstellen)

### 1. SSL-Zertifikate erstellen (falls nicht vorhanden)

```bash
mkdir -p ssl
openssl req -newkey rsa:2048 -new -nodes -x509 -days 3650 \
  -keyout ssl/key.pem -out ssl/cert.pem -subj "/CN=localhost"
```

### 2. Docker Compose konfigurieren

Editiere `docker-compose.yml` und ersetze:
- `YOUR_RPC_USER` mit deinem Jumpcoin RPC User
- `YOUR_RPC_PASSWORD` mit deinem Jumpcoin RPC Password

### 3. Server starten

```bash
docker compose up -d
```

### 4. Logs prüfen

```bash
docker compose logs -f
```

### 5. Synchronisation abwarten

Der Server muss die gesamte Blockchain synchronisieren. Das kann 1-2 Stunden dauern.

```
INFO:Prefetcher:catching up to daemon height 942,352 (942,353 blocks behind)
INFO:BlockProcessor:our height: 370,309 daemon: 942,352
```

Wenn fertig:
```
INFO:BlockProcessor:processed 1 block size 0.00 MB in 0.0s
INFO:MemPool:1 txs 0.00 MB touching 4 addresses
```

## Manuelle Installation

### Voraussetzungen
- Python 3.8+
- LevelDB

### Installation

```bash
# LevelDB installieren (macOS)
brew install leveldb

# LevelDB installieren (Ubuntu/Debian)
sudo apt-get install libleveldb-dev

# Python Abhängigkeiten
pip install aiorpcX attrs plyvel aiohttp

# ElectrumX installieren
pip install -e .
```

### Server starten

```bash
export COIN=Jumpcoin
export NET=mainnet
export DAEMON_URL=http://YOUR_RPC_USER:YOUR_RPC_PASSWORD@127.0.0.1:31240
export DB_DIRECTORY=/path/to/data
export SERVICES=tcp://0.0.0.0:50001,ssl://0.0.0.0:50002
export SSL_CERTFILE=/path/to/ssl/cert.pem
export SSL_KEYFILE=/path/to/ssl/key.pem
export ALLOW_ROOT=true

./electrumx_server
```

## Konfiguration

| Parameter | Wert |
|-----------|------|
| Coin | JUMP |
| RPC Port | 31240 |
| TCP Port | 50001 |
| SSL Port | 50002 |
| pubType | 43 (0x2B) |
| p2shType | 122 (0x7A) |
| wifType | 171 (0xAB) |

## Testen

```bash
# TCP Verbindung testen
echo '{"jsonrpc":"2.0","method":"server.version","params":[],"id":0}' | nc localhost 50001

# SSL Verbindung testen
echo '{"jsonrpc":"2.0","method":"server.version","params":[],"id":0}' | openssl s_client -connect localhost:50002 -quiet
```

## AtomicDEX Integration

Dieser ElectrumX Server wird für die Listenung von Jumpcoin auf AtomicDEX benötigt.

**Status:** ✅ Getestet & Funktioniert

## Lizenz

Dieser Fork behält die ursprüngliche ElectrumX Lizenz bei (MIT).

## Credits

- Original ElectrumX: [spesmilo/electrumx](https://github.com/spesmilo/electrumx)
- Jumpcoin Fork: [KamaniasFaucet/jump_electrumx](https://github.com/KamaniasFaucet/jump_electrumx)
- Korrekturen: Mr. Mackey (OpenClaw AI)