# Architecture Specification: Bankhaus Demo POC

## 1. Übersicht & Ziel
Bereitstellung einer Single-Instance Splunk Demo-Umgebung zur Validierung des JSON-basierten Ingests von Authentifizierungsereignissen via HEC.

## 2. Topologie & Netzwerk
- **Splunk Rolle:** Single-Instance (Search Head & Indexer)
- **Web UI:** http://localhost:8000
- **Management Port:** https://localhost:8089
- **HEC Port:** http://localhost:8088

## 3. Data Ingestion & Storage
- **Index Name:** `bank_auth`
- **Source Type:** `_json`
- **HEC Token:** Ausgelagert in `.env` (`SPLUNK_HEC_TOKEN`)

## 4. Validierungskriterien
- **Test-Events:** 5 strukturierte JSON-Events (Auth Logs).
- **Erwartete Felder:** `user`, `action`, `status`, `ip`.
- **Prüf-SPL:** `index=bank_auth | stats count by status, user`

