# Skill: Docker Compose Generierung

## Splunk Enterprise Best Practices
- Unter Windows bei Bedarf zuerst `runtime/start-docker-desktop.ps1` ausführen. Das Skript startet Docker Desktop und wartet auf eine erreichbare Docker Engine; es führt selbst keine Docker-Compose-Befehle aus. Den Compose-Stack anschließend separat starten, zum Beispiel mit `docker compose --env-file .env -f runtime\docker-compose.yml up -d`.
- Image: `splunk/splunk:latest`
- Environment:
  - `SPLUNK_START_ARGS=--accept-license`
  - `SPLUNK_PASSWORD=${SPLUNK_PASSWORD}`
- Ports zu mappen:
  - `8000:8000` (Web UI)
  - `8089:8089` (Management / REST API)
  - `8088:8088` (HTTP Event Collector)
- Healthcheck konfigurieren via:
  `curl -k -u admin:${SPLUNK_PASSWORD} https://localhost:8089/services/server/info`
