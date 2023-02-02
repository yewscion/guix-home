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
(define %cuirass-specs
  #~(list (specification
           (name "yewscion-channel")
           (build '(channels yewscion))
           (systems  '("x86_64-linux" "aarch64-linux"))
           (priority 1)
           (channels
            (cons (channel
                   (name 'yewscion)
                   (url "https://git.sr.ht/~yewscion/yewscion-guix-channel")
                   (branch "trunk"))
                  %default-channels)))
          (specification
           (name "ming")
           (build '(packages "adb" "adlmidi" "alsa-plugins" "ardour"
        "autoconf" "automake" "b3sum" "bash" "beets" "biber" "borg" "brasero"
        "bsd-games" "btrfs-progs" "cabal-install" "chez-scheme"
        "clisp" "clojure" "cmake" "coq" "coreutils" "dfc"
        "docker" "dosfstools" "doxygen" "efibootmgr" "elixir" "elm-compiler"
        "emacs-next" "emacs-alert" "emacs-anaphora" "emacs-async" "emacs-avy"
        "emacs-biblio" "emacs-bongo" "emacs-bui" "emacs-caml" "emacs-cider"
        "emacs-circe" "emacs-citar" "emacs-citeproc-el" "emacs-clojure-mode"
        "emacs-cmake-mode" "emacs-company" "emacs-company-emoji"
        "emacs-company-jedi" "emacs-company-lsp" "emacs-company-lua"
        "emacs-company-math" "emacs-company-org-block"
        "emacs-company-quickhelp" "emacs-company-restclient" "emacs-constants"
        "emacs-consult" "emacs-csv" "emacs-csv-mode" "emacs-d-mode"
        "emacs-daemons" "emacs-dash" "emacs-datetime" "emacs-debbugs"
        "emacs-deft" "emacs-dictionary" "emacs-diff-hl" "emacs-disable-mouse"
        "emacs-dmenu" "emacs-docker" "emacs-docker-compose-mode"
        "emacs-docker-tramp" "emacs-dockerfile-mode" "emacs-download-region"
        "emacs-easy-kill" "emacs-ebib" "emacs-ediprolog" "emacs-edit-indirect"
        "emacs-edn" "emacs-eldoc" "emacs-elf-mode" "emacs-elfeed"
        "emacs-elfeed-protocol" "emacs-elisp-docstring-mode" "emacs-elisp-refs"
        "emacs-elisp-slime-nav" "emacs-elixir-mode" "emacs-elm-mode"
        "emacs-elpher" "emacs-elpy" "emacs-emacsql" "emacs-emacsql-sqlite3"
        "emacs-embark" "emacs-emms" "emacs-emms-mode-line-cycle"
        "emacs-emojify" "emacs-engine-mode" "emacs-epl" "emacs-eprime"
        "emacs-erc-hl-nicks" "emacs-erlang" "emacs-eshell-did-you-mean"
        "emacs-eshell-syntax-highlighting" "emacs-ess" "emacs-esup"
        "emacs-esxml" "emacs-eterm-256color" "emacs-eww-lnum"
        "emacs-extempore-mode" "emacs-f" "emacs-fennel-mode"
        "emacs-ffap-rfc-space" "emacs-fill-column-indicator" "emacs-flycheck"
        "emacs-flycheck-elm" "emacs-flycheck-guile" "emacs-flycheck-ledger"
        "emacs-fountain-mode" "emacs-geiser" "emacs-geiser-chez"
        "emacs-geiser-gauche" "emacs-geiser-guile" "emacs-geiser-racket"
        "emacs-gif-screencast" "emacs-git-modes" "emacs-gnuplot" "emacs-gntp"
        "emacs-google-translate" "emacs-graphql" "emacs-graphql-mode"
        "emacs-graphviz-dot-mode" "emacs-guix" "emacs-haskell-mode" "emacs-ht"
        "emacs-html-to-hiccup" "emacs-htmlize" "emacs-hy-mode" "emacs-hydra"
        "emacs-hyperbole" "emacs-iedit" "emacs-inf-janet" "emacs-inf-ruby"
        "emacs-janet-mode" "emacs-jedi" "emacs-jinja2-mode" "emacs-json-mode"
        "emacs-json-snatcher" "emacs-jsonnet-mode" "emacs-julia-mode"
        "emacs-julia-repl" "emacs-julia-snail" "emacs-key-chord"
        "emacs-keycast" "emacs-kibit-helper" "emacs-know-your-http-well"
        "emacs-kv" "emacs-lsp-java" "emacs-ledger-mode" "emacs-leetcode"
        "emacs-libmpdel" "emacs-lice-el" "emacs-lisp-extra-font-lock"
        "emacs-lispy" "emacs-log4e" "emacs-logview" "emacs-lorem-ipsum"
        "emacs-lua-mode" "emacs-macrostep" "emacs-magit" "emacs-magit-annex"
        "emacs-magit-gerrit" "emacs-magit-popup" "emacs-make-it-so"
        "emacs-marginalia" "emacs-markdown-mode" "emacs-markdown-preview-mode"
        "emacs-mastodon" "emacs-memoize" "emacs-meson-mode" "emacs-mint-mode"
        "emacs-move-text" "emacs-mpdel" "emacs-muse" "emacs-mustache"
        "emacs-nasm-mode" "emacs-navi-mode" "emacs-nginx-mode"
        "emacs-nhexl-mode" "emacs-nodejs-repl" "emacs-nov-el" "emacs-npm-mode"
        "emacs-oauth2" "emacs-ob-async" "emacs-org" "emacs-org-brain"
        "emacs-org-contrib" "emacs-org-cv" "emacs-org-download"
        "emacs-org-drill" "emacs-org-drill-table" "emacs-org-emms"
        "emacs-org-journal" "emacs-org-mind-map" "emacs-org-msg"
        "emacs-org-noter" "emacs-org-pandoc-import" "emacs-org-pomodoro"
        "emacs-org-present" "emacs-org-re-reveal" "emacs-org-ref"
        "emacs-org-roam" "emacs-org-vcard" "emacs-org-web-tools"
        "emacs-ox-epub" "emacs-ox-gemini" "emacs-ox-gfm" "emacs-ox-haunt"
        "emacs-ox-pandoc" "emacs-pandoc-mode" "emacs-paredit" "emacs-parsebib"
        "emacs-parseclj" "emacs-parseedn" "emacs-pass" "emacs-password-store"
        "emacs-password-store-otp" "emacs-pcre2el" "emacs-pdf-tools"
        "emacs-peg" "emacs-php-mode" "emacs-picpocket" "emacs-pinentry"
        "emacs-pkg-info" "emacs-plantuml-mode" "emacs-popup" "emacs-pos-tip"
        "emacs-powershell" "emacs-projectile" "emacs-protobuf-mode"
        "emacs-psc-ide" "emacs-pulseaudio-control" "emacs-puni"
        "emacs-purescript-mode" "emacs-qml-mode" "emacs-queue" "emacs-quickrun"
        "emacs-rainbow-blocks" "emacs-rainbow-delimiters"
        "emacs-rainbow-identifiers" "emacs-rec-mode" "emacs-reformatter"
        "emacs-request" "emacs-restart-emacs" "emacs-restclient"
        "emacs-rfcview" "emacs-rjsx-mode" "emacs-robe" "emacs-roguel-ike"
        "emacs-rpm-spec-mode" "emacs-rspec" "emacs-rudel" "emacs-rustic"
        "emacs-s" "emacs-saveplace-pdf-view" "emacs-sbt-mode"
        "emacs-scala-mode" "emacs-scheme-complete" "emacs-sesman"
        "emacs-shell-command+" "emacs-shift-number" "emacs-simple-httpd"
        "emacs-simple-mpc" "emacs-skeletor" "emacs-skewer-mode" "emacs-slack"
        "emacs-slime" "emacs-slime-company" "emacs-slime-repl-ansi-color"
        "emacs-slime-volleyball" "emacs-sml-mode" "emacs-so-long" "emacs-spark"
        "emacs-sparql-mode" "emacs-spinner" "emacs-sqlite" "emacs-srfi"
        "emacs-ssh-agency" "emacs-ssh-config-mode" "emacs-strace-mode"
        "emacs-stream" "emacs-string-inflection" "emacs-stripe-buffer"
        "emacs-stumpwm-mode" "emacs-sudo-edit" "emacs-suggest" "emacs-svg-icon"
        "emacs-svg-lib" "emacs-svg-tag-mode" "emacs-sx" "emacs-symon"
        "emacs-synosaurus" "emacs-systemd-mode" "emacs-tablist" "emacs-tagedit"
        "emacs-tco-el" "emacs-tide" "emacs-tldr" "emacs-toc-org"
        "emacs-toml-mode" "emacs-transient" "emacs-transmission" "emacs-treepy"
        "emacs-ts" "emacs-tshell" "emacs-tuareg" "emacs-typescript-mode"
        "emacs-typing" "emacs-typit" "emacs-typo" "emacs-uml-mode"
        "emacs-unfill" "emacs-vala-mode" "emacs-validate" "emacs-validate-html"
        "emacs-vdiff" "emacs-vdiff-magit" "emacs-visual-fill-column"
        "emacs-visual-regexp" "emacs-vterm" "emacs-vterm-toggle"
        "emacs-wc-mode" "emacs-web-beautify" "emacs-web-mode"
        "emacs-web-server" "emacs-webfeeder" "emacs-webpaste" "emacs-websocket"
        "emacs-wget" "emacs-which-key" "emacs-whitespace-cleanup-mode"
        "emacs-wisp-mode" "emacs-with-editor" "emacs-wordgen" "emacs-wordnut"
        "emacs-writegood-mode" "emacs-writeroom" "emacs-ws-butler"
        "emacs-xmlgen" "emacs-xpm" "emacs-xterm-color" "emacs-yaml"
        "emacs-yaml-mode" "emacs-yasnippet" "emacs-yasnippet-snippets"
        "emacs-youtube-dl" "emacs-ytel" "emacs-ztree" "emacspeak" "endless-sky"
        "epipe" "erlang" "erofs-utils" "es" "esbuild" "espeak-ng"
        "eternalterminal" "evince" "evolution" "exa" "execline" "exempi"
        "exercism" "exfat-utils" "exfatprogs" "exomizer" "expect"
        "extractpdfmark" "extundelete" "filters" "fluid-3" "fluidsynth"
        "font-gnu-freefont" "font-gnu-unifont" "font-tex-gyre" "gash" "gauche"
        "genpro" "gforth" "gfortran-toolchain" "ghc" "gimp" "git"
        "glibc-locales" "gnu-apl" "gnucobol" "gnupg"
        "gnurobots" "go" "gparted" "graphviz" "grep" "guildhall" "guile"
        "guile-bash" "guile-chickadee" "guile-git" "guile-ncurses"
        "guile-readline" "guile-sqlite3" "haunt" "hledger" "hledger-ui"
        "httrack" "icecat" "icedove" "inkscape"
        "janet" "java-bsh" "julia" "libreoffice" "libvirt" "links" "lua" "lxc"
        "maven" "mc" "milkytracker" "mit-scheme" "mono" "mpv"
        "msmtp" "mu" "nasm" "ncdu" "netcat" "nethack" "newlisp" "newt" "nim"
        "nmap" "node" "nomad" "ocaml" "offlineimap3" "orca-lang" "owl-lisp"
        "pandoc" "password-store" "passwordsafe" "pavucontrol" "php" "picolisp"
        "pinentry-emacs" "pkg-config" "portmidi" "postgresql" "python"
        "python-gitinspector" "python-lsp-server" "python-pip"
        "python-pygments" "python-pygments-lexer-pseudocode-std" "python-pyqt"
        "qemu" "r" "racket" "rakudo" "ripgrep" "ruby" "ruby-kramdown" "rust"
        "rxvt-unicode" "sassc" "sbcl" "sed" "sedsed" "setxkbmap" "shepherd"
        "slang" "sqlite" "sshfs" "sshpass" "stumpwm" "swi-prolog" "talkfilters"
        "telescope" "texinfo" "texlive" "texlive-tex-gyre"
        "the-silver-searcher" "timidity++" "tintin++" "tree" "universal-ctags"
        "uxn" "valgrind" "virt-manager" "virt-viewer" "vlang" "wesnoth"
        "wireshark" "wordnet" "xdpyprobe" "xmp" "yewscion-scripts" "yt-dlp"
        "zenity" "zig" "zutils"))
           (systems '("x86_64-linux" "aarch64-linux"))
           (priority 3)
           (channels
            (cons (channel
                   (name 'yewscion)
                   (url "https://git.sr.ht/~yewscion/yewscion-guix-channel")
                   (branch "trunk"))
                  %default-channels)))
          (specification
           (name "ARMored Core")
           (build 'core)
           (systems '("aarch64-linux"))
           (priority 3))
          (specification
           (name "Lorge")
           (build '(packages "ghc" "icecat" "icedove" "linux-libre"))
           (systems '("x86_64-linux" "aarch64-linux"))
           (priority 5))))
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
(define updatedb-job
  ;; Run 'updatedb' at 3AM every day.  Here we write the
  ;; job's action as a Scheme procedure.
  #~(job '(next-hour '(3))
         (lambda ()
           (execl (string-append #$findutils "/bin/updatedb")
                  "updatedb"
                  "--prunepaths=/tmp /var/tmp /gnu/store"))))
(define %local-php-ini
  (plain-file "php.ini"
              "memory_limit = 2G
max_execution_time = 1800"))

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
  (file-systems (cons (file-system
                        (device "/dev/sda")
                        (mount-point "/")
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
               %base-user-accounts))
  (groups (cons* (user-group
                  (name "git")
                  (system? #t))
                      %base-groups))
  (packages (cons* nss-certs            ;for HTTPS access
                   le-certs
                   openssh-sans-x
                   emacs-next
		   rxvt-unicode
                   git
                   sqlite
                   %base-packages))

  (services (cons*
             (service avahi-service-type)
	     (service unattended-upgrade-service-type)
             ;; (service cuirass-service-type
             ;;          (cuirass-configuration
             ;;           (specifications %cuirass-specs)
             ;;           (host "0.0.0.0")))
             (service guix-publish-service-type
                      (guix-publish-configuration
                       (host "0.0.0.0")
                       (advertise? #t)))
             (service dhcp-client-service-type)
	     (dovecot-service)
	     (service opensmtpd-service-type (opensmtpd-configuration))
             (service openssh-service-type
                      (openssh-configuration
                       (openssh openssh-sans-x)
               (password-authentication? #f)
                       (authorized-keys
                        `(("ming" ,(local-file "ming_rsa.pub"))
                          ("git" ,(local-file "ming_rsa.pub"))))))
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
	        	       (server-name '("yewscion.com"))
	        	       (root "/srv/http/yewscion/")
	        	       (ssl-certificate-key "/etc/letsencrypt/live/yewscion.com/privkey.pem")
	        	       (ssl-certificate "/etc/letsencrypt/live/yewscion.com/fullchain.pem"))
	        	      ))))
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
			  (domains '("cdr.gdn" "www.cdr.gdn" "links.cdr.gdn" "wb.cdr.gdn" "bugs.cdr.gdn"))
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
			  (deploy-hook %nginx-deploy-hook))))))
             (service qemu-binfmt-service-type
                      (qemu-binfmt-configuration
                       (platforms (lookup-qemu-platforms "arm" "aarch64" "risc-v"))))
             (service postgresql-service-type
                      (postgresql-configuration
                       (postgresql postgresql)
                       (port 54321)
                       (data-directory "/var/lib/postgresql/db")
                       (log-directory "/var/log/postgresql/db")))
	     (elogind-service)
	     (simple-service 'my-cron-jobs
			     mcron-service-type
			     (list updatedb-job))
             %base-services)))



