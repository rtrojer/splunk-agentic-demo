# Skill: Splunk Validation Loop

## Zweck
Überprüft autonom, ob Test-Events korrekt im Zielindex ankommen und abfragbar sind.

## Feedback-Loop Logik
1. Sende Test-Payload via MCP Tool `splunk_send_hec`.
2. Führe MCP Tool `splunk_search` mit der Validierungs-SPL aus.
3. **Auswertung:**
   - Wenn `count == 0`: Warte 5 Sekunden (Splunk Indexing Pipeline Latenz) und wiederhole die Suche (maximal 3 Retries).
   - Wenn `count > 0`: Verifiziere das Vorhandensein der Pflichtfelder.
4. Gib eine Zusammenfassung im Format aus:
   `[VALIDIERT] X Events in Index <index> gefunden. Extrahierte Werte: <werte>`


