# Informativa sulla privacy — Platrare

**Data di entrata in vigore:** 4 settembre 2026

Platrare è un'applicazione di finanza personale con architettura local-first. Questa informativa descrive i dati a cui accede l'app, come vengono utilizzati e i tuoi diritti.

---

## 1. Chi siamo

Platrare è pubblicata da uno sviluppatore individuale, che è il titolare del trattamento ai sensi del GDPR. Puoi contattare lo sviluppatore all'indirizzo **[support email]**, tramite la scheda su App Store o Google Play, oppure tramite **Impostazioni → Informazioni → Contatta l’assistenza** nell'app.

---

## 2. Dati memorizzati sul tuo dispositivo

Tutti i dati creati in Platrare rimangono **esclusivamente sul tuo dispositivo**. Non gestiamo alcun server che riceva o memorizzi le tue informazioni finanziarie.

**Cosa viene memorizzato localmente:**

| Categoria | Dettagli |
|---|---|
| Registro finanziario | Conti, saldi, limiti di scoperto, storico transazioni, transazioni pianificate e categorie |
| Allegati | Foto di ricevute e documenti che scegli di aggiungere alle transazioni |
| Preferenze | Valuta principale, valuta secondaria, tema, lingua, impostazione visibilità saldo |
| Sicurezza | Stato del blocco app; hash crittografico unidirezionale del PIN (il PIN grezzo non viene mai memorizzato) |
| Cache tassi di cambio | Dati pubblici sui tassi di cambio scaricati da un'API di terze parti e memorizzati localmente |
| Promemoria | Se attivi i promemoria per le transazioni pianificate, la data di scadenza, la descrizione e l'importo di ogni transazione pianificata imminente vengono consegnati al pianificatore di notifiche locali del sistema operativo, in modo che il promemoria possa essere mostrato anche quando l'app è chiusa. Non lasciano mai il dispositivo. |
| Snapshot del widget della schermata Home (iOS) | Un piccolo riepilogo precalcolato (saldi previsti per i giorni successivi e le etichette mostrate dal widget) memorizzato nel contenitore condiviso privato dell'app, in modo che il widget possa essere visualizzato senza aprire l'app. Quando il blocco app è attivo, gli importi in questo snapshot sono mascherati, salvo diversa scelta nelle Impostazioni. |

---

## 3. Dati inviati su Internet

### 3.1 Tassi di cambio

L'app recupera periodicamente dati sui tassi di cambio dall'**API Frankfurter** (api.frankfurter.dev / api.frankfurter.app), che pubblica dati della **Banca Centrale Europea (BCE)**. Queste richieste non contengono **nessuna informazione personale** — solo una chiamata HTTP anonima standard. I tuoi conti, saldi e transazioni non vengono mai trasmessi. I dati vengono memorizzati nella cache fino a **6 ore**.

### 3.2 Nessuna analisi né pubblicità

Platrare **non contiene alcun SDK di analisi, servizio di segnalazione degli arresti anomali o rete pubblicitaria**. Non vengono raccolti dati di utilizzo, identificatori del dispositivo o telemetria comportamentale. Promemoria, widget della schermata Home e scorciatoie funzionano interamente offline.

---

## 4. Autorizzazioni del dispositivo

| Autorizzazione | Scopo | Quando richiesta |
|---|---|---|
| Fotocamera | Scattare foto di ricevute | Solo toccando "Scatta foto" |
| Libreria foto | Selezionare immagini da allegare | Solo toccando "Scegli dalla galleria" |
| File | Allegare PDF e documenti | Solo toccando "Sfoglia file" |
| Biometria / Face ID | Sbloccare l'app | Solo quando viene mostrata la schermata di blocco |
| Notifiche | Ricordarti poco prima della scadenza di una transazione pianificata | Solo quando attivi i promemoria nelle Impostazioni |
| Esecuzione all'avvio (Android) | Ripianificare i promemoria dopo il riavvio del dispositivo | Automaticamente, solo se i promemoria sono attivi |
| Rete | Recuperare tassi di cambio | Automaticamente; nessun dato personale viene inviato |

L'app non richiede accesso a posizione, contatti, microfono, calendario o qualsiasi altra autorizzazione non elencata sopra.

---

## 5. Blocco app e autenticazione biometrica

Quando attivi **Blocca app all'apertura**:

