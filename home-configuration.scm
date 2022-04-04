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
  (gnu packages bash))
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
  "# Ensure You have initiated mu with the following command:
#
# mu init --my-address=cdr255@gmail.com --my-address=yewscion@gmail.com \\
# --my-address=rodnchr@amazon.com \\
# --my-address=christopher.rodriguez@csuglobal.edu
#
# Set default values for all following accounts.
defaults
auth               on
tls                on
tls_starttls       off
logfile            ~/.msmtp.log

# Gmail - cdr255
account        gmail-cdr255
from           cdr255@gmail.com
host           smtp.gmail.com
port           465
user           cdr255@gmail.com
domain         gmail.com
passwordeval   \"pass offlineimap/cdr255@gmail.com | head -n1\"


# Gmail - yewscion
account        gmail-yewscion
from           yewscion@gmail.com
host           smtp.gmail.com
port           465
user           yewscion@gmail.com
domain         gmail.com
passwordeval   \"pass offlineimap/yewscion@gmail.com | head -n1\"


# csuglobal - christopher.rodriguez
account        csuglobal
from           christopher.rodriguez@csuglobal.edu
host           smtp.gmail.com
port           465
user           christopher.rodriguez@csuglobal.edu
domain         gmail.com
passwordeval   \"pass offlineimap/christopher.rodriguez@csuglobal.edu | head -n1\"

# amazon - rodnchr
account amazon
from rodnchr@amazon.com
host ballard.amazon.com
port 1587
user ANT\\rodnchr
domain amazon.com
tls_starttls on
passwordeval   \"pass amazon | head -n1\"

# # Set a default account
# account default : gmail-cdr255
")



