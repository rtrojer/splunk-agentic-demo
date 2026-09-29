# Skill: Docker Compose Generierung

## Splunk Enterprise Best Practices
- Unter Windows vor jedem `docker compose`-Aufruf `runtime/start-splunk.ps1` verwenden. Das Skript startet bei Bedarf Docker Desktop und wartet auf eine erreichbare Docker Engine, bevor Compose ausgeführt wird. Standardmäßig startet es den Stack mit `up -d`; weitere Compose-Argumente können übergeben werden.
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
