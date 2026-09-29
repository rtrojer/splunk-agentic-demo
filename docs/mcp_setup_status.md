# Zwischenstand: Splunk MCP Server

Stand: 2026-09-29

## Ziel

Die Splunk-MCP-Server-App installieren und konfigurieren, damit sie für die POC-Validierung verwendet werden kann.

## Bereits erledigt

- Phase 1 ist dokumentiert in `docs/architecture_spec.md`.
- Phase 2 ist in `runtime/docker-compose.yml` konfiguriert. Splunk `splunk-demo` läuft und war beim letzten Check `healthy`.
- Das Archiv `runtime/apps/splunk-mcp-server_200.tgz` wurde nach `runtime/apps/Splunk_MCP_Server` entpackt.
- Die App-Dateien wurden in das persistente App-Verzeichnis des Splunk-Containers kopiert; Splunk registriert `Splunk_MCP_Server` Version 2.0.0. Die vorhandene Laufzeitinstallation wurde per Container-Dateikopie eingerichtet, nicht per REST-Upload.
- Die App wurde neu gestartet. Ihr REST-Endpunkt unter `https://localhost:8089/servicesNS/nobody/Splunk_MCP_Server/mcp` ist registriert/erreichbar, aber der MCP-Handshake wurde noch nicht erfolgreich abgeschlossen.
- Das App-Verzeichnis `local` im Container wurde angelegt und dem Splunk-Prozess zugeordnet, damit die App ihre Laufzeitkonfiguration lesen kann.
- Unter Windows startet `runtime/start-docker-desktop.ps1` Docker Desktop bei Bedarf und wartet auf die Docker Engine. Das Skript führt Compose nicht aus; der Stack wird separat mit `docker compose --env-file .env -f runtime\docker-compose.yml up -d` gestartet.
- Python 3.14.7 ist auf Windows installiert und über `python`, `python3` sowie `py` erreichbar.
- Die Voraussetzungen für Phase 3 sind jetzt in `docs/splunk_mcp_app_setup.md` beschrieben: REST-Token-Preflight, API-Installation der App nur bei HTTP 404, Installationsprüfung und notwendiger RSA-verschlüsselter MCP-Token.
- REST-Preflight war erfolgreich: Token-Authentifizierung ist aktiviert, `SPLUNK_ACCESS_TOKEN` wird akzeptiert und `Splunk_MCP_Server` Version 2.0.0 ist installiert.
- Der Index `bank_auth` wurde erstellt.
- HEC verwendet in der laufenden Instanz TLS auf Port 8088. `SPLUNK_HEC_URL` wurde in `.env` auf `https://localhost:8088/services/collector/event` korrigiert.
- Fünf Testevents wurden erfolgreich per HEC in `bank_auth` eingespielt. Ihre Event-IDs beginnen mit `phase3_auth_20260929_101645_`.
- Die SPL-Validierung wurde erfolgreich über das MCP-Tool `search_oneshot` ausgeführt: fünf Events; `FAILED/admin=3`, `SUCCESS/jsmith=1`, `SUCCESS/ebrown=1`. Die separate Fehlversuch-Suche ergab drei fehlgeschlagene Logins für `admin`.
- Eine aggregierte Feldprüfung bestätigte für alle fünf Events `user`, `action`, `status` und `src_ip`.

## Aktuelle Blocker

1. **Token-Ausstellung scheitert:** Der App-Endpunkt `mcp_token` antwortet mit HTTP 500. Splunks Secure Storage meldet beim Schreiben des privaten MCP-RSA-Schlüssels `Could not find writer for: /nobody/Splunk_MCP_Server/passwords/credential:...`.
2. **Vorhandener Zugriffstoken ist nicht der erwartete MCP-Token:** Eine MCP-Anfrage mit `SPLUNK_ACCESS_TOKEN` wurde mit `encrypted token required` abgelehnt. Die App-Konfiguration verlangt standardmäßig RSA-verschlüsselte Tokens.
3. **MCP-Client-Konfiguration ist nicht reproduzierbar eingerichtet:** Der Quellcode des Python-STDIO-Servers konnte nur aus einer temporären Arbeitskopie nach Workarounds genutzt werden. Das konfigurierte Paket hat derzeit mehrere Kompatibilitäts-/Packagingprobleme: Der Git-Root enthält kein Python-Projekt; das Python-Projekt löst `mcp` 2.x auf, obwohl es die 1.x-API nutzt; mit `mcp<2` fehlen im installierten Paket `guardrails.py` und der `FastMCP(description=...)`-Aufruf ist inkompatibel. `mcp/mcp_config.json` muss vor einem späteren reproduzierbaren MCP-Start korrigiert werden.
4. **Kein HEC-Sende-Tool:** Die verfügbare externe MCP-Implementierung stellt `search_oneshot` u.a. bereit, aber kein HEC- oder Event-Ingest-Tool. Deshalb wurden Events per HEC-REST gesendet und die Suche per MCP durchgeführt. Der native App-MCP-Endpunkt erwartet weiterhin einen RSA-verschlüsselten MCP-Token.
5. **Windows-Python wurde inzwischen installiert:** Der Interpreter ist als Python 3.14.7 erreichbar. Im Splunk-Container ist Python 3.13 vorhanden; damit läuft die Splunk-App.

