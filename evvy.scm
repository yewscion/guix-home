;;; evvy.scm
;;;
;;; This is the system-config file for Evvy, my MNT Reform Laptop.
;;;
;;; Author: Christopher Rodriguez
;;; Created: 2022-04-10
;;; Last Released: 2022-04-28
;;; Contact: yewscion@gmail.com
;;;
(use-service-modules desktop networking ssh xorg databases cuirass mcron)
(use-modules (gnu)
             (srfi srfi-1)
             (ice-9 textual-ports)
             (guix modules))
(use-service-modules admin
		     certbot
		     desktop
		     docker
		     games
		     mail
		     mcron
		     web
                     avahi
                     base
                     cuirass
                     networking
                     networking
                     ssh
                     virtualization)
(use-package-modules games
		     xdisorg
                     admin
                     certs
                     databases
                     emacs
                     package-management
                     ssh
                     tls
                     version-control)

(define %ming-profile-pkgs
  (list "adb" "adlmidi" "alsa-plugins" "ardour"
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
(define %ming-pubkey
  (plain-file "ming_id.pub" "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDvbir/LAxFP2O7WPCxX2BL5YIbb4yTPbnmJlooQaM7H5L0DxWAC0/3Q+XXqb6xDGrHmoJHTp3YHD30W1JNWQiKtKuEKgYzYypiTWHU2MbZ4ahuQN7v2Bc1KM720MFaHKjDd8rurTya3cOd6PTXOKyhZIMjt1H6OgwYULX92oaYGVdEn+ebSlR3xaSMyPXSJ5yPAWcZlHYrQysz7b2KtulTRvsaE0gq3muCxFdIXqAlbAcCPScLoDWygEDMLSKN/gjV+4b453oiG21KnmKMhkbczu9YpbUdB46lLH6eb6twe+CNcaDZl/TNIA55l7UtaM9GMxesCQXIsTg0sFV9PZW2zpI4i8/6vpAqr++t/1TQVOZjvxxv+5UWMbKVPJqawIXonOaN1Iz9svDuacMij2cBnyNxcBq5BsOjHO6ch2IYnflapFsePfysve5Z3UVVOJJeCanp+nSGSrwDOckreVWnU8G2D0MuV5HNMNaghoI72uBVi5s3GmH2utl0RSh/x81byQ8iyb6g8m2XiwwoxDGDu6sePVJOJ9iEUYmLWX4TcA4CVLhdFqD1R/9/VE7w+RgvFmzNrufxZEaP3dXJVdIctyeCntGl9eZreVc65GpHesIANJj/cDmeNPk8vyfPJpwHgLAZpGY4NgbR8hXFnyrZRd+XcTvpkZcJc51OKo7kOQ== "))

(define %cuirass-specs
  #~(list (specification
           (name "yewscion")
           (build '(channels yewscion))
           (systems  '("x86_64-linux" "armhf-linux"))
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
           (systems '("x86_64-linux"))
           (priority 3)
           (channels
            (cons (channel
                   (name 'yewscion)
                   (url "https://git.sr.ht/~yewscion/yewscion-guix-channel")
                   (branch "trunk"))
                  %default-channels)))))
(define updatedb-job
  ;; Run 'updatedb' at 3AM every day.  Here we write the
  ;; job's action as a Scheme procedure.
  #~(job '(next-hour '(3))
         (lambda ()
           (execl (string-append #$findutils "/bin/updatedb")
                  "updatedb"
                  "--prunepaths=/tmp /var/tmp /gnu/store"))))
(operating-system
 (locale "en_US.utf8")
 (timezone "America/New_York")
 (keyboard-layout (keyboard-layout "us,apl" #:options '("ctrl:swapcaps_hyper" "compose:rctrl" "grp:shifts_toggle")))
 (host-name "evvy")
 (users (cons* (user-account
                (name "ming")
                (comment "Christopher Rodriguez")
                (group "users")
                (home-directory "/home/ming")
                (supplementary-groups
                 '("wheel" "netdev" "audio" "video" "docker")))
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
 (file-systems (cons (file-system
                      (device "/dev/sda")
                      (mount-point "/")
                      (type "ext4"))
                     %base-file-systems))
 (packages
  (append
   (map (compose list specification->package+output)
        (list "nss-certs"
              "xorg-server-xwayland"
              "emacs-next"
              "openssh"
              "rxvt-unicode"
              "git"
              "icedtea:jdk"))
   %base-packages))
 (services
  (append
   (list
    (service avahi-service-type)
    (service gnome-desktop-service-type)
    (service mate-desktop-service-type)
    (service openssh-service-type
             (openssh-configuration
              (password-authentication? #f)
              (authorized-keys
               `(("ming" ,%ming-pubkey)
                 ("git" ,%ming-pubkey)))))
    (service postgresql-service-type
             (postgresql-configuration
              (postgresql postgresql-10)))
    (service cuirass-service-type
             (cuirass-configuration
              (specifications %cuirass-specs)
              (host "0.0.0.0")))
    (service guix-publish-service-type
             (guix-publish-configuration
              (host "0.0.0.0")
              (advertise? #t)))
    (service gmnisrv-service-type)
    (service wesnothd-service-type)
    (service docker-service-type)
    (service qemu-binfmt-service-type
             (qemu-binfmt-configuration
              (platforms (lookup-qemu-platforms "arm" "aarch64" "risc-v"))))
    (elogind-service)
    (simple-service 'my-cron-jobs
		    mcron-service-type
		    (list updatedb-job))
    (set-xorg-configuration
     (xorg-configuration
      (keyboard-layout keyboard-layout))))
   %desktop-services))



 ;;  (service gnome-desktop-service-type)
 ;; 	  (service slim-service-type (slim-configuration
 ;; 				      (display ":0")
 ;; 				      (vt "vt7")
 ;; 				      (xorg-configuration
 ;; 				       (keyboard-layout keyboard-layout))))
 ;; 	  (service openssh-service-type))
 ;;(modify-services %desktop-services
 ;;		   (delete gdm-service-type))))
 (bootloader
  (bootloader-configuration
   (bootloader grub-efi-bootloader)
   (target "/boot/efi")
   (keyboard-layout keyboard-layout)))
 (swap-devices
  (list (uuid "e8ea5677-338f-40c5-86c9-36c54293c223")))
 (file-systems
  (cons* (file-system
          (mount-point "/boot/efi")
          (device (uuid "F393-3E81" 'fat32))
          (type "vfat"))
         (file-system
          (mount-point "/")
          (device
           (uuid "8d09815c-2531-4e52-b3b8-b2dc3c247d73"
                 'ext4))
          (type "ext4"))
         (file-system
          (mount-point "/home")
          (device
           (uuid "a86a24cc-e095-4f39-9a83-f4216f2c1b78"
                 'ext4))
          (type "ext4"))
         %base-file-systems)))
