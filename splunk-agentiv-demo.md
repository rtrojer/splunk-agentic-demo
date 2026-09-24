Lade bitte deine Instruktionen aus `.hermes/system_prompt.md` und die Skills im Ordner `.hermes/skills/`.

Wir setzen jetzt ein Splunk-POC-Projekt für einen Kunden um. Gehe dabei strikt nach dem 3-Phasen-Workflow vor:

### Phase 1: Spezifikation
- Lies das Briefing in `docs/input_briefing.md`.
- Wende den Skill `.hermes/skills/01_spec_generator.md` an.
- Schreibe die vollständige Spezifikation nach `docs/architecture_spec.md`.
- Halte nach Erstellung von Phase 1 kurz an und präsentiere mir eine 3-Zeilen-Zusammenfassung der Kernparameter (Index, Ports, Auth). Warte auf mein "Go".

### Phase 2: Bereitstellung (nach Freigabe)
- Wende den Skill `.hermes/skills/02_compose_builder.md` an.
- Generiere `runtime/docker-compose.yml` unter Verwendung der Variablen aus `.env`.
- Führe `docker compose -f runtime/docker-compose.yml up -d` aus.
- Prüfe via Polling den Health-Status der Splunk REST API auf Port 8089, bis der Status "healthy" bzw. die API erreichbar ist.

### Phase 3: MCP-Validierung (nach erfolgreichem Startup)
- Wende den Skill `.hermes/skills/03_splunk_validator.md` an.
- Lade die Test-Events aus `runtime/test_data/sample_events.json` und sende sie über das MCP-Tool `splunk_send_hec` an den in Phase 1 definierten Index.
- Führe über das MCP-Tool `splunk_search` die Validierungs-SPL aus.
- Falls noch keine Events zurückkommen, beachte die Retry-Logik (5 Sekunden Delay, max. 3 Versuche).
- Gib am Ende eine Zusammenfassung der aggregierten Ergebnisse aus.

Beginne jetzt mit Phase 1.