(home-environment
  (packages
   (map (compose list specification->package+output)
                                                  ; Commented Packages were
                                                  ; problematic after major Guix
                                                  ; update, and so I removed
                                                  ; them pending fixes.
         (list "adb"
               "adlmidi"
               ;; "apl"                           ; Broken 2022-03-31.
               "alsa-plugins"
               "alsa-plugins:pulseaudio"
               "ardour"
               "autoconf"
               "automake"
               "b3sum"
               "bash"
               "beets"
               ;; "beets-bandcamp"                ; Broken 2022-03-31.
               "biber"
               "borg"
               "brasero"
               "bsd-games"
               "btrfs-progs"
               "cabal-install"
               "chez-scheme"
               "chez-scheme:doc"
               "clisp"
               "clojure"
               "cmake"
               "coq"
               "coreutils"
               "dfc"
               "docker"
               "dosfstools"
               "doxygen"
               "efibootmgr"
               "elixir"
               "elm-compiler"
               "emacs-next"
               "emacs-alert"
               "emacs-anaphora"
               "emacs-async"
               "emacs-avy"
               "emacs-biblio"
               "emacs-bongo"
               "emacs-bui"
               "emacs-caml"
               "emacs-cider"
               "emacs-circe"
               "emacs-citar"
               "emacs-citeproc-el"
               "emacs-clojure-mode"
               "emacs-cmake-mode"
               "emacs-company"
               "emacs-company-emoji"
               "emacs-company-jedi"
               "emacs-company-lsp"
               "emacs-company-lua"
               "emacs-company-math"
               "emacs-company-org-block"
               "emacs-company-quickhelp"
               "emacs-company-restclient"
               "emacs-constants"
               "emacs-consult"
               "emacs-csv"
               "emacs-csv-mode"
               "emacs-d-mode"
               "emacs-daemons"
               "emacs-dash"
               "emacs-datetime"
               "emacs-debbugs"
               "emacs-deft"
               "emacs-dictionary"
               "emacs-diff-hl"
               "emacs-disable-mouse"
               "emacs-dmenu"
               "emacs-docker"
               "emacs-docker-compose-mode"
               "emacs-docker-tramp"
               "emacs-dockerfile-mode"
               "emacs-download-region"
               "emacs-easy-kill"
               "emacs-ebib"
               "emacs-ediprolog"
               "emacs-edit-indirect"
               "emacs-edn"
               "emacs-eldoc"
               "emacs-elf-mode"
               "emacs-elfeed"
               "emacs-elfeed-protocol"
               "emacs-elisp-docstring-mode"
               "emacs-elisp-refs"
               "emacs-elisp-slime-nav"
               "emacs-elixir-mode"
               "emacs-elm-mode"
               "emacs-elpher"
               "emacs-elpy"
               "emacs-emacsql"
               "emacs-emacsql-sqlite3"
               "emacs-embark"
               "emacs-emms"
               "emacs-emms-mode-line-cycle"
               "emacs-emojify"
               "emacs-engine-mode"
               "emacs-epl"
               "emacs-eprime"
               "emacs-erc-hl-nicks"
               "emacs-erlang"
               "emacs-eshell-did-you-mean"
               "emacs-eshell-syntax-highlighting"
               "emacs-ess"
               "emacs-esup"
               "emacs-esxml"
               "emacs-eterm-256color"
               "emacs-eww-lnum"
               "emacs-extempore-mode"
               "emacs-f"
               "emacs-fennel-mode"
               "emacs-ffap-rfc-space"
               "emacs-fill-column-indicator"
               "emacs-flycheck"
               ;; "emacs-flycheck-cpplint"        ; Broken 2022-03-31.
               "emacs-flycheck-elm"
               "emacs-flycheck-guile"
               "emacs-flycheck-ledger"
               "emacs-fountain-mode"
               "emacs-geiser"
               "emacs-geiser-chez"
               "emacs-geiser-gauche"
               "emacs-geiser-guile"
               "emacs-geiser-racket"
               "emacs-gif-screencast"
               "emacs-git-modes"
               "emacs-gnuplot"
               "emacs-gntp"
               "emacs-google-translate"
               "emacs-graphql"
               "emacs-graphql-mode"
               "emacs-graphviz-dot-mode"
               "emacs-guix"
               "emacs-haskell-mode"
               "emacs-ht"
               "emacs-html-to-hiccup"
               "emacs-htmlize"
               "emacs-hy-mode"
               "emacs-hydra"
               "emacs-hyperbole"
               "emacs-iedit"
               "emacs-inf-janet"
               "emacs-inf-ruby"
               "emacs-janet-mode"
               "emacs-jedi"
               "emacs-jinja2-mode"
               "emacs-json-mode"
               "emacs-json-snatcher"
               "emacs-jsonnet-mode"
               "emacs-julia-mode"
               "emacs-julia-repl"
               "emacs-julia-snail"
               "emacs-key-chord"
               "emacs-keycast"
               "emacs-kibit-helper"
               "emacs-know-your-http-well"
               "emacs-kv"
               "emacs-lsp-java"
               "emacs-ledger-mode"
               "emacs-leetcode"
               "emacs-libmpdel"
               "emacs-lice-el"
               "emacs-lisp-extra-font-lock"
               "emacs-lispy"
               "emacs-log4e"
               "emacs-logview"
               "emacs-lorem-ipsum"
               "emacs-lua-mode"
               "emacs-macrostep"
               "emacs-magit"
               "emacs-magit-annex"
               "emacs-magit-gerrit"
               "emacs-magit-popup"
               "emacs-make-it-so"
               "emacs-marginalia"
               "emacs-markdown-mode"
               "emacs-markdown-preview-mode"
               "emacs-mastodon"
               ;; "emacs-md4rd"                   ; Broken 2022-03-31.
               "emacs-memoize"
               "emacs-meson-mode"
               "emacs-mint-mode"
               "emacs-move-text"
               "emacs-mpdel"
               "emacs-muse"
               "emacs-mustache"
               "emacs-nasm-mode"
               "emacs-navi-mode"
               "emacs-nginx-mode"
               "emacs-nhexl-mode"
               "emacs-nodejs-repl"
               "emacs-nov-el"
               "emacs-npm-mode"
               "emacs-oauth2"
               "emacs-ob-async"
               "emacs-org"
               "emacs-org-brain"
               "emacs-org-contrib"
               "emacs-org-cv"
               "emacs-org-download"
               "emacs-org-drill"
               "emacs-org-drill-table"
               "emacs-org-emms"
               "emacs-org-journal"
               "emacs-org-mind-map"
               "emacs-org-msg"
               "emacs-org-noter"
               "emacs-org-pandoc-import"
               "emacs-org-pomodoro"
               "emacs-org-present"
               "emacs-org-re-reveal"
               "emacs-org-ref"
               "emacs-org-roam"
               "emacs-org-vcard"
               "emacs-org-web-tools"
               "emacs-ox-epub"
               "emacs-ox-gemini"
               "emacs-ox-gfm"
               "emacs-ox-haunt"
               "emacs-ox-pandoc"
               "emacs-pandoc-mode"
               "emacs-paredit"
               "emacs-parsebib"
               "emacs-parseclj"
               "emacs-parseedn"
               "emacs-pass"
               "emacs-password-store"
               "emacs-password-store-otp"
               "emacs-pcre2el"
               "emacs-pdf-tools"
               "emacs-peg"
               "emacs-php-mode"
               "emacs-picpocket"
               "emacs-pinentry"
               "emacs-pkg-info"
               "emacs-plantuml-mode"
               "emacs-popup"
               "emacs-pos-tip"
               "emacs-powershell"
               "emacs-projectile"
               "emacs-protobuf-mode"
               "emacs-psc-ide"
               "emacs-pulseaudio-control"
               "emacs-puni"
               "emacs-purescript-mode"
               "emacs-qml-mode"
               "emacs-queue"
               "emacs-quickrun"
               "emacs-rainbow-blocks"
               "emacs-rainbow-delimiters"
               "emacs-rainbow-identifiers"
               "emacs-rec-mode"
               "emacs-reformatter"
               "emacs-request"
               "emacs-restart-emacs"
               "emacs-restclient"
               "emacs-rfcview"
               "emacs-rjsx-mode"
               "emacs-robe"
               "emacs-roguel-ike"
               "emacs-rpm-spec-mode"
               "emacs-rspec"
               "emacs-rudel"
               "emacs-rustic"
               "emacs-s"
               "emacs-saveplace-pdf-view"
               "emacs-sbt-mode"
               "emacs-scala-mode"
               "emacs-scheme-complete"
               "emacs-sesman"
               "emacs-shell-command+"
               "emacs-shift-number"
               "emacs-simple-httpd"
               "emacs-simple-mpc"
               "emacs-skeletor"
               "emacs-skewer-mode"
               "emacs-slack"
               "emacs-slime"
               "emacs-slime-company"
               "emacs-slime-repl-ansi-color"
               "emacs-slime-volleyball"
               "emacs-sml-mode"
               "emacs-so-long"
               "emacs-spark"
               "emacs-sparql-mode"
               "emacs-spinner"
               "emacs-sqlite"
               "emacs-srfi"
               "emacs-ssh-agency"
               "emacs-ssh-config-mode"
               "emacs-strace-mode"
               "emacs-stream"
               "emacs-string-inflection"
               "emacs-stripe-buffer"
               "emacs-stumpwm-mode"
               "emacs-sudo-edit"
               "emacs-suggest"
               "emacs-svg-icon"
               "emacs-svg-lib"
               "emacs-svg-tag-mode"               ; Look at this later
               "emacs-sx"
               "emacs-symon"
               "emacs-synosaurus"
               "emacs-systemd-mode"
               "emacs-tablist"
               "emacs-tagedit"
               "emacs-tco-el"
               "emacs-tide"
               "emacs-tldr"
               "emacs-toc-org"
               "emacs-toml-mode"
               ;; "emacs-tramp"                   ; Unneeded in emacs-next
               ;; "emacs-tramp-auto-auth"
               "emacs-transient"
               "emacs-transmission"
               "emacs-treepy"
               "emacs-ts"
               "emacs-tshell"
               "emacs-tuareg"
               "emacs-typescript-mode"
               "emacs-typing"
               "emacs-typit"
               "emacs-typo"
               "emacs-uml-mode"
               "emacs-unfill"
               "emacs-vala-mode"
               "emacs-validate"
               "emacs-validate-html"
               "emacs-vdiff"
               "emacs-vdiff-magit"
               "emacs-visual-fill-column"
               "emacs-visual-regexp"
               "emacs-vterm"
               "emacs-vterm-toggle"
               "emacs-wc-mode"
               "emacs-web-beautify"
               "emacs-web-mode"
               "emacs-web-server"
               "emacs-webfeeder"
               "emacs-webpaste"
               "emacs-websocket"
               "emacs-wget"
               "emacs-which-key"
               "emacs-whitespace-cleanup-mode"
               "emacs-wisp-mode"
               "emacs-with-editor"
               "emacs-wordgen"
               "emacs-wordnut"
               "emacs-writegood-mode"
               "emacs-writeroom"
               "emacs-ws-butler"
               "emacs-xmlgen"
               "emacs-xpm"
               "emacs-xterm-color"
               "emacs-yaml"
               "emacs-yaml-mode"
               "emacs-yasnippet"
               "emacs-yasnippet-snippets"
               "emacs-youtube-dl"
               "emacs-ytel"
               "emacs-ztree"
               "emacspeak"
               ;; "emacsy"                        ; Broken 2022-03-31.
               "endless-sky"
               "epipe"
               "erlang"
               "erofs-utils"
               "es"
               "esbuild"
               "espeak-ng"
               "eternalterminal"
               "evince"
               "evolution"
               "exa"
               "execline"                         ; Check Out Later
               "exempi"
               "exercism"                         ; Check Out Later
               "exfat-utils"
               "exfatprogs"
               "exomizer"
               "expect"
               ;; "extempore"                     ; Inconsistent. Memory?
               "extractpdfmark"
               "extundelete"
               "filters"
               "fluid-3"
               "fluidsynth"
               "font-gnu-freefont"
               "font-gnu-unifont"
               "font-tex-gyre"
               ;; "frotz"                         ; Broken 2022-03-31.
               "gash"
               "gauche"
               "genpro"
               "gforth"
               "gfortran-toolchain"
               "ghc"
               "gimp"
               "git"
               "git:send-email"
               "glibc-locales"
               "gnu-apl"
               "gnucobol"
               "gnupg"
               "gnurobots"
               "go"
               "gparted"
               "graphviz"
               "grep"
               "guildhall"
               "guile"
               "guile-bash"
               "guile-chickadee"
               "guile-git"
               "guile-ncurses"
               "guile-readline"
               "guile-sqlite3"
               "haunt"
               "hledger"
               "hledger-ui"
               "httrack"
               "icecat"
               "icedove"
               "icedtea:jdk"
               "icedtea:doc"
               ;; "idris"
               "inkscape"
               "janet"
               "java-bsh"
               "julia"
               "libreoffice"
               "libvirt"
               "links"
               "lua"
               "lxc" ; Look at later
               "maven"
               "mc"
               "milkytracker"
               "mit-scheme"
               "mit-scheme:doc"
               "mono"
               "mpv"
               "msmtp"
               "mu"
               "nasm"
               "ncdu"
               "netcat"
               "nethack"
               "newlisp"
               "newt"
               "nim"
               "nmap"
               "node"
               "nomad"
               "ocaml"
               "offlineimap3"
               "orca-lang"
               "owl-lisp"
               "pandoc"
               "password-store"
               "passwordsafe"
               "pavucontrol"
               "php"
               "picolisp"
               "pinentry-emacs"
               "pkg-config"
               "portmidi"
               "postgresql"
               "python"
               "python-gitinspector"
               "python-lsp-server"
               "python-pip"
               "python-pygments"
               "python-pygments-lexer-pseudocode-std"
               "python-pyqt"
               "qemu"
               "r"
               "racket"
               "rakudo"
               "ripgrep"
               "ruby"
               "ruby-kramdown"
               "rust"
               "rxvt-unicode"
               "sassc"
               "sbcl"
               "sed"
               "sedsed"
               "setxkbmap"
               "shepherd"
               "slang"
               "sqlite"
               "sshfs"
               "sshpass"
               "stumpwm"
               "swi-prolog"
               "talkfilters"
               "telescope"
               "texinfo"
               "texlive"
               "texlive-tex-gyre"
               "the-silver-searcher"
               "timidity++"
               "tintin++"
               "tree"
               "uxn"
               "valgrind"
               "virt-manager"
               "virt-viewer"
               "vlang"
               "wesnoth"
               "wireshark"
               "wordnet"
               "xdpyprobe"
               "xmp"
               "yewscion-scripts"
               "yt-dlp"
               "zenity"
               "zig"
               "zutils")))
  (services
   (list (service
            home-bash-service-type
            (home-bash-configuration
              (aliases
                '((".." . "cd ..")
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
                  ("port" . "cd $(cat ~/.sd)")
                  ("nm-amzn-internet" . "nmcli connection up id amzn-internet && nmcli connection show --active")
                  ("nm-asin324" . "nmcli connection up id \\\"Amazon Wi-Fi Settings (asin324)\\\" && nmcli connection show --active")
                  ("nm-cdr255" . "nmcli connection up id cdr255 && nmcli connection show --active")
                  ("nm-codys-corner" . "nmcli connection up id \\\"Cody's Corner\\\" && nmcli connection show --active")
                  ("gitinspect" . "gitinspector -f tex,scm,org,*,md,java,clj,lisp -HlmrTw -F htmlembedded > gitinspector.html")
                  ("daily-update-guix" . "guix pull && guix home reconfigure $HOME/Documents/guix-home/home-configuration.scm && guix gc && guix gc --delete-generations")))
              (bash-profile
               (list (plain-file "bash-profile"
                                 (format #f "~a~%~a~%~a~a~a~%~a~%~a~%~a~%~a~%~a~%~a~%~a~a~a~%~a~%~a"
                                         "function dir-git-branch()"
                                         "{"
                                         "git branch 2>/dev/null | "
                                         "grep \"^*\" | "
                                         "sed 's/* /</;s/$/> /'"
                                         "}"
                                         "case \"$TERM\" in"
                                         "\"dumb\")"
                                         "export PS1=\"> \""
                                         ";;"
                                         "xterm*|rxvt*|eterm*|screen*)"
                                         "tty -s && export PS1=\""
                                         my-ps1-prompt
                                         "\""
                                         ";;"
                                         "esac"))))
              (bashrc
               (list (plain-file "bashrc"
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
                                         "xpg_echo"))))
              (bash-logout
                (list (plain-file
                        "bash_logout"
                        "")))
              (environment-variables
               '(("SHELL" . "bash")
                 ("HISTCONTROL" . "ignoreboth")
                 ("HISTTIMEFORMAT" . "true")
                 ("PATH" . "$PATH:$HOME/.local/bin")))
              (guix-defaults? #t)
              (package bash)))
         (simple-service 'test-config
                         home-files-service-type
                         (list `("config/shepherd/init.scm"
                                 ,(plain-file "user-shepherd-init.scm"
                                              my-shepherd-init))
                               `("config/shepherd/services.scm"
                                 ,(plain-file "user-shepherd-services.scm"
                                              my-shepherd-services)))))))
