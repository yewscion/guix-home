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
 (gnu packages code)
 (gnu packages curl)
 (gnu packages emacs-xyz))
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
(define my-shell-options
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
(define my-nvm-setup
  (string-append
   " # NVM Setup \n"
   "NVM_DIR=$HOME/.config/nvm\n"
   "[ -s \"$NVM_DIR/nvm.sh\" ] && source \"$NVM_DIR/nvm.sh\"\n"
   "[ -s \"$NVM_DIR/bash_completion\" ] && "
   "source \"$NVM_DIR/bash_completion\"\n"))
(define my-bashrc
  (string-append my-shell-options ""))
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
  "nm-switch \\\"Codys Corner\\\"")
(define my-guix-home-reconfigure
  "guix home reconfigure \\$HOME/Documents/guix-home/home-configuration.scm")
(define my-function-log-guix-state
  (string-append "log-guix-state() {\n"
                 "    guix describe -f human \| sed -n \"1p\"\n"
                 "    guix describe -f channels\n"
                 "    guix package --export-manifest -p \"\\$GUIX_PROFILE\"\n"
                 "    guix package --list-generations -p \"\\$GUIX_PROFILE\"\n}\n"))
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
                 "        export PS1=\"$ \"\n"
                 "        ;;\n"
                 "    \"tramp\")\n"
                 "        export PS1=\"$ \"\n"
                 "        ;;\n"
                 "    xterm*|rxvt*|eterm*|screen*)\n"
                 "        tty -s && export PS1=\""
                 my-ps1-prompt
                 "\"\n"
                 "        ;;\n"
                 "esac\n"))
;;; Grouping Packages By Type


