[![Inline docs](http://inch-ci.org/github/remote-exec/command-designer.png)](http://inch-ci.org/github/isprambiente/medplan)
[![Yard Docs](http://img.shields.io/badge/yard-docs-blue.svg)](http://rubydoc.info/github/isprambiente/medplan/master)
[![Maintainability](https://api.codeclimate.com/v1/badges/606f40e65760b34fbf84/maintainability)](https://codeclimate.com/github/isprambiente/medplan/maintainability)

# Gestione segreteria medica(Med.Plan.)

Il programma, interamente sviluppato all'interno del settore Sviluppo di AGP-INF, nasce da una specifica necessità di [I.S.P.R.A.](http://www.isprambiente.gov.it) nel gestire la sorveglianza sanitaria e la medicina sul lavoro del personale.

Il programma è stato appositamente sviluppato su piattaforma web per consentire l'accesso alle risorse interne tramite l'utilizzo di un comune browser web.

All'interno dell'applicazione è possibile gestire le attività di segreteria dedica programmando, per ciascun dipendente, le analisi cliniche e le visite presso il medico competente. E' possibile gestire i rischi lavorativi connessi alle attività lavorative dell'Istituto raggruppandoli in categorie di rischio collegandoli a ciascun dipendente. Per ogni categoria di rischio è possibile indicare il numero di mesi di sorveglianza sanitaria. Allo scadere dei mesi indicati, il sistema visualizza l'elenco dei dipendenti "scaduti". E' possibile scegliere tra:

* Dipendenti nuovi: elenco di personale che a cui non è associta nessuna categori di rischio;
* Dipendenti scaduti: elenco di personale che è scaduto prima del mese corrente;
* Dipendenti in scadenza nel mese corrente: elenco di personale che ha almeno una categoria di rischio in scadenza nel mese corrente;
*  Dipendenti in scadenza nel primo mese successivo: elenco di personale che ha almeno una categoria di rischio in scadenza nel mese successivo al mese corrente;
*  Dipendenti in scadenza nel secondo mese successivo: elenco di personale che ha almeno una categoria di rischio in scadenza nel secondo mese successivo al mese corrente;
*  Dipendenti cancellati: elenco di personale che è stato cancellato manualmente dal sistema;
*  Dipendenti bloccati e/o cessati: elenco di personale che è stato bloccato automaticamente dal sistema in caso, ad esempio, di scadenza contratto;

Nello specifico il sistema, rilasciato in riuso, permette:

* Una autenticazione SingleSignOn su sistema CAS Server;
* Acquisizione automatica dei dipendenti da repository REST-API Json;
* Creazione e gestione manuale dei dipendenti;
* Gestione dei rischi sul lavoro;
* Raggruppamento in categorie dei rischi sul lavoro;
* Profilazione dei dipendenti in base alle categorie di rischio collegate;
* Calendarizzazione delle analisi e delle visite;
* Comunicazioni tramite e-mail con i dipendenti;
* Gestione dello storico delle idoneità per ciascun dipendente;
* Gestione delle scadenze delle idoneità per ciascuna categoria di rischio;
* Generazione di reportistica riservata al medico competente;
* Manuali d'utilizzo per i tre profili utente: dipendente generico, segreteria e medico competente.

## Licenza
Il codice sorgente del sito progetto è rilasciato sotto licenza MIT License (codice SPDX: MIT). La licenza è visibile nel file [LICENSE](https://opensource.org/licenses/MIT)

## Repository
Questo repository contiene il codice sorgente del programma per la gestione della sorveglianza sanitaria e della medicina sul lavoro del personale.

Il sito è sviluppato in linguaggio Ruby 3.4, framework Rails 8.0.

### Specifiche tecniche progetto
* [Ruby 3.4.x](https://www.ruby-lang.org)
* [RVM](https://rvm.io/)
* [Ruby on Rails 8.0](https://rubyonrails.org/)
* [NodeJS](https://nodejs.org/)
* [Bun](https://bun.sh/)
* [Hotwire](https://hotwired.dev/)
* [Postgresql](https://www.postgresql.org/)
* HTML5 + CSS3
* no jQuery
* [Server CAS](https://rubycas.github.io/) - autenticazione SingleSignOn
* [Openssl](https://www.openssl.org/) -

\* In alternativa al server CAS e` necessario sviluppare altri sistemi di autenticazione come ldap

### Requisiti tecnici per ambiente server
* Sistema operativo: Linux
* Gestore pacchetto ruby: RVM
* Linguaggio di programmazione: Ruby 3.4
* Framework: Rails 8
* Database: PostgreSQL >= 17
* NodeJS: JavaScript runtime >= v13.10
* Package Manager: Bun >= 1.2
* Deploy applicazione: Accesso ssh per deploy applicazione via Capistrano
* Webserver: Nginx + Puma
* Autenticazione utenti: CAS Server

### Requisiti minimi per i client
* Mozilla Firefox 110, Chrome 110, Microsoft Edge, Safari o altro browser compatibile con HTML 5, CSS 3;
* Internet Explorer 11 non è supportato;
* Javascript abilitato;
* Cookie abilitati;
* Supporto ai certificati SSL;
* Risoluzione schermo 1024x768.

### Configurazione consigliata per i client
* Mozilla Firefox 110, Chrome 110, Microsoft Edge, Safari o altro browser compatibile con HTML 5, CSS 3;
* Javascript abilitato;
* Cookie abilitati;
* Supporto ai certificati SSL;
* Risoluzione schermo >= 1280x1024.

## Installazione ambiente
Installare l'ambiente di sviluppo e di produzione come indicato [qui](https://gorails.com/setup).

## Installazione applicazione

### In sviluppo

1. Clonare il progetto in sviluppo

    ```
      git clone https://github.com/isprambiente/medplan.git
    ```

2. Da una shell posizionarsi sulla root del progetto ed eseguire

    ```
      gem install bundle
      bundle install
      bun install
    ```

3. Generare la propria master.key
    ```
      rails secret
    ```
4. Editare il file delle credenziali
    ```
      rails credentials:edit
    ```
5. Inserire il testo indicato di seguito aggiornandolo con i propri parametri:

    ```
      secret_key_base:

      cas:
        base_url: 'https://server.domain.com/cas/'

      development:
        database: nomeistanza_development
        username: username
        password: password
        host: hostname
      test:
        database: nomeistanza_test
        username: username
        password: password
        host: hostname

      production:
        database: nomeistanza_production
        username: username
        password: password
        host: hostname

      \# Indicare le credenziali per collegarsi al servizio REST-API in formato JSON da cui scaricare le informazioni degli utenti.
      api:
        url: 'https://api.domain.com/medplan.json'
        user: 'username'
        secret_access_key: 'password'

      \# Indicare una password se si vuole bloccre la modifica dei file excel
      excel:
        password: nil

      \# Modificare le impostazioni per l'invio delle email con le proprie
      mail:
        address: 'smtp.domain.com'
        port: 465
        domain: 'domain.com'
        ssl: true
        user_name: '<username>'
        password: '<password>'
        sender: 'sender@domain.com'
    ```
6. Modificare il file `config/deploy`

    ```
    lock '3.11.2' # indicare la versione corretta del capistrano
    set :deploy_to, "/home/medplan" # indicare il path in cui installare l'applicazione in produzione
    set :tmp_dir, '/home/medplan/shared/tmp' # indicare il path della tempdir dell'applicazione in produzione
    ```

7. Modificare il file `config/deploy/production.rb`

    ```
    role :app, %w{medplan@medplan.domain.com}
    role :web, %w{medplan@medplan.domain.com}
    role :db,  %w{medplan@medplan.domain.com}

    server 'medplan.domain.com', user: 'medplan', roles: %w{app db web}, my_property: :my_value
    set :branch, 'master'
    set :rails_env, 'production'
    set :ssh_options, {:forward_agent => true}
    ```
8. Creare il file `config/settings.local.yml` partendo da `config/settings.yml` per sovrascrivere i parametri di default. Il file è incluso nel `.gitignore` pertanto sarà necessario ricopiarlo manualmente sul server nel path `shared/config/settings.local.yml`
9. Copiare i seguenti file sul server in produzione nella cartella `shared/config/`
    * settings.local.yml
    * database.yml
    * master.key
    * secrets.yml
10. Per il deploy in produzione utilizzare Capistrano
    ```
    cap production deploy
    ```
    Verificare e risolvere eventuali errori che si potrebbero verificare durante il deploy.
### In produzione
1. Posizionarsi nella root dell'applicazione ed eseguire:
    ```
    gem install bundle
    gem install bundler
    gem install puma
    puma -C /path/to/config
    ```
2. Per nginx, creare un file nella cartella `/etc/nginx/config/medplan.conf` e incollare quanto segue modificando, prima di salvare, con i propri parametri:
    ```
    upstream medplan {
      server unix:///<root_path>/shared/tmp/sockets/puma.sock;
    }

    server {
      server_name medplan.domain.com;
      listen 443 ssl;
      listen [::]:443 ssl;
      ssl_certificate      /etc/nginx/cert/medplanarm.crt;
      ssl_certificate_key  /etc/nginx/cert/medplan.key;
      ssl_protocols TLSv1.2 TLSv1.3;
      ssl_ciphers ALL:!aNULL:!ADH:!eNULL:!LOW:!EXP:RC4+RSA:+HIGH:+MEDIUM;

      access_log /var/log/nginx/medplan.access.log;
      error_log /var/log/nginx/medplan.error.log;

      root /<root_path>/current/public;

      client_max_body_size 20M;

      location / {
        proxy_pass http://medplan; # match the name of upstream directive which is defined above
        proxy_redirect off;

        proxy_set_header   Host              $host;
        proxy_set_header   X-Real-IP         $remote_addr;
        proxy_set_header   X-Forwarded-For   $proxy_add_x_forwarded_for;
        proxy_set_header   X-Forwarded-Proto $scheme;
      }

      location ~ ^/(system|assets)/ {
        root /<root_path>/current/public;
        gzip_static on; # to serve pre-gzipped version
        expires max;
        add_header Cache-Control public;
      }

      location /docs/ {
        root /<root_path>/current/doc/site;
        rewrite ^/docs/(.*)$ /$1 break;
        gzip_static on; # to serve pre-gzipped version
        expires max;
        add_header Cache-Control public;
        index  index.html;
      }
    }
    ```
3. Riavviare Nginx

Verificare e risolvere eventuali errori al riavvio di nginx.

### Demo con docker / docker compose
1. Clonare il progetto in sviluppo

    ```
      git clone https://github.com/isprambiente/medplan.git
    ```

2. Configurare il DNS o modificare il proprio file hosts per risolvere il nome cas-mock-server sull'indirizzo del server docker.

   Nel seguente esempio il docker viene eseguito localmente e viene modificato il file `/etc/hosts` del computer locale.

   ```
    127.0.0.1       localhost cas-mock-server
   ```
   la modifica è necessaria per raggiungere con un nome condiviso il server CAS

3. Eseguire la build del docker tramite compose

   ```
   sudo docker-compose up --build -d
   ```

4. Per accedere utilizzare le seguenti credenziali:
  * mario.rossi     - password   # per utente standard
  * editor          - password   # per utente editor
  * dottore         - password   # per utente dottore
  * admin           - password   # per utente admin

### Partecipa!
Puoi collaborare allo sviluppo dell'applicazione e della documentazione tramite [github](https://github.com/isprambiente/medplan).

Tramite [Github discussions](https://github.com/isprambiente/medplan/discussions) è possibile richiedere e offrire aiuto.

Se riscontrate errori e bug potete segnalarli nella paggina delle [Issues](https://github.com/isprambiente/medplan/issues)
