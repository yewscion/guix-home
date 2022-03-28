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

(home-environment
  (packages
   (map (compose list specification->package+output)
                                        ; Commented Packages were
                                        ; problematic after major Guix
                                        ; update, and so I removed
                                        ; them pending fixes.
         (list "adb"
               "adlmidi"
               ;; "apl"
               "alsa-plugins"
               "alsa-plugins:pulseaudio"
               "autoconf"
               "automake"
               "bash"
               "beets"
               ;; "beets-bandcamp"
               "borg"
               "brasero"
               "btrfs-progs"
               "cabal-install"
               "chez-scheme"
               "chez-scheme:doc"
               "clisp"
               "clojure"
               "cmake"
               "coq"
               "dfc"
               "docker"
               "dosfstools"
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
               ;; "emacs-flycheck-cpplint"
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
               ;; "emacs-md4rd"
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
               "emacs-svg-tag-mode" ; Look at this later
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
               ;; "emacs-tramp"                ; Unneeded in emacs-next
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
               ;; "emacsy"
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
               "execline" ; Check Out Later
               "exempi"
               "exercism" ; Check Out Later
               "exfat-utils"
               "exfatprogs"
               "exomizer"
               "expect"
               ;; "extempore"
               "extractpdfmark"
               "extundelete"
               "fluid-3"
               "fluidsynth"
               "font-gnu-freefont"
               "font-gnu-unifont"
               ;; "frotz"
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
               "guile"
               "guile-git"
               "guile-readline"
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
               "julia"
               "libreoffice"
               "links"
               "lua"
               "maven"
               "mc"
               "milkytracker"
               "mit-scheme"
               "mit-scheme:doc"
               "mono"
               "mpv"
               "nasm"
               "ncdu"
               "netcat"
               "nethack"
               "newlisp"
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
               ;; "passwordsafe"
               "pavucontrol"
               "php"
               "picolisp"
               "pkg-config"
               "portmidi"
               "postgresql"
               "python"
               "python-pip"
               "python-pyqt"
               "r"
               "racket"
               "rakudo"
               "ruby"
               "ruby-kramdown"
               "rust"
               "rxvt-unicode"
               "sassc"
               "sbcl"
               "sed"
               "setxkbmap"
               "sshfs"
               "sshpass"
               "stumpwm"
               "swi-prolog"
               ;; "telegram-desktop"
               "telescope"
               "texinfo"
               "texlive"
               ;; The following are the piecemeal TexLive packages, in case
               ;; there comes a time I don't want the above full distribution.
               ;;
               ;; "texlive-adjustbox"
               ;; "texlive-ae"
               ;; "texlive-amscls"
               ;; "texlive-amsfonts"
               ;; "texlive-amsfonts-fixed"
               ;; "texlive-amsmath"
               ;; "texlive-arev"
               ;; "texlive-babel"
               ;; "texlive-babel-fixed"
               ;; "texlive-babel-french"
               ;; "texlive-babel-swedish"
               ;; "texlive-base"
               ;; "texlive-beamer"
               ;; "texlive-bera"
               ;; "texlive-biblatex"
               ;; "texlive-bibtex"
               ;; "texlive-bin"
               ;; "texlive-booktabs"
               ;; "texlive-cabin"
               ;; "texlive-calrsfs"
               ;; "texlive-capt-of"
               ;; "texlive-caption"
               ;; "texlive-carlisle"
               ;; "texlive-charter"
               ;; "texlive-cm"
               ;; "texlive-cm-super"
               ;; "texlive-collectbox"
               ;; "texlive-context"
               ;; "texlive-courier"
               ;; "texlive-csquotes"
               ;; "texlive-dehyph-exptl"
               ;; "texlive-dejavu"
               ;; "texlive-doi"
               ;; "texlive-dvips"
               ;; "texlive-dvips-l3backend"
               ;; "texlive-enumitem"
               ;; "texlive-epsf"
               ;; "texlive-etex"
               ;; "texlive-etoolbox"
               ;; "texlive-eurosym"
               ;; "texlive-filemod"
               ;; "texlive-fira"
               ;; "texlive-fontaxes"
               ;; "texlive-fontinst"
               ;; "texlive-fontname"
               ;; "texlive-fonts-ec"
               ;; "texlive-fonts-iwona"
               ;; "texlive-fonts-latex"
               ;; "texlive-fonts-rsfs"
               ;; "texlive-fontspec"
               ;; "texlive-fourier"
               ;; "texlive-fpl"
               ;; "texlive-generic-atbegshi"
               ;; "texlive-generic-babel-english"
               ;; "texlive-generic-babel-german"
               ;; "texlive-generic-bigintcalc"
               ;; "texlive-generic-bitset"
               ;; "texlive-generic-etexcmds"
               ;; "texlive-generic-gettitlestring"
               ;; "texlive-generic-iftex"
               ;; "texlive-generic-infwarerr"
               ;; "texlive-generic-intcalc"
               ;; "texlive-generic-kvdefinekeys"
               ;; "texlive-generic-kvsetkeys"
               ;; "texlive-generic-listofitems"
               ;; "texlive-generic-ltxcmds"
               ;; "texlive-generic-pdfescape"
               ;; "texlive-generic-uniquecounter"
               ;; "texlive-graphics-cfg"
               ;; "texlive-graphics-def"
               ;; "texlive-greek-fontenc"
               ;; "texlive-grfext"
               ;; "texlive-grffile"
               ;; "texlive-hardwrap"
               ;; "texlive-helvetic"
               ;; "texlive-hyperref"
               ;; "texlive-hyph-utf8"
               ;; "texlive-hyphen-afrikaans"
               ;; "texlive-hyphen-ancientgreek"
               ;; "texlive-hyphen-armenian"
               ;; "texlive-hyphen-base"
               ;; "texlive-hyphen-basque"
               ;; "texlive-hyphen-belarusian"
               ;; "texlive-hyphen-bulgarian"
               ;; "texlive-hyphen-catalan"
               ;; "texlive-hyphen-chinese"
               ;; "texlive-hyphen-churchslavonic"
               ;; "texlive-hyphen-coptic"
               ;; "texlive-hyphen-croatian"
               ;; "texlive-hyphen-czech"
               ;; "texlive-hyphen-danish"
               ;; "texlive-hyphen-dutch"
               ;; "texlive-hyphen-english"
               ;; "texlive-hyphen-esperanto"
               ;; "texlive-hyphen-estonian"
               ;; "texlive-hyphen-ethiopic"
               ;; "texlive-hyphen-finnish"
               ;; "texlive-hyphen-french"
               ;; "texlive-hyphen-friulan"
               ;; "texlive-hyphen-galician"
               ;; "texlive-hyphen-georgian"
               ;; "texlive-hyphen-german"
               ;; "texlive-hyphen-greek"
               ;; "texlive-hyphen-hungarian"
               ;; "texlive-hyphen-icelandic"
               ;; "texlive-hyphen-indic"
               ;; "texlive-hyphen-indonesian"
               ;; "texlive-hyphen-interlingua"
               ;; "texlive-hyphen-irish"
               ;; "texlive-hyphen-italian"
               ;; "texlive-hyphen-kurmanji"
               ;; "texlive-hyphen-latin"
               ;; "texlive-hyphen-latvian"
               ;; "texlive-hyphen-lithuanian"
               ;; "texlive-hyphen-macedonian"
               ;; "texlive-hyphen-mongolian"
               ;; "texlive-hyphen-norwegian"
               ;; "texlive-hyphen-occitan"
               ;; "texlive-hyphen-pali"
               ;; "texlive-hyphen-piedmontese"
               ;; "texlive-hyphen-polish"
               ;; "texlive-hyphen-portuguese"
               ;; "texlive-hyphen-romanian"
               ;; "texlive-hyphen-romansh"
               ;; "texlive-hyphen-russian"
               ;; "texlive-hyphen-sanskrit"
               ;; "texlive-hyphen-schoolfinnish"
               ;; "texlive-hyphen-serbian"
               ;; "texlive-hyphen-slovak"
               ;; "texlive-hyphen-slovenian"
               ;; "texlive-hyphen-spanish"
               ;; "texlive-hyphen-swedish"
               ;; "texlive-hyphen-thai"
               ;; "texlive-hyphen-turkish"
               ;; "texlive-hyphen-turkmen"
               ;; "texlive-hyphen-ukrainian"
               ;; "texlive-hyphen-uppersorbian"
               ;; "texlive-hyphen-welsh"
               ;; "texlive-ifmtarg"
               ;; "texlive-ifoddpage"
               ;; "texlive-inconsolata"
               ;; "texlive-inputenx"
               ;; "texlive-jadetex"
               ;; "texlive-jknappen"
               ;; "texlive-kastrup"
               ;; "texlive-knuth-lib"
               ;; "texlive-kpathsea"
               ;; "texlive-kpfonts"
               ;; "texlive-l3build"
               ;; "texlive-latex-acmart"
               ;; "texlive-latex-acronym"
               ;; "texlive-latex-amsmath"
               ;; "texlive-latex-amsrefs"
               ;; "texlive-latex-anysize"
               ;; "texlive-latex-appendix"
               ;; "texlive-latex-atveryend"
               ;; "texlive-latex-auxhook"
               ;; "texlive-latex-base"
               ;; "texlive-latex-bigfoot"
               ;; "texlive-latex-blindtext"
               ;; "texlive-latex-bookmark"
               ;; "texlive-latex-bussproofs"
               ;; "texlive-latex-changebar"
               ;; "texlive-latex-changepage"
               ;; "texlive-latex-cmap"
               ;; "texlive-latex-colortbl"
               ;; "texlive-latex-cyrillic"
               ;; "texlive-latex-dinbrief"
               ;; "texlive-latex-draftwatermark"
               ;; "texlive-latex-ebproof"
               ;; "texlive-latex-eepic"
               ;; "texlive-latex-environ"
               ;; "texlive-latex-epstopdf-pkg"
               ;; "texlive-latex-eqparbox"
               ;; "texlive-latex-eso-pic"
               ;; "texlive-latex-etoc"
               ;; "texlive-latex-eukdate"
               ;; "texlive-latex-examplep"
               ;; "texlive-latex-expdlist"
               ;; "texlive-latex-fancybox"
               ;; "texlive-latex-fancyhdr"
               ;; "texlive-latex-fancyvrb"
               ;; "texlive-latex-filecontents"
               ;; "texlive-latex-float"
               ;; "texlive-latex-fncychap"
               ;; "texlive-latex-footmisc"
               ;; "texlive-latex-framed"
               ;; "texlive-latex-g-brief"
               ;; "texlive-latex-galois"
               ;; "texlive-latex-gcite"
               ;; "texlive-latex-geometry"
               ;; "texlive-latex-graphics"
               ;; "texlive-latex-hanging"
               ;; "texlive-latex-hycolor"
               ;; "texlive-latex-ifplatform"
               ;; "texlive-latex-jknapltx"
               ;; "texlive-latex-koma-script"
               ;; "texlive-latex-kvoptions"
               ;; "texlive-latex-l3backend"
               ;; "texlive-latex-l3kernel"
               ;; "texlive-latex-l3packages"
               ;; "texlive-latex-letltxmacro"
               ;; "texlive-listings"
               ;; "texlive-latex-mdwtools"
               ;; "texlive-latex-media9"
               ;; "texlive-latex-ms"
               ;; "texlive-latex-multirow"
               ;; "texlive-latex-natbib"
               ;; "texlive-latex-needspace"
               ;; "texlive-latex-newunicodechar"
               ;; "texlive-latex-ocgx2"
               ;; "texlive-latex-overpic"
               ;; "texlive-latex-parskip"
               ;; "texlive-latex-pdfpages"
               ;; "texlive-latex-pdftexcmds"
               ;; "texlive-pgf"
               ;; "texlive-latex-polyglossia"
               ;; "texlive-latex-preview"
               ;; "texlive-latex-psfrag"
               ;; "texlive-latex-readarray"
               ;; "texlive-latex-refcount"
               ;; "texlive-latex-rerunfilecheck"
               ;; "texlive-latex-stackengine"
               ;; "texlive-latex-subfigure"
               ;; "texlive-latex-supertabular"
               ;; "texlive-latex-tabulary"
               ;; "texlive-latex-textpos"
               ;; "texlive-latex-threeparttable"
               ;; "texlive-latex-titlesec"
               ;; "texlive-latex-tocloft"
               ;; "texlive-latex-tools"
               ;; "texlive-latex-trimspaces"
               ;; "texlive-latex-type1cm"
               ;; "texlive-latex-ucs"
               ;; "texlive-latex-upquote"
               ;; "texlive-latex-varwidth"
               ;; "texlive-latex-verbatimbox"
               ;; "texlive-wrapfig"
               ;; "texlive-latex-xkeyval"
               ;; "texlive-latex-xmpincl"
               ;; "texlive-latexconfig"
               ;; "texlive-lh"
               ;; "texlive-libertine"
               ;; "texlive-libkpathsea"
               ;; "texlive-lm"
               ;; "texlive-logreq"
               ;; "texlive-lua-alt-getopt"
               ;; "texlive-lualibs"
               ;; "texlive-luaotfload"
               ;; "texlive-ly1"
               ;; "texlive-marginnote"
               ;; "texlive-marvosym"
               ;; "texlive-mathdesign"
               ;; "texlive-mathpazo"
               ;; "texlive-metafont"
               ;; "texlive-metapost"
               ;; "texlive-mflogo"
               ;; "texlive-mflogo-font"
               ;; "texlive-microtype"
               ;; "texlive-mkpattern"
               ;; "texlive-morefloats"
               ;; "texlive-mweights"
               ;; "texlive-newtx"
               ;; "texlive-numprint"
               ;; "texlive-oberdiek"
               ;; "texlive-pagenote"
               ;; "texlive-palatino"
               ;; "texlive-pdftex"
               ;; "texlive-pdfx"
               ;; "texlive-preprint"
               ;; "texlive-psnfss"
               ;; "texlive-psnfss-fixed"
               ;; "texlive-pst-text"
               ;; "texlive-pstool"
               ;; "texlive-pstricks"
               ;; "texlive-ruhyphen"
               ;; "texlive-sectsty"
               ;; "texlive-seminar"
               ;; "texlive-siunitx"
               ;; "texlive-standalone"
               ;; "texlive-stmaryrd"
               ;; "texlive-stmaryrd-fixed"
               ;; "texlive-storebox"
               ;; "texlive-stringenc"
               ;; "texlive-symbol"
               ;; "texlive-tabu"
               ;; "texlive-tcolorbox"
               ;; "texlive-tetex"
               ;; "texlive-tex-gyre"
               ;; "texlive-tex-ini-files"
               ;; "texlive-tex-plain"
               ;; "texlive-tex-texinfo"
               ;; "texlive-textcase"
               ;; "texlive-times"
               ;; "texlive-tiny"
               ;; "texlive-tipa"
               ;; "texlive-titling"
               ;; "texlive-todonotes"
               ;; "texlive-tools"
               ;; "texlive-translator"
               ;; "texlive-txfonts"
               ;; "texlive-ukrhyph"
               ;; "texlive-ulem"
               ;; "texlive-unicode-data"
               ;; "texlive-units"
               ;; "texlive-url"
               ;; "texlive-utopia"
               ;; "texlive-varwidth"
               ;; "texlive-wasy"
               ;; "texlive-wasysym"
               ;; "texlive-xcharter"
               ;; "texlive-xcolor"
               ;; "texlive-xifthen"
               ;; "texlive-xmltex"
               ;; "texlive-xypic"
               ;; "texlive-ydoc"
               ;; "texlive-zapfding"
               "timidity++"
               "tintin++"
               "tree"
               "uxn"
               ;; "virt-manager"
               "wesnoth"
               "wireshark"
               "wordnet"
               "xdpyprobe"
               "xmp"
               "yewscion-scripts"
               "zig"
               "zenity")))
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
                  ("daily-update-guix" . "guix pull && guix home reconfigure $HOME/Documents/guix-home/home-configuration.scm && guix gc")))
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
              (package bash))))))