(define my-packages
  '("adlmidi" "alsa-plugins" "alsa-plugins:pulseaudio" "ant" "ant-junit"
  "apl" "autoconf" "automake" "b3sum" "bash" "beets" "biber" "borg"
  "brightnessctl" "bsd-games" "btrfs-progs" "carp" "chez-scheme"
  "chez-scheme:doc" "cl-asdf" "clang-toolchain" "clisp" "clojure"
  "codechallenge-solutions" "coreutils" "curl" "dfc" "dmidecode" "docker"
  "dosfstools" "efibootmgr" "elm" "emacs" "emacs-alert" "emacs-anaphora"
  "emacs-async" "emacs-auctex" "emacs-biblio" "emacs-bui" "emacs-cider"
  "emacs-citar" "emacs-citeproc-el" "emacs-clojure-mode" "emacs-company"
  "emacs-company-lsp" "emacs-company-math" "emacs-company-quickhelp"
  "emacs-csv" "emacs-csv-mode" "emacs-daemons" "emacs-dash"
  "emacs-datetime" "emacs-debbugs" "emacs-deft" "emacs-dictionary"
  "emacs-diff-hl" "emacs-disable-mouse" "emacs-docker"
  "emacs-docker-compose-mode" "emacs-docker-tramp" "emacs-dockerfile-mode"
  "emacs-download-region" "emacs-ebib" "emacs-ediprolog"
  "emacs-edit-indirect" "emacs-edn" "emacs-eldoc" "emacs-elf-mode"
  "emacs-elfeed" "emacs-elfeed-protocol" "emacs-elisp-docstring-mode"
  "emacs-elisp-refs" "emacs-elisp-slime-nav" "emacs-elm-mode"
  "emacs-elpher" "emacs-elpy" "emacs-emacsql" "emacs-emacsql-sqlite3"
  "emacs-emms" "emacs-emms-mode-line-cycle" "emacs-emojify" "emacs-eprime"
  "emacs-erc-hl-nicks" "emacs-eshell-did-you-mean"
  "emacs-eshell-syntax-highlighting" "emacs-esup" "emacs-esxml"
  "emacs-eterm-256color" "emacs-eww-lnum" "emacs-exiftool" "emacs-f"
  "emacs-fennel-mode" "emacs-ffap-rfc-space" "emacs-fill-column-indicator"
  "emacs-flycheck" "emacs-flycheck-elm" "emacs-flycheck-guile"
  "emacs-fountain-mode" "emacs-geiser" "emacs-geiser-chez"
  "emacs-geiser-gauche" "emacs-geiser-guile" "emacs-gif-screencast"
  "emacs-git-modes" "emacs-graphviz-dot-mode" "emacs-guix" "emacs-ht"
  "emacs-html-to-hiccup" "emacs-htmlize" "emacs-hy-mode" "emacs-hyperbole"
  "emacs-iedit" "emacs-inf-janet" "emacs-inf-ruby" "emacs-janet-mode"
  "emacs-jinja2-mode" "emacs-json-mode" "emacs-json-snatcher"
  "emacs-jsonnet-mode" "emacs-keycast" "emacs-know-your-http-well"
  "emacs-kv" "emacs-libmpdel" "emacs-lisp-extra-font-lock"
  "emacs-list-utils" "emacs-log4e" "emacs-logview" "emacs-lorem-ipsum"
  "emacs-lsp-java" "emacs-lsp-lua-emmy" "emacs-lsp-mode" "emacs-lsp-ui"
  "emacs-lua-mode" "emacs-macrostep" "emacs-magit" "emacs-magit-annex"
  "emacs-magit-popup" "emacs-make-it-so" "emacs-marginalia"
  "emacs-markdown-mode" "emacs-markdown-preview-mode" "emacs-mastodon"
  "emacs-memoize" "emacs-mpdel" "emacs-nasm-mode" "emacs-nginx-mode"
  "emacs-nhexl-mode" "emacs-nodejs-repl" "emacs-nov-el" "emacs-npm-mode"
  "emacs-oauth2" "emacs-ob-async" "emacs-org" "emacs-org-contrib"
  "emacs-org-download" "emacs-org-drill" "emacs-org-drill-table"
  "emacs-org-emms" "emacs-org-journal" "emacs-org-mime" "emacs-org-msg"
  "emacs-org-noter" "emacs-org-pandoc-import" "emacs-org-pomodoro"
  "emacs-org-present" "emacs-org-vcard" "emacs-ox-epub" "emacs-ox-gemini"
  "emacs-ox-gfm" "emacs-paredit" "emacs-parsebib" "emacs-parseclj"
  "emacs-parseedn" "emacs-pass" "emacs-password-store"
  "emacs-password-store-otp" "emacs-pcre2el" "emacs-pdf-tools" "emacs-peg"
  "emacs-php-mode" "emacs-picpocket" "emacs-pinentry" "emacs-pkg-info"
  "emacs-plantuml-mode" "emacs-popup" "emacs-pos-tip" "emacs-powershell"
  "emacs-projectile" "emacs-pulseaudio-control" "emacs-queue"
  "emacs-rec-mode" "emacs-request" "emacs-restclient" "emacs-rfcview"
  "emacs-rjsx-mode" "emacs-robe" "emacs-roguel-ike" "emacs-rpm-spec-mode"
  "emacs-s" "emacs-saveplace-pdf-view" "emacs-shell-command+"
  "emacs-simple-httpd" "emacs-simple-mpc" "emacs-skewer-mode" "emacs-slime"
  "emacs-slime-company" "emacs-slime-repl-ansi-color" "emacs-spark"
  "emacs-sqlite" "emacs-srfi" "emacs-ssh-config-mode" "emacs-strace-mode"
  "emacs-stream" "emacs-stripe-buffer" "emacs-stumpwm-mode"
  "emacs-sudo-edit" "emacs-svg-icon" "emacs-svg-lib" "emacs-svg-tag-mode"
  "emacs-sx" "emacs-systemd-mode" "emacs-tablist" "emacs-tagedit"
  "emacs-tco-el" "emacs-tide" "emacs-toml-mode" "emacs-transient"
  "emacs-transmission" "emacs-treepy" "emacs-ts" "emacs-typescript-mode"
  "emacs-typing" "emacs-typit" "emacs-uml-mode" "emacs-unfill"
  "emacs-validate" "emacs-validate-html" "emacs-visual-fill-column"
  "emacs-visual-regexp" "emacs-vterm" "emacs-vterm-toggle" "emacs-wc-mode"
  "emacs-web-beautify" "emacs-web-server" "emacs-websocket" "emacs-wget"
  "emacs-which-key" "emacs-wisp-mode" "emacs-with-editor" "emacs-wordgen"
  "emacs-writegood-mode" "emacs-writeroom" "emacs-xmlgen" "emacs-xpm"
  "emacs-xterm-color" "emacs-yaml" "emacs-yaml-mode" "emacspeak"
  "endless-sky" "erofs-utils" "esbuild" "espeak-ng" "exa" "exempi"
  "exfat-utils" "exfatprogs" "expect" "extundelete" "fennel" "file"
  "filters" "fluid-3" "fluidsynth" "fnlfmt" "font-gnu-freefont"
  "font-gnu-unifont" "font-tex-gyre" "gambit-c" "gash" "gauche"
  "gcc-toolchain" "genpro" "gerbil" "ghostscript" "gifsicle" "gimp" "git"
  "git:send-email" "glibc-locales" "gnupg" "gnurobots" "gparted" "graphviz"
  "grep" "guildhall" "guile" "guile-bash" "guile-cdr255" "guile-chickadee"
  "guile-colorized" "guile-git" "guile-goblins" "guile-hall"
  "guile-ncurses" "guile-readline" "guile-sqlite3" "guile-ssh" "gv" "haunt"
  "httrack" "icecat" "inkscape" "innoextract" "ispell" "janet" "java-bsh"
  "java-junit" "java-log4j-core" "jpegoptim" "kawa" "knock" "le-certs"
  "libreoffice" "libvirt" "links" "lxc" "make" "mc" "milkytracker" "mono"
  "mpv" "msmtp" "mu" "my-frotz" "nasm" "ncdu" "ncurses" "netcat" "nethack"
  "newlisp" "newt" "nmap" "node" "nomad" "nss-certs" "offlineimap3"
  "openjdk:doc" "openjdk:jdk" "orca-music" "owl-lisp" "pagr"
  "password-store" "patchelf" "patchelf-wrapper" "pavucontrol" "perl"
  "perl-image-exiftool" "picolisp" "pinentry-emacs" "pkg-config" "plantuml"
  "poppler" "portmidi" "postgresql" "python" "python-lsp-server"
  "python-pygments" "python-pygments-lexer-pseudocode-std" "qemu" "ripgrep"
  "rsync" "ruby" "ruby-kramdown" "rxvt-unicode" "sbcl" "sbcl-esrap" "sbcl-ironclad"
  "sbcl-stumpwm-battery-portable" "sbcl-stumpwm-notify"
  "sbcl-stumpwm-screenshot" "sbcl-zpng" "scheme-primer" "sed" "sedsed"
  "setxkbmap" "shellcheck" "shepherd" "sshfs" "sshpass" "stumpish" "stumpwm"
  "stumpwm:lib" "swi-prolog" "talkfilters" "telescope" "texinfo"
  "texlive-babel-russian" "texlive-biblatex" "texlive-biblatex-apa"
  "texlive-booktabs" "texlive-capt-of" "texlive-csquotes" "texlive-doi"
  "texlive-enumitem" "texlive-etoolbox" "texlive-fontspec"
  "texlive-generic-etexcmds" "texlive-generic-gettitlestring"
  "texlive-generic-ifptex" "texlive-generic-iftex"
  "texlive-generic-xstring" "texlive-hyperref" "texlive-ifmtarg"
  "texlive-kpathsea" "texlive-kpfonts" "texlive-latex-appendix"
  "texlive-latex-catchfile" "texlive-latex-cleveref"
  "texlive-latex-comment" "texlive-latex-datetime2"
  "texlive-latex-datetime2-english" "texlive-latex-endfloat"
  "texlive-latex-environ" "texlive-latex-everyhook"
  "texlive-latex-fancyhdr" "texlive-latex-fancyvrb" "texlive-latex-float"
  "texlive-latex-framed" "texlive-latex-fvextra" "texlive-latex-geometry"
  "texlive-latex-ifplatform" "texlive-latex-kvoptions"
  "texlive-latex-letltxmacro" "texlive-latex-lineno" "texlive-latex-lipsum"
  "texlive-latex-lwarp" "texlive-latex-memoir" "texlive-latex-minted"
  "texlive-latex-newfloat" "texlive-latex-newunicodechar"
  "texlive-latex-pdftexcmds" "texlive-latex-printlen"
  "texlive-latex-readablecv" "texlive-latex-refcount"
  "texlive-latex-setspace" "texlive-latex-titlesec"
  "texlive-latex-trimspaces" "texlive-latex-upquote"
  "texlive-latex-venndiagram" "texlive-latex-xkeyval"
  "texlive-latex-xpatch" "texlive-libkpathsea" "texlive-listings"
  "texlive-lm" "texlive-luaotfload" "texlive-metapost" "texlive-pdfx"
  "texlive-pgf" "texlive-stringenc" "texlive-svn-prov" "texlive-tex-gyre"
  "texlive-tracklang" "texlive-txfonts" "texlive-varwidth" "texlive-xcolor"
  "texlive-xifthen" "texmacs" "the-silver-searcher" "timidity++" "tintin++"
  "transmission" "tree" "universal-ctags" "unzip" "uxn" "virt-manager"
  "virt-viewer" "vlang" "wesnoth" "which" "wordnet" "xapian" "xboard"
  "xdg-utils" "xdotool" "xdpyprobe" "xindy" "xmp" "xrdb" "yewscion-scripts"
  "yt-dlp" "zenity" "zutils"))
(define
  my-no-test-packages
  '(
;   curl
;   emacs-parsebib
;   emacs-ebib
;   emacs-citar
;   emacs-org-ref
   ))
(define my-transformation
  (options->transformation
   '(
     ;(without-tests . "curl")
     ;(with-commit . "emacs-parsebib=185239020f878cfbe1036270e6c3d1026ba8f255")
     )))

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
(define my-transformed-packages
  (map my-transformation
       my-no-test-packages))
(define my-spec-list (append
                      '()
                      my-packages))
(define my-package-list
  (append my-transformed-packages
          (map (compose list specification->package+output) my-spec-list)))
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
             ("nm-codys-corner" . ,my-nm-codys-corner)
             ("ghr" . ,my-guix-home-reconfigure)))
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
	     ("CLASSPATH" . "$GUIX_PROFILE/share/java")
             ("NVM_DIR" . "$HOME/.config/nvm")))
          (guix-defaults? #t)
          (package bash)))
        (simple-service 'my-extensions
                        home-bash-service-type
                        (home-bash-extension
                         (bash-profile
                          (list (plain-file "my-bash-profile-ext"
                                            (string-append
                                             my-nvm-setup))))))
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
