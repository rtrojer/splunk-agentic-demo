# Splunk Agentic AI Demo

Dieses Repository demonstriert die Leistungsfähigkeit einer Agentic AI (Hermes) bei der automatischen Bereitstellung, Konfiguration und Validierung einer Splunk-Umgebung für einen Proof of Concept (POC).

Anstatt manuell Docker Compose-Dateien zu schreiben, Splunk über die UI/CLI zu konfigurieren und Testdaten zu generieren, nutzt dieses Projekt Hermes, um eine unstrukturierte Geschäftsanforderung (wie z. B. Kunden-Meeting-Notizen) zu interpretieren und die technische Lösung vollautomatisch aufzubauen.

## Zielsetzung
Das Projekt zeigt, wie ein KI-Agent:
1. **Unstrukturierte Anforderungen versteht:** Eine `input_briefing.md` (Notizen aus einem Call mit einem CISO-Team) wird als Ausgangspunkt genommen.
2. **Architektur plant:** Eine entsprechende System-Architektur (Docker Compose) wird entworfen.
3. **Provisioning durchführt:** Eine lokale Splunk-Umgebung wird hochgefahren.
4. **Konfiguriert & Daten einspeist:** HTTP Event Collector (HEC) und Indizes (`bank_auth`) werden konfiguriert und JSON-Testdaten (Authentifizierungs-Logs) werden simuliert und indexiert.
5. **Validiert:** Die KI prüft selbstständig, ob die Logs ankommen und für die Visualisierung von Fehlversuchen bereitstehen.

## Projektstruktur

- `.hermes/` - Enthält die spezifischen Skills (`01_spec_generator`, `02_compose_builder`, `03_splunk_validator`), die den Agenten durch den Workflow führen.
- `docs/` - Enthält das Ausgangs-Briefing (`input_briefing.md`) und die vom Agenten generierte Architekturspezifikation.
- `runtime/` - Beinhaltet das `docker-compose.yml` und die generierten Testdaten (`sample_events.json`).
- `mcp/` - Konfiguration für das Model Context Protocol (Splunk MCP).
- `docs/splunk_mcp_app_setup.md` - REST-API- und Token-Auth-Vorbereitung für die Splunk-MCP-App.

## Ablauf der Demo
Um die Demo unter Windows zu starten, im Projektverzeichnis Folgendes ausführen. Docker Desktop kann bereits laufen; falls nicht, startet das Skript ihn automatisch:

```powershell
.\runtime\start-splunk.ps1
```

Das Skript prüft zuerst die Docker Engine. Ist sie nicht verfügbar, startet es Docker Desktop und wartet bis zu fünf Minuten auf die Engine. Erst danach wird `docker compose up -d` mit `runtime/docker-compose.yml` und der Projektdatei `.env` ausgeführt. Für andere Compose-Aktionen können Argumente übergeben werden, zum Beispiel `.\runtime\start-splunk.ps1 ps`.

Anschließend kann Hermes das Verzeichnis übernehmen und die Umgebung basierend auf den Meeting-Notizen (`docs/input_briefing.md`) konfigurieren, Testdaten einspielen und die Logs in Splunk validieren.
