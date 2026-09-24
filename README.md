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

## Ablauf der Demo
Um die Demo auszuführen, übergibt man Hermes einfach das Verzeichnis und bittet die KI, die Umgebung basierend auf den Meeting-Notizen (`docs/input_briefing.md`) hochzuziehen. Die Agentic AI übernimmt den Rest – vom Schreiben/Ausführen der Konfigurationsdateien bis zum Ingest und der Validierung der Logs in Splunk.
