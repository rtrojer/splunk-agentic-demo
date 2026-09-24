# Skill: Specification Generator

## Zweck
Wandelt unstrukturierte Kundenprosa in eine normierte Splunk-POC-Spezifikation für die Dokumentation (Obsidian) und Weiterverarbeitung um.

## Pflichtfelder in `docs/architecture_spec.md`
Die Ausgabedatei muss folgendes Format haben:

```markdown
# Architecture Specification: [Projektname / Kunde]

## 1. Übersicht & Ziel
[Kurzbeschreibung des POC-Szenarios]

## 2. Topologie & Netzwerk
- **Splunk Rolle:** Single-Instance (Search Head + Indexer in einem)
- **Web UI:** Port 8000
- **Management / REST API:** Port 8089
- **HTTP Event Collector (HEC):** Port 8088

## 3. Data Ingestion & Storage
- **Index Name:** [z.B. security_events]
- **Source Type:** [z.B. _json]
- **HEC Token Name:** [z.B. demo_hec_token]

## 4. Validierungskriterien
- **Test-Events:** [Anzahl & Typ der Events]
- **Erwartete Felder:** [z.B. user, action, status]
- **Prüf-SPL:** [z.B. `index=security_events | stats count by status`]