## Bisherige Diagnose / nicht erfolgreiche Anpassungen

- Die App wurde in `runtime/apps/Splunk_MCP_Server/metadata/default.meta` um eine `[passwords]`-Stanza mit Admin-Zugriff und `export = system` ergänzt. Das behebt den Secure-Storage-Fehler nicht.
- Der Container wurde nach den App- und ACL-Änderungen neu gestartet und war anschließend `healthy`.
- Ein Test des Secure-Storage-Schreibzugriffs mit einem temporären Credential scheiterte ebenfalls mit `Could not find writer`. Es wurde dadurch kein Test-Credential angelegt.
- Die 503-Antwort vor dem Anlegen des Container-Verzeichnisses `local` war auf nicht lesbare Rate-Limit-Konfiguration zurückzuführen. Das Verzeichnis ist inzwischen angelegt; danach antwortete MCP mit dem konkreten Authentifizierungsfehler für den ungeeigneten Token.
- Der unverschlüsselte Aufruf an `http://localhost:8088` erhielt eine leere Antwort; der TLS-Healthcheck `https://localhost:8088/services/collector/health/1.0` antwortete mit HEC-Status `17` („healthy“). Der HTTPS-HEC-Batch wurde mit ACK-Code `0` bestätigt.
- Der erste Start des MCP-Pakets vom Git-Root scheiterte, weil dort kein `pyproject.toml` liegt. Mit `#subdirectory=python` trat ein `mcp`-2.x/1.x-Kompatibilitätsfehler auf; nach Begrenzung auf `mcp<2` scheiterte das Paket an fehlendem `guardrails.py`. In einer temporären Quellkopie wurde zusätzlich der nicht unterstützte `FastMCP(description=...)`-Parameter entfernt; damit funktionierten MCP `initialize`, `tools/list`, `get_indexes` und `search_oneshot`. Die temporäre Kopie ist nur ein Diagnose-/Ausführungsworkaround und kein dauerhafter Client-Setup.

## Sicherheitshinweis

Der Nutzer hat klargestellt, dass `.env` hier lediglich unproblematische Beispieldaten enthält; der darin gesetzte `SPLUNK_ACCESS_TOKEN` ist für diese Demo kein vertrauliches echtes Zugangsdaten-Secret und kein Blocker. `.env` ist in Git versioniert. Bei Bedarf kann sie zur Kennzeichnung als Vorlage in `.env.example` umbenannt werden; für die Demo ist das nicht erforderlich. Tokenwerte und Passwörter werden weiterhin nicht in dieses Statusdokument kopiert.

## Nächste Schritte

1. Die bereits eingespielten Phase-3-Events bei Wiederholungen anhand des Event-ID-Präfixes ausschließen oder gezielt filtern, damit keine doppelten Demo-Events gezählt werden.
2. Eine reproduzierbare, unterstützte MCP-Client-Lösung festlegen: native App (Secure-Storage-Fehler beheben und RSA-MCP-Token ausstellen) oder den externen Python-MCP-Server in einem eigenen, getesteten Fork/Wrapper korrigieren und `mcp/mcp_config.json` entsprechend konfigurieren.
3. Für die externe MCP-Implementierung HEC-REST als Ingest-Fallback dokumentiert lassen, solange kein HEC-Sende-Tool bereitsteht.
4. Optional `.env` in `.env.example` umbenennen, falls die Datei ausdrücklich als Vorlage gekennzeichnet werden soll.
5. Unter Windows bei Bedarf `runtime/start-docker-desktop.ps1` zum Starten von Docker Desktop und Warten auf die Engine verwenden; Compose anschließend separat ausführen.
