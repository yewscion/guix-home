;; This "home-environment" file can be passed to 'guix home
;; reconfigure' to reproduce the content of your profile.  This is
;; "symbolic": it only specifies package names.  To reproduce the
;; exact same profile, you also need to capture the channels being
;; used, as returned by "guix describe".  See the "Replicating Guix"
;; section in the manual.

(use-modules
 (gnu home)
 (gnu packages)
 (gnu services)
 (guix gexp)
 (guix i18n)
 (gnu home services shells)
 (gnu home services)
 (gnu packages bash)
 (guix transformations)
 (guix monads)
 (guix store)
 (gnu packages code))
(define my-ps1-prompt
  (string-append "\\[\\e[0;2;35m\\][\\[\\e[0;2;"
                 "35m\\]\\#\\[\\e[0;2;35m\\].\\[\\e["
                 "0;2;35m\\]0\\[\\e[0;2;35m\\]] "
                 "\\[\\e[0;2;37m\\]{\\[\\e[0;2;"
                 "37m\\]\\A\\[\\e[0;2;37m\\]} \\[\\e"
                 "[0;2;34m\\]\\$("
                 "dir-git-branch)\\[\\e[0;2;33m\\]\\$("
                 "display-encoded-wifi) "
                 "\\[\\e[0;92m\\]\\u\\[\\e[0m\\]@"
                 "\\[\\e[0;36m\\]\\h\\[\\e[0m\\]:"
                 "\\[\\e[0;94m\\]\\W\\[\\e[0;94m\\]"
                 "/\\[\\e[0m\\]$ \\[\\e[0m\\]"))
