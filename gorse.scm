(use-modules (gnu)
             (guix modules))
(use-service-modules networking
                     ssh
                     web
                     admin
                     games
                     certbot
                     databases
                     virtualization
                     desktop
                     mcron
                     docker
                     mail
                     cuirass
                     base
                     networking
                     avahi)
(use-package-modules admin
                     certs
                     package-management
                     databases
                     ssh
                     tls
                     emacs
                     xdisorg
                     games
                     sqlite
                     version-control)
(load "system-packages.scm")
(define %nginx-deploy-hook
  (program-file
   "nginx-deploy-hook"
   #~(let ((pid (call-with-input-file "/var/run/nginx/pid" read)))
       (kill pid SIGHUP))))
(define %gmnisrv-ini
  (plain-file "gmnisrv.ini"
              "# Space-separated list of hosts
listen=0.0.0.0:1965 [::]:1965

[:tls]
# Path to store certificates on disk
store=/var/lib/gemini/certs

# Optional details for new certificates
organization=gmnisrv user

[example.org]
root=/srv/gemini/example.org

[example.com]
root=/srv/gemini/example.com"))
(define %my-radicale-config-file
  (plain-file "radicale.conf" "
[auth]
type = htpasswd
htpasswd_filename = /var/lib/radicale/htpasswd
htpasswd_encryption = bcrypt

[server]
hosts = 0.0.0.0:5232, [::]:5232
ssl = True
certificate = /etc/letsencrypt/live/cdr255.com/cert.pem
key = /etc/letsencrypt/live/cdr255.com/privkey.pem

[storage]
filesystem_folder = /var/lib/radicale/collections"))
(define updatedb-job
  ;; Run 'updatedb' at 3AM every day.  Here we write the
  ;; job's action as a Scheme procedure.
  #~(job '(next-hour '(3))
         (lambda ()
           (execl (string-append #$findutils "/bin/updatedb")
                  "updatedb"
                  "--prunepaths=/tmp /var/tmp /gnu/store"))))
(define radicale-bkup-job
  #~(job '(next-hour '(4))
         (lambda ()
           (execl (string-append #$tar "/bin/tar")
                  "-cvvjf"
                  "/tmp/radicale$(date --iso-8601).tar.bzip2"
                  "/var/lib/radicale/collections"))))
(define %local-php-ini
  (plain-file "php.ini"
              "memory_limit = 2G
max_execution_time = 1800
upload_max_filesize = 50M
post_max_size = 200M"))

(operating-system
  (host-name "gorse")
  (timezone "America/New_York")
  (locale "en_US.UTF-8")
  ;; This goofy code will generate the grub.cfg
  ;; without installing the grub bootloader on disk.
  (bootloader (bootloader-configuration
               (bootloader
                (bootloader
                 (inherit grub-bootloader)
                 (installer #~(const #t))))))
  (file-systems (cons* (file-system
                        (device "/dev/sda")
                        (mount-point "/")
                        (type "ext4"))
                       (file-system
                        (device "/dev/sdc")
                        (mount-point "/var/capsule/")
                        (type "ext4"))
                       %base-file-systems))
  (swap-devices (list
                 (swap-space
                  (target "/dev/sdb"))))
  (initrd-modules (cons "virtio_scsi"    ;needed to find the disk
                        %base-initrd-modules))

  (users (cons* (user-account
                (name "ming")
                (group "users")
                (supplementary-groups '("wheel"
                                        "docker"))
                (home-directory "/home/ming"))
               (user-account
                (name "git")
                (group "git")
                (home-directory "/home/git")
                (comment "For Use With Git")
                (system? #t))
               ;; (user-account
               ;;  (name "radicale")
               ;;  (group "radicale")
               ;;  (home-directory "/home/radicale")
               ;;  (comment "For Use With Radicale")
               ;;  (system? #t))
               %base-user-accounts))
  (groups (cons* (user-group
                  (name "git")
                  (system? #t))
                      %base-groups))
  (packages (append (map (compose list specification->package+output)
                         my-system-packages) %base-packages))
  (services (cons*
             (service avahi-service-type)
             (service unattended-upgrade-service-type)
             (service dhcp-client-service-type)
             (service dovecot-service-type)
             (service opensmtpd-service-type (opensmtpd-configuration))
             (service openssh-service-type
                      (openssh-configuration
                       (openssh openssh-sans-x)

                       (password-authentication? #f)
                       (port-number 9418)
                       (authorized-keys
                        `(("ming"
                           ,(local-file "public-keys/ssh-jory.pub")
                           ,(local-file "public-keys/ssh-crane.pub")
                           ,(local-file "public-keys/ssh-radicale.pub")
                           ,(local-file "public-keys/ssh-trisana.pub")
                           ,(local-file "public-keys/ssh-lark.pub")
                           ,(local-file "public-keys/ssh-frostpine.pub")
                           ,(local-file "public-keys/ssh-evvy.pub"))
                          ("git"
                           ,(local-file "public-keys/ssh-jory.pub")
                           ,(local-file "public-keys/ssh-crane.pub")
                           ,(local-file "public-keys/ssh-radicale.pub")
                           ,(local-file "public-keys/ssh-trisana.pub")
                           ,(local-file "public-keys/ssh-lark.pub")
                           ,(local-file "public-keys/ssh-frostpine.pub")
                           ,(local-file "public-keys/ssh-evvy.pub"))))))
             (service docker-service-type)
             (service php-fpm-service-type
                      (php-fpm-configuration
                       (php-ini-file %local-php-ini)
                       (socket-user "nginx")))
             (service nginx-service-type
                      (nginx-configuration
                       (server-blocks
                        (list (nginx-server-configuration
                               (listen '("80"))
                               (locations `(,(nginx-location-configuration
                                              (uri "/")
                                              (body
                                               (list "return 301 https://$host$request_uri;"))))))
                              (nginx-server-configuration
                               (listen '("443 ssl"))
                               (server-name '("arm.gdn"))
                               (root "/srv/http/arm.gdn/")
                               (index '("index.php"))
                               (locations
                                (list
                                 (nginx-php-location)))
                               (ssl-certificate-key "/etc/letsencrypt/live/arm.gdn/privkey.pem")
                               (ssl-certificate "/etc/letsencrypt/live/arm.gdn/fullchain.pem"))
                              (nginx-server-configuration
                               (listen '("443 ssl"))
                               (server-name '("links.cdr.gdn"))
                               (ssl-certificate-key "/etc/letsencrypt/live/cdr.gdn/privkey.pem")
                               (ssl-certificate "/etc/letsencrypt/live/cdr.gdn/fullchain.pem")
                               (locations
                                (list
                                 (nginx-php-location)
                                 (nginx-location-configuration
                                  (uri "/")
                                  (body '("proxy_pass http://localhost:8880;"
                                        "proxy_set_header Host $host;"
                                        "proxy_set_header X-Real-IP $remote_addr;"
                                        "proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;"))))))
                              (nginx-server-configuration
                               (listen '("443 ssl"))
                               (server-name '("wb.cdr.gdn"))
                               (ssl-certificate-key "/etc/letsencrypt/live/cdr.gdn/privkey.pem")
                               (ssl-certificate "/etc/letsencrypt/live/cdr.gdn/fullchain.pem")
                               (locations
                                (list
                                 (nginx-php-location)
                                 (nginx-location-configuration
                                  (uri "/")
                                  (body '("proxy_pass http://localhost:7878;"
                                        "proxy_set_header Host $host;"
                                        "proxy_set_header X-Real-IP $remote_addr;"
                                        "proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;"))))))
                              (nginx-server-configuration
                               (listen '("443 ssl"))
                               (server-name '("uml.yew.gdn"))
                               (ssl-certificate-key "/etc/letsencrypt/live/yew.gdn/privkey.pem")
                               (ssl-certificate "/etc/letsencrypt/live/yew.gdn/fullchain.pem")
                               (locations
                                (list
                                 (nginx-php-location)
                                 (nginx-location-configuration
                                  (uri "/")
                                  (body '("proxy_pass https://localhost:8443;"
                                        "proxy_set_header Host $host;"
                                        "proxy_set_header X-Real-IP $remote_addr;"
                                        "proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;"))))))
                              (nginx-server-configuration
                               (listen '("443 ssl"))
                               (server-name '("wb.cdr.gdn"))
                               (ssl-certificate-key "/etc/letsencrypt/live/cdr.gdn/privkey.pem")
                               (ssl-certificate "/etc/letsencrypt/live/cdr.gdn/fullchain.pem")
                               (locations
                                (list
                                 (nginx-php-location)
                                 (nginx-location-configuration
                                  (uri "/")
                                  (body '("proxy_pass http://localhost:8881;"
                                        "proxy_set_header Host $host;"
                                        "proxy_set_header X-Real-IP $remote_addr;"
                                        "proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;"))))))
                              (nginx-server-configuration
                               (listen '("443 ssl"))
                               (server-name '("bugs.cdr.gdn"))
                               (ssl-certificate-key "/etc/letsencrypt/live/cdr.gdn/privkey.pem")
                               (ssl-certificate "/etc/letsencrypt/live/cdr.gdn/fullchain.pem")
                               (locations
                                (list
                                 (nginx-php-location)
                                 (nginx-location-configuration
                                  (uri "/")
                                  (body '("proxy_pass http://localhost:8555;"
                                        "proxy_set_header Host $host;"
                                        "proxy_set_header X-Real-IP $remote_addr;"
                                        "proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;"))))))
                              (nginx-server-configuration
                               (listen '("443 ssl"))
                               (server-name '("write.cdr.gdn"))
                               (ssl-certificate-key "/etc/letsencrypt/live/cdr.gdn/privkey.pem")
                               (ssl-certificate "/etc/letsencrypt/live/cdr.gdn/fullchain.pem")
                               (locations
                                (list
                                 (nginx-php-location)
                                 (nginx-location-configuration
                                  (uri "/")
                                  (body '("proxy_pass http://localhost:9889;"
                                        "proxy_set_header Host $host;"
                                        "proxy_set_header X-Real-IP $remote_addr;"
                                        "proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;"))))))
                              (nginx-server-configuration
                               (listen '("443 ssl"))
                               (server-name '("cdr.gdn"))
                               (root "/srv/http/cdr.gdn/")
                               (index '("index.php"))
                               (locations
                                (list
                                 (nginx-php-location)))
                               (ssl-certificate-key "/etc/letsencrypt/live/cdr.gdn/privkey.pem")
                               (ssl-certificate "/etc/letsencrypt/live/cdr.gdn/fullchain.pem"))
                              (nginx-server-configuration
                               (listen '("443 ssl"))
                               (server-name '("cdr.quest"))
                               (root "/srv/http/cdr.quest/")
                               (ssl-certificate-key "/etc/letsencrypt/live/cdr.quest/privkey.pem")
                               (ssl-certificate "/etc/letsencrypt/live/cdr.quest/fullchain.pem"))
                              (nginx-server-configuration
                               (listen '("443 ssl"))
                               (server-name '("cdr255.com"))
                               (root "/srv/http/www/")
                               (ssl-certificate-key "/etc/letsencrypt/live/cdr255.com/privkey.pem")
                               (ssl-certificate "/etc/letsencrypt/live/cdr255.com/fullchain.pem"))
                              (nginx-server-configuration
                               (listen '("443 ssl"))
                               (server-name '("danusclearing.com"))
                               (root "/srv/http/danusclearing.com/")
                               (ssl-certificate-key "/etc/letsencrypt/live/danusclearing.com/privkey.pem")
                               (ssl-certificate "/etc/letsencrypt/live/danusclearing.com/fullchain.pem"))
                              (nginx-server-configuration
                               (listen '("443 ssl"))
                               (server-name '("yew.gdn"))
                               (root "/srv/http/yew.gdn/")
                               (ssl-certificate-key "/etc/letsencrypt/live/yew.gdn/privkey.pem")
                               (ssl-certificate "/etc/letsencrypt/live/yew.gdn/fullchain.pem"))
                              (nginx-server-configuration
                               (listen '("443 ssl"))
                               (server-name '("1464.link"))
                               (root "/srv/http/1464.link/")
                               (locations
                                (list
                                 (nginx-php-location)
                                 (nginx-location-configuration
                                  (uri "/")
                                  (body '("if (!-e $request_filename) {"
                                    "    rewrite ^(.*)$ /index.php?q=$1;"
                                    "}")))
                                 (nginx-location-configuration
                                  (uri "^~ /.well-known/")
                                  (body '("allow all;"
                                    "if (!-e $request_filename) {"
                                    "    rewrite ^(.*)$ /index.php?q=$1;"
                                    "}")))
                                 (nginx-location-configuration
                                  (uri "~* \\.(tpl|md|tgz|log|out)$")
                                  (body '("deny all;")))
                                 (nginx-location-configuration
                                  (uri "~ /\\.")
                                  (body '("deny all;")))
                                 (nginx-location-configuration
                                  (uri "~ /store")
                                  (body '("deny all;")))
                                 (nginx-location-configuration
                                  (uri "~ /util")
                                  (body '("deny all;")))))
                               (index '("index.php"))
                               (ssl-certificate-key "/etc/letsencrypt/live/1464.link/privkey.pem")
                               (ssl-certificate "/etc/letsencrypt/live/1464.link/fullchain.pem")
                               (raw-content '("client_max_body_size 25m;"
                                              "client_body_buffer_size 128k;"
                                              "charset utf-8;"
                                              "ssl_session_timeout 5m;")))
                              (nginx-server-configuration
                               (listen '("443 ssl"))
                               (server-name '("yewscion.com"))
                               (root "/srv/http/yewscion/")
                               (ssl-certificate-key "/etc/letsencrypt/live/yewscion.com/privkey.pem")
                               (ssl-certificate "/etc/letsencrypt/live/yewscion.com/fullchain.pem"))))))
             (service agate-service-type
                      (agate-configuration
                       (key "/etc/agate/key.rsa")
                       (cert "/etc/agate/cert.pem")
                       (lang "en-US")
                       (hostname "cdr255.com")))
             (service wesnothd-service-type)
             (service certbot-service-type
                      (certbot-configuration
                       (email "cdr255@gmail.com")
                       (webroot "/srv/http/www/")
                       (certificates
                        (list
                         (certificate-configuration
                          (domains '("cdr255.com" "www.cdr255.com"))
                          (deploy-hook %nginx-deploy-hook))
                         (certificate-configuration
                          (domains '("yewscion.com" "www.yewscion.com"))
                          (deploy-hook %nginx-deploy-hook))
                         (certificate-configuration
                          (domains '("cdr.gdn" "www.cdr.gdn" "links.cdr.gdn" "wb.cdr.gdn" "bugs.cdr.gdn" "write.cdr.gdn"))
                          (deploy-hook %nginx-deploy-hook))
                         (certificate-configuration
                          (domains '("yew.gdn" "www.yew.gdn" "dia.yew.gdn" "uml.yew.gdn"))
                          (deploy-hook %nginx-deploy-hook))
                         (certificate-configuration
                          (domains '("arm.gdn" "www.arm.gdn"))
                          (deploy-hook %nginx-deploy-hook))
                         (certificate-configuration
                          (domains '("danusclearing.com" "www.danusclearing.com"))
                          (deploy-hook %nginx-deploy-hook))
                         (certificate-configuration
                          (domains '("cdr.quest" "www.cdr.quest"))
                          (deploy-hook %nginx-deploy-hook))
                         (certificate-configuration
                          (domains '("1464.link" "www.1464.link"))
                          (deploy-hook %nginx-deploy-hook))))))
             (service qemu-binfmt-service-type
                      (qemu-binfmt-configuration
                       (platforms (lookup-qemu-platforms "arm" "aarch64" "risc-v"))))
             (service postgresql-service-type
                      (postgresql-configuration
                       (config-file
                        (postgresql-config-file
                         (log-destination "stderr")
                         (hba-file
                          (plain-file "pg_hba.conf"
                                      "
# TYPE  DATABASE    USER        CIDR-ADDRESS          METHOD

# \"local\" is for Unix domain socket connections only
local   all         pgadmin                           trust
local   all         all                               trust

# IPv4 local connections:
host    all         all         127.0.0.1/32          md5

# IPv6 local connections:
host    all         all         ::1/128               md5

# IPv4 remote connections:
host    all             all              0.0.0.0/0                       md5

host    all             all              ::/0                            md5
"))
                         (extra-config
                          '(("listen_addresses" "0.0.0.0,::")))))
                       (postgresql postgresql-15)
                       (port 54321)
                       (data-directory "/var/lib/postgresql/db")
                       (log-directory "/var/log/postgresql/db")))
             (service mysql-service-type
                      (mysql-configuration
                       (mysql mysql)
                       (bind-address "0.0.0.0")
                       (port 3306)
                       (socket "/run/mysqld/mysqld.sock")
                       (extra-content "")
                       (extra-environment #~'())
                       (auto-upgrade? #t)))
             (service elogind-service-type)
             (extra-special-file "/var/lib/radicale/htpasswd"
                                 (local-file "dotfiles/radicale-htpasswd"))
             (service radicale-service-type
                      (radicale-configuration
                       (config-file %my-radicale-config-file)))
             (simple-service 'my-cron-jobs
                             mcron-service-type
                             (list updatedb-job
                                   radicale-bkup-job))
             %base-services)))
