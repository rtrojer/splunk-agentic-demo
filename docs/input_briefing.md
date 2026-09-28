# Kunden-Meeting Notizen: Splunk Demo POC

Wir hatten heute den Call mit dem CISO-Team. Sie wollen sehen, wie Splunk mit Authentifizierungs-Logs umgeht.

Anforderungen für die Demo:
- Wir brauchen eine lauffähige lokale Splunk-Umgebung für den Termin morgen.
- Logs sollen als JSON über HTTP Event Collector reinkommen.
- Der Index soll `bank_auth` heißen.
- Wir müssen nachweisen, dass fehlgeschlagene Anmeldeversuche (Login-Failures) sauber visualisiert werden können.
- Bitte ein paar simulierte Events einspielen mit Usernamen wie `admin`, `jsmith` und Statuscodes `SUCCESS` bzw. `FAILED`.