(define my-shepherd-services
  "(define emacs
 (make <service>
   #:provides '(emacs)
   #:requires '()
   #:start (make-system-constructor \"emacs --daemon\")
   #:stop (make-system-destructor
           \"emacsclient --eval \\\"(kill-emacs)\\\"\")
   #:declarative? #f))")
(define my-shepherd-init
  "(load \"services.scm\")
(register-services emacs)
(action 'shepherd 'daemonize) ; send shepherd into background
(for-each start (list emacs)) ; services to start automatically")
(define my-msmtprc
  (string-append
   "# Ensure You have initiated mu with the following command:\n"
   "#\n"
   "# mu init --my-address=cdr255@gmail.com "
   "--my-address=yewscion@gmail.com \\\n"
   "# --my-address=rodnchr@amazon.com \\\n"
   "# --my-address=christopher.rodriguez@csuglobal.edu\n"
   "#\n"
   "# Set default values for all following accounts.\n"
   "defaults\n"
   "auth               on\n"
   "tls                on\n"
   "tls_starttls       off\n"
   "logfile            ~/.msmtp.log\n"
   "\n"
   "# Gmail - cdr255\n"
   "account        gmail-cdr255\n"
   "from           cdr255@gmail.com\n"
   "host           smtp.gmail.com\n"
   "port           465\n"
   "user           cdr255@gmail.com\n"
   "domain         gmail.com\n"
   "passwordeval   \"pass offlineimap/cdr255@gmail.com | head -n1\"\n"
   "\n"
   "\n"
   "# Gmail - yewscion\n"
   "account        gmail-yewscion\n"
   "from           yewscion@gmail.com\n"
   "host           smtp.gmail.com\n"
   "port           465\n"
   "user           yewscion@gmail.com\n"
   "domain         gmail.com\n"
   "passwordeval   \"pass offlineimap/yewscion@gmail.com | head -n1\"\n"
   "\n"
   "\n"
   "# csuglobal - christopher.rodriguez\n"
   "account        csuglobal\n"
   "from           christopher.rodriguez@csuglobal.edu\n"
   "host           smtp.gmail.com\n"
   "port           465\n"
   "user           christopher.rodriguez@csuglobal.edu\n"
   "domain         gmail.com\n"
   "passwordeval "
   "\"pass offlineimap/christopher.rodriguez@csuglobal.edu | head -n1\"\n"
   "\n"
   "# amazon - rodnchr\n"
   "account amazon\n"
   "from rodnchr@amazon.com\n"
   "host ballard.amazon.com\n"
   "port 1587\n"
   "user ANT\\rodnchr\n"
   "domain amazon.com\n"
   "tls_starttls on\n"
   "passwordeval   \"pass amazon | head -n1\"\n"
   "\n"
   "# # Set a default account\n"
   "# account default : gmail-cdr255\n"
   ))
(define my-function-dir-git-branch
  (string-append "dir-git-branch() {\n"
                 "    git branch 2>/dev/null | \\\n"
                 "        grep \"^*\" | \\\n"
                 "        sed 's/* /</;s/$/> /'\n"
                 "}\n"))
(define my-bashrc
  (format #f "~@{~a~^ ~}"
          "shopt -s"
          "checkwinsize"
          "autocd"
          "cdspell"
          "checkhash"
          "cmdhist"
          "direxpand"
          "extglob"
          "gnu_errfmt"
          "histappend"
          "lithist"
          "no_empty_cmd_completion"
          "progcomp"
          "sourcepath"
          "xpg_echo"))
(define my-function-nm-switch
  (string-append "nm-switch() {\n"
                 "    nmcli connection up id \"$1\" && \\\n"
                 "        nmcli connection show --active\n"
                 "}\n"))
(define my-nm-amzn-internet
  "nm-switch amzn-internet")
(define my-nm-asin324
  "nm-switch \\\"Amazon Wi-Fi Settings (asin324)\\\"")
(define my-nm-cdr255
  "nm-switch cdr255")
(define my-nm-codys-corner
  "nm-switch \\\"Cody's Corner\\\"")
(define my-function-log-guix-state
  (string-append "log-guix-state() {\n"
                 "    guix describe -f human \| sed -n \"1p\"\n"
                 "    guix describe -f channels\n"
                 "    guix package --export-manifest\n"
                 "    guix package --list-generations\n}\n"))
(define my-function-daily-update-guix
  (string-append "daily-update-guix() {\n"
                 "    timestamp=$(date -Is)\n"
                 "    mkdir -pv \"$HOME/.local/var/log/guix\"\n"
                 "    log-guix-state \| \\\n"
                 "    tee \"$HOME/.local/var/log/guix/"
                 "$timestamp-pre-update.log\"\n"
                 "    guix pull\n"
                 "    guix home reconfigure \\\n"
                 "         $HOME/Documents/guix-home/"
                 "home-configuration.scm\n"
                 "    log-guix-state \| \\\n"
                 "    tee \"$HOME/.local/var/log/guix/"
                 "$timestamp-post-update.log\"\n}\n"))
(define my-bash-profile
  (string-append my-function-dir-git-branch
                 my-function-nm-switch
                 my-function-log-guix-state
                 my-function-daily-update-guix
                 "case \"$TERM\" in\n"
                 "    \"dumb\")\n"
                 "        export PS1=\"> \"\n"
                 "        ;;\n"
                 "    xterm*|rxvt*|eterm*|screen*)\n"
                 "        tty -s && export PS1=\""
                 my-ps1-prompt
                 "\"\n"
                 "        ;;\n"
                 "esac\n"))
;;; Grouping Packages By Type

;;;; Graveyard
                                        ; None! :^)
;;; Once Problematic
(define my-problem-packages
  (list
   "emacs-webpaste" "emacs-slack" "emacs-org-web-tools" "emacs-lsp-java"
   "emacs-tldr" "emacs-company-jedi" "emacs-jedi" "emacs-request"
   "emacs-list-utils" "emacs-elisp-refs" "java-eclipse-core-runtime" 
   "emacs-elm-mode" "maven" "my-frotz"))
;;;; Emacs
(define my-emacs-packages
  (list
   "emacs" "emacs-alert" "emacs-anaphora" "emacs-async" "emacs-avy"
   "emacs-biblio" "emacs-bongo" "emacs-bui" "emacs-caml" "emacs-chess"
   "emacs-cider" "emacs-circe" "emacs-citar" "emacs-citeproc-el"
   "emacs-clojure-mode" "emacs-cmake-mode" "emacs-company"
   "emacs-company-emoji" "emacs-company-lsp" "emacs-company-lua"
   "emacs-company-math" "emacs-company-org-block" "emacs-company-quickhelp"
   "emacs-company-restclient" "emacs-constants" "emacs-consult" "emacs-csv"
   "emacs-csv-mode" "emacs-d-mode" "emacs-daemons" "emacs-dash"
   "emacs-datetime" "emacs-debbugs" "emacs-deft" "emacs-dictionary"
   "emacs-diff-hl" "emacs-disable-mouse" "emacs-dmenu" "emacs-docker"
   "emacs-docker-compose-mode" "emacs-docker-tramp" "emacs-dockerfile-mode"
   "emacs-download-region" "emacs-easy-kill" "emacs-ebdb" "emacs-ebib"
   "emacs-ediprolog"
   "emacs-edit-indirect" "emacs-edn" "emacs-eldoc" "emacs-elf-mode"
   "emacs-elfeed" "emacs-elfeed-protocol" "emacs-elisp-docstring-mode"
   "emacs-elisp-slime-nav" "emacs-elixir-mode" "emacs-elpher" "emacs-elpy"
   "emacs-emacsql" "emacs-emacsql-sqlite3" "emacs-embark" "emacs-emms"
   "emacs-emms-mode-line-cycle" "emacs-emojify" "emacs-engine-mode"
   "emacs-epl" "emacs-eprime" "emacs-erc-hl-nicks" "emacs-erlang"
   "emacs-eshell-did-you-mean" "emacs-eshell-syntax-highlighting" "emacs-ess"
   "emacs-esup" "emacs-esxml" "emacs-eterm-256color" "emacs-eww-lnum"
   "emacs-exiftool" "emacs-extempore-mode" "emacs-f" "emacs-fennel-mode"
   "emacs-ffap-rfc-space" "emacs-fill-column-indicator" "emacs-flycheck"
   "emacs-flycheck-elm" "emacs-flycheck-guile" "emacs-flycheck-ledger"
   "emacs-fountain-mode" "emacs-geiser" "emacs-geiser-chez"
   "emacs-geiser-gauche" "emacs-geiser-guile" "emacs-geiser-racket"
   "emacs-gif-screencast" "emacs-git-modes" "emacs-gnuplot" "emacs-gntp"
   "emacs-google-translate" "emacs-graphql" "emacs-graphql-mode"
   "emacs-graphviz-dot-mode" "emacs-guix" "emacs-ht" "emacs-html-to-hiccup"
   "emacs-htmlize" "emacs-hy-mode" "emacs-hydra" "emacs-hyperbole"
   "emacs-iedit" "emacs-inf-janet" "emacs-inf-ruby" "emacs-janet-mode"
   "emacs-jinja2-mode" "emacs-json-mode" "emacs-json-snatcher"
   "emacs-jsonnet-mode" "emacs-julia-mode" "emacs-julia-repl"
   "emacs-julia-snail" "emacs-key-chord" "emacs-keycast" "emacs-kibit-helper"
   "emacs-know-your-http-well" "emacs-kv" "emacs-ledger-mode" "emacs-leetcode"
   "emacs-libmpdel" "emacs-lice-el" "emacs-lisp-extra-font-lock" "emacs-lispy"
   "emacs-log4e" "emacs-logview" "emacs-lorem-ipsum" "emacs-lua-mode"
   "emacs-macrostep" "emacs-magit" "emacs-magit-annex" "emacs-magit-gerrit"
   "emacs-magit-popup" "emacs-make-it-so" "emacs-marginalia"
   "emacs-markdown-mode" "emacs-markdown-preview-mode" "emacs-mastodon"
   "emacs-memoize" "emacs-meson-mode" "emacs-mint-mode" "emacs-move-text"
   "emacs-mpdel" "emacs-muse" "emacs-mustache" "emacs-nasm-mode"
   "emacs-navi-mode" "emacs-nginx-mode" "emacs-nhexl-mode" "emacs-nodejs-repl"
   "emacs-nov-el" "emacs-npm-mode" "emacs-oauth2" "emacs-ob-async" "emacs-org"
   "emacs-org-brain" "emacs-org-contrib" "emacs-org-cv" "emacs-org-download"
   "emacs-org-drill" "emacs-org-drill-table" "emacs-org-emms"
   "emacs-org-journal" "emacs-org-mind-map" "emacs-org-msg" "emacs-org-noter"
   "emacs-org-pandoc-import" "emacs-org-pomodoro" "emacs-org-present"
   "emacs-org-re-reveal" "emacs-org-ref" "emacs-org-roam" "emacs-org-vcard"
   "emacs-ox-epub" "emacs-ox-gemini" "emacs-ox-gfm" "emacs-ox-haunt"
   "emacs-ox-pandoc" "emacs-pandoc-mode" "emacs-paredit" "emacs-parsebib"
   "emacs-parseclj" "emacs-parseedn" "emacs-pass" "emacs-password-store"
   "emacs-password-store-otp" "emacs-pcre2el" "emacs-pdf-tools" "emacs-peg"
   "emacs-php-mode" "emacs-picpocket" "emacs-pinentry" "emacs-pkg-info"
   "emacs-plantuml-mode" "emacs-popup" "emacs-pos-tip" "emacs-powershell"
   "emacs-projectile" "emacs-protobuf-mode" "emacs-psc-ide"
   "emacs-pulseaudio-control" "emacs-puni" "emacs-purescript-mode"
   "emacs-qml-mode" "emacs-queue" "emacs-quickrun" "emacs-rainbow-blocks"
   "emacs-rainbow-delimiters" "emacs-rainbow-identifiers" "emacs-rec-mode"
   "emacs-reformatter" "emacs-restart-emacs" "emacs-restclient"
   "emacs-rfcview" "emacs-rjsx-mode" "emacs-robe" "emacs-roguel-ike"
   "emacs-rpm-spec-mode" "emacs-rspec" "emacs-rudel" "emacs-rustic" "emacs-s"
   "emacs-saveplace-pdf-view" "emacs-sbt-mode" "emacs-scala-mode"
   "emacs-scheme-complete" "emacs-sesman" "emacs-shell-command+"
   "emacs-shift-number" "emacs-simple-httpd" "emacs-simple-mpc"
   "emacs-skeletor" "emacs-skewer-mode" "emacs-slime" "emacs-slime-company"
   "emacs-slime-repl-ansi-color" "emacs-slime-volleyball" "emacs-sml-mode"
   "emacs-so-long" "emacs-spark" "emacs-sparql-mode" "emacs-spinner"
   "emacs-sqlite" "emacs-srfi" "emacs-ssh-agency" "emacs-ssh-config-mode"
   "emacs-strace-mode" "emacs-stream" "emacs-string-inflection"
   "emacs-stripe-buffer" "emacs-stumpwm-mode" "emacs-sudo-edit"
   "emacs-suggest" "emacs-svg-icon" "emacs-svg-lib" "emacs-svg-tag-mode"
   "emacs-sx" "emacs-symon" "emacs-synosaurus" "emacs-systemd-mode"
   "emacs-tablist" "emacs-tagedit" "emacs-tco-el" "emacs-tide" "emacs-toc-org"
   "emacs-toml-mode" "emacs-transient" "emacs-transmission" "emacs-treepy"
   "emacs-ts" "emacs-tshell" "emacs-tuareg" "emacs-typescript-mode"
   "emacs-typing" "emacs-typit" "emacs-typo" "emacs-uml-mode" "emacs-unfill"
   "emacs-vala-mode" "emacs-validate" "emacs-validate-html" "emacs-vdiff"
   "emacs-vdiff-magit" "emacs-visual-fill-column" "emacs-visual-regexp"
   "emacs-vterm" "emacs-vterm-toggle" "emacs-wc-mode" "emacs-web-beautify"
   "emacs-web-mode" "emacs-web-server" "emacs-webfeeder" "emacs-websocket"
   "emacs-wget" "emacs-which-key" "emacs-whitespace-cleanup-mode"
   "emacs-wisp-mode" "emacs-with-editor" "emacs-wordgen" "emacs-wordnut"
   "emacs-writegood-mode" "emacs-writeroom" "emacs-ws-butler" "emacs-xmlgen"
   "emacs-xpm" "emacs-xterm-color" "emacs-yaml" "emacs-yaml-mode"
   "emacs-yasnippet" "emacs-yasnippet-snippets" "emacs-youtube-dl"
   "emacs-ytel" "emacs-zones" "emacs-ztree" "emacspeak" "pinentry-emacs"))
 ;;;; LaTeX
(define
  my-texlive-packages
  (list
   "biber" "extractpdfmark" "texlive-biblatex" "texlive-biblatex-apa"
   "texlive-booktabs" "texlive-capt-of" "texlive-csquotes" "texlive-doi" "texlive-etoolbox"
   "texlive-enumitem" "texlive-fontspec" "texlive-generic-etexcmds"
   "texlive-generic-gettitlestring" "texlive-generic-ifptex"
   "texlive-generic-iftex" "texlive-generic-xstring" "texlive-hyperref"
   "texlive-ifmtarg" "texlive-kpathsea" "texlive-kpfonts" "texlive-latex-appendix"
   "texlive-latex-catchfile" "texlive-latex-cleveref" "texlive-latex-comment"
   "texlive-latex-datetime2" "texlive-latex-datetime2-english"
   "texlive-latex-endfloat" "texlive-latex-environ" "texlive-latex-everyhook"
   "texlive-latex-fancyhdr" "texlive-latex-fancyvrb" "texlive-latex-float"
   "texlive-latex-framed" "texlive-latex-fvextra" "texlive-latex-geometry"
   "texlive-latex-ifplatform" "texlive-latex-kvoptions"
   "texlive-latex-letltxmacro" "texlive-latex-lineno" "texlive-latex-lipsum"
   "texlive-latex-lwarp" "texlive-latex-memoir" "texlive-latex-minted"
   "texlive-latex-newfloat" "texlive-latex-newunicodechar"
   "texlive-latex-pdftexcmds" "texlive-latex-printlen"
   "texlive-latex-readablecv" "texlive-latex-refcount"
   "texlive-latex-setspace" "texlive-latex-titlesec"
   "texlive-latex-trimspaces" "texlive-latex-upquote" "texlive-latex-xkeyval"
   "texlive-latex-xpatch" "texlive-libkpathsea" "texlive-listings"
   "texlive-lm" "texlive-luaotfload" "texlive-pdfx" "texlive-stringenc" "texlive-svn-prov"
   "texlive-tex-gyre" "texlive-tracklang" "texlive-txfonts" "texlive-varwidth"
   "texlive-xcolor" "texlive-xifthen" "xindy"))
;;;; Programming
(define
  my-programming-packages
  (list
   "adb" "ant" "ant-junit" "apl" "autoconf" "automake" "chez-scheme"
   "chez-scheme:doc" "clang-toolchain" "clisp" "clojure" "cmake" "doxygen"
   "dune" "elm" "erlang" "esbuild" "exercism" "fennel" "fnlfmt" "gambit-c"
   "gauche" "gcc-toolchain" "gerbil" "git" "git:send-email" "graphviz"
   "guildhall" "guile" "guile-bash" "guile-cdr255" "guile-chickadee"
   "guile-colorized" "guile-git" "guile-goblins" "guile-hall"
   "guile-ncurses" "guile-readline" "guile-ssh" "guile-sqlite3"
   "janet" "java-bsh" "java-junit" "java-log4j-core" "kawa" "make"
   "mit-scheme" "mit-scheme:doc" "mono" "nasm" "ncurses" "newlisp" "newt" "node"
   "ocaml" "ocaml-down" "ocaml-merlin" "ocaml-utop" "opam" "openjdk:jdk" "openjdk:doc" "perl"
   "perl-image-exiftool" "php" "picolisp" "pkg-config" "plantuml" "portmidi"
   "python" "python-lsp-server" "python-pip" "python-pygments"
   "python-pygments-lexer-pseudocode-std" "python-pyqt" "ruby" "ruby-kramdown"
   "rust" "sassc" "sbcl" "sbcl-stumpwm-battery-portable"
   "sbcl-stumpwm-screenshot" "sbcl-zpng" "slang" "swi-prolog" "texinfo"
   "universal-ctags" "vlang"))
;;;; System Stuff
(define
  my-system-packages
  (list
   "alsa-plugins" "alsa-plugins:pulseaudio" "bash" "btrfs-progs" "coreutils"
   "curl" "dfc" "dmidecode" "docker" "dosfstools" "efibootmgr" "erofs-utils" "es"
   "espeak-ng" "exa" "exfat-utils" "exfatprogs" "exomizer" "expect"
   "extundelete" "fluid-3" "gash" "glibc-locales" "gnupg" "gparted" "grep" "icecat"
   "le-certs" "libvirt" "links" "lxc" "mc" "memtester" "ncdu" "netcat" "nmap" "nss-certs"
   "password-store" "pavucontrol" "postgresql" "qemu" "ripgrep" "rxvt-unicode"
   "sed" "sedsed" "setxkbmap" "shepherd" "sshfs" "sshpass" "stumpwm"
   "stumpwm:lib" "the-silver-searcher" "tree" "unzip" "virt-manager" "virt-viewer"
   "which" "wireshark" "wordnet" "xdpyprobe" "yt-dlp" "zenity" "zutils"))
;;;; Userland/Etc
(define
  my-user-packages
  (list
   "adlmidi" "ardour" "b3sum" "beets" "borg" "brasero" "brightnessctl" "bsd-games"
   "codechallenge-solutions"
   "endless-sky" "evince" "exempi" "exercism" "filters" "fluid-3" "fluidsynth"
   "font-gnu-freefont" "font-gnu-unifont" "font-tex-gyre" "genpro" "gifsicle" "gimp"
   "gnurobots" "haunt" "hexchat" "httrack" "inkscape" "ispell" "jpegoptim"
   "leiningen-ng" "libreoffice" "milkytracker" "mpv" "msmtp" "mu" "nethack"
   "nomad" "offlineimap3" "orca-music" "owl-lisp" "pagr" "pandoc"
   "passwordsafe" "patchelf" "talkfilters" "telescope" "timidity++" "tintin++"
   "ungoogled-chromium" "uxn" "wesnoth" "wine" "xapian" "xboard" "xdg-utils" "xmp" "xrdb"
   "yewscion-scripts"))
(define my-u-ctags (computed-file
                    "u-ctags"
	            #~(begin
		        (mkdir #$output)
		        (chdir #$output)
                        (mkdir "bin")
		        (symlink
		         (string-append
		          #+universal-ctags
		          "/bin/ctags")
		         (string-append
                          #$output
                          "/bin/u-ctags")))))
(define my-spec-list (append my-emacs-packages
                             my-texlive-packages
                             my-programming-packages
                             my-system-packages
                             my-user-packages
                             my-problem-packages))
(define my-package-list (map (compose list specification->package+output)
                             my-spec-list))
(home-environment
 (packages
  my-package-list)
 (services
  (list (service
         home-bash-service-type
         (home-bash-configuration
          (aliases
           `((".." . "cd ..")
             ("..." . "cd ../..")
             ("...." . "cd ../../..")
             ("....." . "cd ../../../..")
             ("egrep" . "egrep --color=auto")
             ("fgrep" . "fgrep --color=auto")
             ("grep" . "grep --color=auto")
             ("l" . "ls -CF")
             ("la" . "ls -A")
             ("ll" . "ls -alF")
             ("ls" . "ls --color=auto")
             ("mark" . "pwd > ~/.sd")
             ("port" . "cd \\$(cat ~/.sd)")
             ("nm-amzn-internet" . ,my-nm-amzn-internet)
             ("nm-asin324" . ,my-nm-asin324)
             ("nm-cdr255" . ,my-nm-cdr255)
             ("nm-codys-corner" . ,my-nm-codys-corner)))
          (bash-profile
           (list (plain-file "bash-profile"
                             my-bash-profile)))
          (bashrc
           (list (plain-file "bashrc"
                             my-bashrc)))
          (bash-logout
           (list (plain-file
                  "bash_logout"
                  "")))
          (environment-variables
           '(("SHELL" . "bash")
             ("HISTCONTROL" . "ignoreboth")
             ("HISTTIMEFORMAT" . "true")
             ("PATH" . "$HOME/.local/bin:$PATH:$HOME/.local/npm/bin")
             ("EDITOR" . "emacsclient")
             ("TEXMFCACHE" . "$HOME/.local/share/texmf-dist")
	     ("CLASSPATH" . "$GUIX_PROFILE/share/java")))
          (guix-defaults? #t)
          (package bash)))
        (simple-service 'dotfiles
                        home-files-service-type
                        (list `(".config/shepherd/init.scm"
                                ,(plain-file "user-shepherd-init.scm"
                                             my-shepherd-init))
                              `(".config/shepherd/services.scm"
                                ,(plain-file "user-shepherd-services.scm"
                                             my-shepherd-services))
                              `(".msmtprc"
                                ,(plain-file "msmtprc"
                                             my-msmtprc))
                              `(".emacs.d/init.el"
                                ,(local-file "dotfiles/emacs-config.el"))
                              `(".emacs.d/library-of-babel.org"
                                ,(local-file "dotfiles/library-of-babel.org"))
                              `(".emacs.d/lisp"
                                ,(local-file "dotfiles/local-elisp"
                                             #:recursive? #true))
                              `(".local/share/empty-repo"
                                ,(local-file "dotfiles/empty-repo"
                                             #:recursive? #true))                              
                              `(".emacs.d/templates"
                                ,(local-file "dotfiles/templates"
                                             #:recursive? #true))
                               `(".Xresources"
                                ,(local-file "dotfiles/.Xresources" "xresources"
                                             #:recursive? #true))
                              `(".config/mc/ini"
                                ,(local-file "dotfiles/mc.ini" "mc-ini"
                                             #:recursive? #true))
                              `(".config/stumpwm/config"
                                ,(local-file "dotfiles/stumpwmrc" "stumpwmrc"
                                             #:recursive? #true))
                              `(".config/gitconfig.scm"
                                ,(local-file "dotfiles/gitconfig.scm" "gitconfig-values"
                                             #:recursive? #true))
                              `(".config/stumpwm/window-placement.lisp"
                                ,(local-file "dotfiles/stumpwm-windows.lisp"
                                             "stumpwm-windows.lisp"
                                             #:recursive? #true))
                              `(".local/bin/u-ctags"
                                ,(file-append my-u-ctags "/bin/u-ctags")))))))
