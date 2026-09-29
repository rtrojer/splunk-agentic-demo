# Skill: Splunk Validation Loop

## Zweck
Überprüft autonom, ob Test-Events korrekt im Zielindex ankommen und abfragbar sind.

## Vorbedingungen: Splunk MCP App und Token-Authentifizierung
Vor dem Senden von Testevents zwingend `docs/splunk_mcp_app_setup.md` ausführen:
1. Token-Authentifizierung am Splunk-REST-Endpunkt prüfen und den REST-Preflight mit `SPLUNK_ACCESS_TOKEN` erfolgreich abschließen. API-Aufrufe nach dem Preflight werden mit `Authorization: Bearer <token>` ausgeführt.
2. Die Installation von `Splunk_MCP_Server` über `/services/apps/local/Splunk_MCP_Server` prüfen. Wenn die App fehlt, `runtime/apps/splunk-mcp-server_200.tgz` mit `POST /services/apps/local` als Multipart-Upload und Bearer-Token installieren und die registrierte Version `2.0.0` erneut abfragen.
3. Den MCP-Handshake am App-Endpunkt mit dem von der App erwarteten RSA-verschlüsselten MCP-Token erfolgreich verifizieren. Der Splunk-REST-Bearer-Token allein genügt für diesen Handshake nicht.
4. Bei fehlgeschlagenem Token- oder MCP-Preflight anhalten und den Fehler beheben; keine erfolgreichen API- oder MCP-Aufrufe annehmen.

## Feedback-Loop Logik
1. Verwende ein HEC-Sende-Tool des verbundenen MCP-Servers, falls es eines anbietet. Falls nicht, sende den Test-Payload per HEC REST mit `SPLUNK_HEC_TOKEN` an `SPLUNK_HEC_URL` (TLS gemäß `docs/splunk_mcp_app_setup.md`); der konfigurierte Splunk Python MCP Server stellt derzeit kein HEC-Sende-Tool bereit.
2. Führe die Validierungs-SPL über das MCP-Such-Tool des verbundenen Servers aus (beim konfigurierten Python Server: `search_oneshot`).
3. **Auswertung:**
   - Wenn `count == 0`: Warte 5 Sekunden (Splunk Indexing Pipeline Latenz) und wiederhole die Suche (maximal 3 Retries).
   - Wenn `count > 0`: Verifiziere das Vorhandensein der Pflichtfelder.
4. Gib eine Zusammenfassung im Format aus:
   `[VALIDIERT] X Events in Index <index> gefunden. Extrahierte Werte: <werte>`
