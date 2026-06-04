# Med.Plan — Gestione segreteria medica
![Licenza MIT](https://img.shields.io/badge/license-MIT-green)

Applicazione web per la gestione della sorveglianza sanitaria e della medicina sul lavoro del personale, sviluppata per I.S.P.R.A. e rilasciata in riuso.

Funzionalità principali

- Gestione anagrafica dipendenti (import REST-API JSON o inserimento manuale)
- Categorizzazione rischi e profilazione dipendenti
- Calendarizzazione visite e analisi cliniche
- Gestione storico delle idoneità e scadenze
- Comunicazioni via e-mail
- Reportistica per medico competente
- Autenticazione Single Sign-On (supporto OIDC)

## Stato attuale del progetto
Questo repository contiene il codice sorgente dell'applicazione. Lo stack attuale (da verificare a seconda del ramo/commit) è basato su:

- Ruby: 4.0.x (compatibile con Ruby 4.0.3+)
- Rails: 8.1
- Database: PostgreSQL >= 17
- JavaScript runtime: Node.js (compatibile con v16+), Bun >= 1.3 usato come package manager
- Hotwire/Turbo/Stimulus per UX

Se il tuo ambiente locale usa versioni diverse, usa `rbenv`/`rvm`/`asdf` per allineare Ruby/Rails.

## Requisiti

### Requisiti minimi (sviluppo)

- OS: Linux/macOS/Windows WSL2
- CPU: 2 vCPU
- RAM: 4 GB
- Ruby 4.0.x
- Rails 8.1
- PostgreSQL 15+ (per sviluppo è possibile usare 12/13, ma in produzione si raccomanda >=17)
- Node.js v16+ o Bun >=1.3

### Configurazione consigliata (produzione)

- OS: Linux (preferibilmente Ubuntu/RHEL/CentOS)
- CPU: 2-4 vCPU
- RAM: 8 GB
- PostgreSQL >= 17
- Nginx + Puma
- Certificati TLS per HTTPS
- Storage: filesystem condiviso per `public/system` se usi più istanze

## Installazione (standalone, sviluppo)

1. Clona il repository

```bash
git clone https://github.com/isprambiente/medplan.git
cd medplan
```

2. Imposta Ruby (es. rbenv/asdf/rvm) e installa dipendenze

```bash
# esempio con rbenv
rvm install ruby-4.0.3
rvm use 4.0.3
gem install bundler
bundle install
```

3. Installa dipendenze JS con Bun o npm/yarn

```bash
bun install
# oppure
npm install
```

4. Configura variabili d'ambiente e credenziali

- Copia `.env_sample` in `.env` e aggiorna i valori locali
- Genera `master.key` / credenziali Rails se necessario

```bash
rails credentials:edit
# oppure per generare una master.key
rails secret > config/master.key
```

5. Crea il database e carica i seed

```bash
rails db:create db:migrate db:seed
```

6. Avvia l'app in sviluppo

```bash
bin/rails server
```

Nota: per lo sviluppo su Windows è consigliabile usare WSL2.

## Installazione con Docker / Docker Compose

1. Costruisci e avvia i container

```bash
docker-compose up --build -d
```

2. Se necessario, esegui le migration e i seed dentro il container

```bash
docker-compose exec web rails db:create db:migrate db:seed
```

Credenziali demo (se incluse nell'immagine):
- `mario.rossi` / `password` (utente standard)
- `editor` / `password` (editor)
- `dottore` / `password` (medico)
- `admin` / `password` (amministratore)

## Autenticazione OIDC

L'app supporta l'autenticazione Single Sign-On via OIDC. Per abilitare OIDC in produzione/configurazione:

- Aggiungere i parametri OIDC nelle credenziali (es. `config/credentials.yml.enc`) o in `config/settings.local.yml`:

```yaml
oidc:
  issuer: 'https://openid.example.com'
  client_id: 'your_client_id'
  client_secret: 'your_client_secret'
  redirect_uri: 'https://yourapp.example.com/auth/oidc/callback'
```

- Verificare di avere nel Gemfile gem per OpenID Connect / OmniAuth se non già presente (es. `omniauth-openid-connect`).
- Configurare il provider OIDC nell'inizializzatore (es. `config/initializers/omniauth.rb`).

Se in passato era usato CAS, il progetto mantiene parti di codice per CAS: preferibile migrare a OIDC in ambienti moderni.

## Deploy

Per deploy in produzione si raccomanda Capistrano (esistente in repository):

- Aggiornare `config/deploy.rb` e `config/deploy/production.rb` con i percorsi e gli utenti corretti
- Assicurarsi che i file sensibili (`database.yml`, `master.key`, `settings.local.yml`) siano presenti in `shared/config/` sul server

Esempio rapido:

```bash
cap production deploy
```

## Configurazioni importanti

- `config/settings.yml` può essere sovrascritto da `config/settings.local.yml` (non tracciato).
- Tenere sempre aggiornato `master.key` e proteggere le credenziali
- Usare HTTPS in produzione e disabilitare l'accesso diretto a `/public` se non necessario

## Suggerimenti

- Usare `asdf` o `rbenv` per gestire facilmente le versioni Ruby locali
- Automatizzare backup e rotazione dei log
- Monitorare le migration e mantenere allineato l'ambiente PostgreSQL con la produzione

## Contribuire

Contribuzioni, segnalazioni e discussioni su GitHub:

- Repository: https://github.com/isprambiente/medplan
- Discussions: https://github.com/isprambiente/medplan/discussions
- Issues: https://github.com/isprambiente/medplan/issues

## Licenza
Il codice sorgente è rilasciato sotto licenza MIT (vedere file LICENSE).