- L'app utilizza il framework biometrico sicuro del SO (iOS LocalAuthentication / Android BiometricPrompt). I tuoi dati biometrici vengono elaborati interamente nell'enclave sicura del SO — l'app non vi accede, non li memorizza né li trasmette mai.
- Se imposti un PIN, solo un **hash crittografico unidirezionale** di quel PIN viene memorizzato nel dispositivo. Il PIN grezzo non viene mai scritto su disco.

---

## 6. Backup

**L'esportazione** crea un file `.zip` (non cifrato) o `.platrare` (cifrato AES-256 con password). Scegli tu dove salvarlo. **Non riceviamo mai il tuo backup.**

**Il backup automatico giornaliero** salva un file solo nell'archiviazione privata del dispositivo. Non carica nulla automaticamente su servizi cloud. Puoi condividerlo manualmente tramite **Impostazioni → Backup automatico → Salva nel cloud**.

**L'importazione** sostituisce tutti i dati del dispositivo con il contenuto del backup. Importa solo da fonti attendibili.

Solo le esportazioni `.platrare` cifrate con password includono l'hash del PIN di blocco app; le esportazioni non cifrate e i backup automatici giornalieri non lo includono mai. Quando ripristini un backup privo di PIN, il PIN già impostato sul dispositivo viene mantenuto.

**Backup del dispositivo del sistema operativo.** La funzione di backup del tuo telefono (iCloud Backup su iOS, Google Auto Backup su Android) può copiare il registro dell'app, i backup automatici giornalieri e le preferenze nel tuo account Apple o Google come parte del backup del dispositivo, secondo i termini di Apple o Google. Su Android, gli allegati delle ricevute sono esclusi per rimanere entro il limite del backup di sistema. I backup del dispositivo si controllano nelle impostazioni del sistema operativo; lo sviluppatore non li riceve mai.

---

## 7. Widget, scorciatoie e Siri (iOS)

- **I widget della schermata Home** mostrano i saldi previsti dallo snapshot descritto nella sezione 2. Lo snapshot risiede nel contenitore condiviso privato dell'app sul tuo dispositivo e non viene mai caricato online. Quando il blocco app è attivo, gli importi sono mascherati per impostazione predefinita.
- **Azioni rapide e App Shortcuts** (pressione prolungata sull'icona dell'app, l'app Comandi o Siri) si limitano ad aprire l'app in una schermata scelta, ad esempio "Aggiungi transazione". Il riconoscimento vocale per Siri è eseguito da iOS secondo i termini sulla privacy di Apple; l'app riceve solo il comando risolto e non invia mai il tuo registro ad Apple.

---

## 8. Minori

Platrare non è destinata a bambini di età inferiore a 13 anni. Non raccogliamo consapevolmente informazioni da minori.

---

## 9. Conservazione ed eliminazione dei dati

I dati persistono sul dispositivo finché non li elimini nell'app, utilizzi **Impostazioni → Cancella dati**, importi un backup sostitutivo o disinstalli l'app. Non conservando alcuna copia dei tuoi dati sui nostri server, non abbiamo nulla da eliminare da parte nostra.

---

## 10. I tuoi diritti

- **Accesso e portabilità** — Tutti i dati sono visibili nell'app. Usa **Esporta backup** per una copia portabile.
- **Rettifica** — Modifica qualsiasi record in qualsiasi momento.
- **Cancellazione** — Usa le funzioni di eliminazione nell'app, **Cancella dati** o disinstalla.

**Utenti SEE/UK:** Il GDPR e il UK GDPR possono concedere diritti aggiuntivi, incluso il diritto di presentare reclamo all'autorità di controllo locale.

**Residenti in California:** La CCPA/CPRA potrebbe applicarsi. Non vendendo né condividendo dati personali, i diritti di opt-out non si applicano nella maggior parte dei casi.

---

## 11. Sicurezza

- Dati in un database **isolato nell'app**, inaccessibile ad altre app.
- Backup protetti con **crittografia AES-256** opzionale.
- PIN memorizzati solo come **hash crittografico unidirezionale**.
- Traffico di rete esclusivamente tramite **HTTPS**.

---

## 12. Modifiche

Potremmo aggiornare questa informativa quando le funzionalità evolvono. La **data di entrata in vigore** rifletterà l'ultima revisione. L'uso continuato costituisce accettazione delle modifiche.

---

## 13. Contatti

Per domande o richieste relative alla privacy, scrivi a **[support email]**, usa il contatto su App Store o Google Play, oppure tocca **Impostazioni → Informazioni → Contatta l’assistenza** nell'app.
