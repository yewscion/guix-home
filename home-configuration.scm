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
 (guix utils)
 (gnu packages code)
 (gnu packages curl)
 (gnu packages gtk)
 (gnu packages fcitx5)
 (gnu packages emacs-xyz))
;;; Thanks to lizog and their friend for this procedure, which is needed to
;;; regenerate the gtk-immodule-cache for fcitx5.
(define (generate-gtk-immodule-cache gtk gtk-version . extra-pkgs)
  (define major+minor (version-major+minor gtk-version))

  (define build
    (with-imported-modules '((guix build utils)
                             (guix build union)
                             (guix build profiles)
                             (guix search-paths)
                             (guix records))
      #~(begin
          (use-modules (guix build utils)
                       (guix build union)
                       (guix build profiles)
                       (ice-9 popen)
                       (srfi srfi-1)
                       (srfi srfi-26))

          (define (immodules-dir pkg)
            (format #f "~a/lib/gtk-~a/~a/immodules"
                    pkg #$major+minor #$gtk-version))

          (let* ((moddirs (filter file-exists?
                                  (map immodules-dir
                                       (list #$gtk #$@extra-pkgs))))
                 (modules (append-map (cut find-files <> "\\.so$")
                                      moddirs))
                 (query (format #f "~a/bin/gtk-query-immodules-~a"
                                #$gtk:bin #$major+minor))
                 (pipe (apply open-pipe* OPEN_READ query modules)))

            ;; Generate a new immodules cache file.
            (dynamic-wind
              (const #t)
              (lambda ()
                (call-with-output-file #$output
                  (lambda (out)
                    (while (not (eof-object? (peek-char pipe)))
                      (write-char (read-char pipe) out))))
                #t)
              (lambda ()
                (close-pipe pipe)))))))

  (computed-file (string-append "gtk-query-immodules-" major+minor) build))

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
(define my-guix-build-local
  "guix build -L \\$HOME/Documents/yewscion-guix-channel/ -v4 -K")
(define my-guix-build-for-aarch64
  "guix build -v4 -K --target=aarch64-linux-gnu")
(define my-guix-fetch-sources
  "guix build -v4 --source --no-substitutes")
(define my-function-log-guix-state
  (string-append "log-guix-state() {\n"
                 "    guix describe -f human \| sed -n \"1p\"\n"
                 "    guix describe -f channels\n"
                 "    guix package --export-manifest -p \"${GUIX_PROFILE}\"\n"
                 "    guix package --list-generations -p "
                 "\"${GUIX_PROFILE}\"\n}\n"))
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
(define my-init-project
  (string-append "cp -LRv --no-preserve=all ~/.local/share/empty-repo/. .;"
                 "chmod 775 setup-symlinks.sh bootstrap incant.sh cast.sh;"
                 " ./setup-symlinks.sh"))
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
(load "emacs-packages.scm")
(load "texlive-packages.scm")
(define my-other-packages
  '("libadlmidi" "agda" "alsa-plugins" "alsa-plugins:pulseaudio" "anki"
  "ant" "ant-junit" "gnu-apl" "apl-primer" "autoconf" "automake" "b3sum"
  "bash" "beets" "biber" "bison" "borg" "brightnessctl" "bsd-games"
  "btrfs-progs" "carp" "cbqn" "cl-asdf" "clisp" "clojure"
  "codechallenge-solutions" "coreutils" "curl" "dbqn" "dfc" "dmidecode"
  "docker" "dosfstools" "efibootmgr" "elm" "endless-sky" "erlang"
  "erofs-utils" "esbuild" "espeak-ng" "exa" "exempi" "exfat-utils"
  "exfatprogs" "expect" "extundelete" "fcitx5" "fcitx5-anthy"
  "fcitx5-chinese-addons" "fcitx5-configtool" "fcitx5-gtk"
  "fcitx5-gtk:gtk2" "fcitx5-gtk:gtk3" "fcitx5-gtk4" "fcitx5-lua"
  "fcitx5-material-color-theme" "fcitx5-qt" "fcitx5-rime" "fennel" "ffmpeg"
  "file" "flex" "fluid-3" "fluidsynth" "font-3270" "font-bqn386"
  "font-gnu-freefont" "font-openmoji" "font-google-noto" "font-gnu-unifont"
  "font-gnu-unifont:pcf" "font-gnu-unifont:psf" "font-gnu-unifont:bin"
  "font-terminus" "fontforge" "font-tex-gyre" "gambit-c" "gash" "gauche"
  "gcc-toolchain" "genpro" "gerbil" "gfortran-toolchain" "ghc" "ghc-alex"
  "ghc-bnfc" "ghc-happy" "ghostscript" "gifsicle" "gimp" "git"
  "git:send-email" "git-filter-repo" "glibc-locales" "gnupg" "gnuplot"
  "gnurobots" "gparted" "graphviz" "grep" "groovy" "guildhall" "guile"
  "guile-bash" "guile-cdr255" "guile-chickadee" "guile-colorized"
  "guile-git" "guile-goblins" "guile-hall" "guile-ncurses" "guile-readline"
  "guile-sqlite3" "guile-ssh" "gtk+:bin" "gv" "gwl" "haunt" "htop"
  "httrack" "icecat" "imagemagick" "inkscape" "innoextract" "ispell"
  "janet" "java-bsh" "java-bigdecimal-math" "java-cglib" "java-guice"
  "java-junit" "java-log4j-core" "jpegoptim" "kawa" "knock" "le-certs"
  "libreoffice" "libvirt" "links" "lxc" "make" "mc" "milkytracker" "maven"
  "mpv" "msmtp" "mu" "my-frotz" "nasm" "ncdu" "ncurses" "netcat" "nethack"
  "newlisp" "newt" "nmap" "node" "nss-certs" "offlineimap3"
  "openjdk:doc" "openjdk:jdk" "optipng" "orca-music" "owl-lisp" "p7zip" ;; openjdk@15:jdk
                                                                        ;; allowed
                                                                        ;; installation
                                                                        ;; of
                                                                        ;; lsps.
  "pagr" "pamixer" "password-store" "patchelf" "patchelf-wrapper"
  "pavucontrol" "perl" "perl-image-exiftool" "picolisp" "pinentry-emacs"
  "pioneer" "pkg-config" "plantuml" "poppler" "portmidi" "postgresql"
  "pseudotaxus" "pseudotaxus-emacs" "pseudotaxus-grove" "pulseaudio"
  "python" "python-css-html-js-minify" "python-lsp-server"
  "python-pygments" "python-pygments-pseudotaxus" "qemu" "rebar3" "restic"
  "ripgrep" "rlwrap" "rsync" "ruby" "ruby-kramdown" "rxvt-unicode" "sbcl"
  "sbcl-deploy" "sbcl-esrap" "sbcl-ironclad"
  "sbcl-stumpwm-battery-portable" "sbcl-stumpwm-notify"
  "sbcl-stumpwm-screenshot" "sbcl-zpng" "scheme-primer" "screen" "sdl2"
  "sed" "sedsed" "setxkbmap" "sfarklib" "shellcheck" "shepherd" "shotwell"
  "signing-party" "sshfs" "sshpass" "stumpish" "stumpwm" "stumpwm:lib"
  "swi-prolog" "talkfilters" "telescope" "texinfo" "texmacs"
  "the-silver-searcher" "timidity++" "tintin++" "transmission" "trash-cli"
  "tree" "universal-ctags" "unzip" "uxn" "virt-manager" "virt-viewer"
  "vlang" "wesnoth" "which" "wine64-staging" "wordnet" "xapian" "xboard"
  "xdg-utils" "xdotool" "xdpyprobe" "xindy" "xfontsel" "xkeyboard-config"
  "xmp" "xorriso" "xprop" "xrdb" "yewscion-scripts" "yt-dlp" "zenity"
  "zutils"))

; Graveyard: "nomad"

(define my-packages
  (append my-other-packages my-emacs-packages my-texlive-packages))

(define
  my-no-test-packages
  '(;curl
    ;emacs-parsebib
    ;emacs-ebib
    ;emacs-citar
    ;emacs-org-ref
    ))
(define my-transformation
  (options->transformation
   '(
     ;; (without-tests . "curl")
     ;; (with-commit
     ;;  .
     ;;  "emacs-parsebib=185239020f878cfbe1036270e6c3d1026ba8f255")
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
             ("ghr" . ,my-guix-home-reconfigure)
             ("gbl" . ,my-guix-build-local)
             ("gbfa" . ,my-guix-build-for-aarch64)
             ("gfs" . ,my-guix-fetch-sources)
             ("initialize-project" . ,my-init-project)))
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
           `(("SHELL" . "bash")
             ("HISTCONTROL" . "ignoreboth")
             ("HISTTIMEFORMAT" . "true")
             ("PATH" . "$HOME/.local/bin:$PATH:$HOME/.local/npm/bin")
             ("EDITOR" . "emacsclient")
             ("TEXMFCACHE" . "$HOME/.local/share/texmf-dist")
	     ("CLASSPATH" . "$GUIX_PROFILE/share/java")
             ("NVM_DIR" . "$HOME/.config/nvm")
             ("CARP_DIR" . "$GUIX_PROFILE/share/carp")
             ("APL_LIB_ROOT" . "$HOME/Documents/apl-libs")
             ("PYTHONPYCACHEPREFIX" . "/tmp")
             ("GTK_IM_MODULE" . "fcitx")
             ("QT_IM_MODULE" . "fcitx")
             ("XMODIFIERS" . "@im=fcitx")
             ("SDL_IM_MODULE" . "fcitx")
             ("GLFW_IM_MODULE" . "ibus")
             ("GUIX_GTK3_IM_MODULE_FILE" .
              ,(generate-gtk-immodule-cache
                gtk+
                "3.24.30"
                #~(begin #$fcitx5-gtk:gtk3)))
             ("GUIX_GTK2_IM_MODULE_FILE" .
              ,(generate-gtk-immodule-cache
                gtk+
                "2.24.33"
                #~(begin #$fcitx5-gtk:gtk2)))
             ))
          (guix-defaults? #t)
          (package bash)))
        (simple-service 'my-extensions
                        home-bash-service-type
                        (home-bash-extension
                         (bash-profile
                          (list (plain-file "my-bash-profile-ext"
                                            (string-append
                                             my-nvm-setup))))))
        (simple-service
         'dotfiles
         home-files-service-type
         (list `(".config/shepherd/init.scm"
                 ,(local-file "dotfiles/shepherd-init.scm"
                              "shepherd-init"))
               `(".config/shepherd/services.scm"
                 ,(local-file "dotfiles/shepherd-services.scm"
                              "shepherd-services"))
               `(".msmtprc"
                 ,(local-file "dotfiles/msmtprc" "msmtprc"))
               `(".emacs.d/init.el"
                 ,(local-file "dotfiles/emacs-config.el"))
               `(".emacs.d/library-of-babel.org"
                 ,(local-file "dotfiles/library-of-babel.org"))
               `(".emacs.d/lisp"
                 ,(local-file "dotfiles/local-elisp"
                              #:recursive? #true))
               `(".local/share/empty-repo"
                 ,(file-union
                   "empty-repo"
                   `(("AUTHORS"
                      ,(local-file
                        "templates/authors"))
                     ("bin/project-name.in"
                      ,(local-file
                        "templates/project-name"))
                     ("bin/project-name-info.in"
                      ,(local-file
                        "templates/project-name-info"))
                     ("bootstrap"
                      ,(local-file
                        "templates/bootstrap"))
                     ("Changelog.md"
                      ,(local-file
                        "templates/changelog"))
                     ("configure.ac"
                      ,(local-file
                        "templates/configure.ac"))
                     ("DEPENDENCIES.txt"
                      ,(local-file
                        "templates/dependencies"))
                     ("doc/project-name.texi"
                      ,(local-file
                        "templates/project-name.texi"))
                     ("doc/fdl-1.3.texi"
                      ,(local-file
                        "templates/fdl-1.3.texi"))
                     ("doc/procedure-types.texi"
                      ,(local-file
                        "templates/procedure-types.texi"))
                     ("doc/version.texi.in"
                      ,(local-file
                        "templates/version.texi"))
                     (".gitignore"
                      ,(local-file
                        "templates/gitignore"))
                     (".dir-locals.el"
                      ,(local-file
                        "templates/dir-locals"))
                     ("guix.scm"
                      ,(local-file
                        "templates/guix-shell-file.scm"))
                     ("incant.sh"
                      ,(local-file
                        "templates/incant.sh"))
                     ("cast.sh"
                      ,(local-file
                        "templates/cast.sh"))
                     ("LICENSE"
                      ,(local-file
                        "templates/agpl3.0"))
                     ("Makefile.am"
                      ,(local-file
                        "templates/makefile.am"))
                     ("NEWS"
                      ,(local-file
                        "templates/news"))
                     ("pre-inst-env.in"
                      ,(local-file
                        "templates/pre-inst-env"))
                     ("README.org"
                      ,(local-file
                        "templates/readme"))
                     ("setup-symlinks.sh"
                      ,(local-file
                        "templates/setup-symlinks.sh"))
                     ("tests/maintests.scm"
                      ,(local-file
                        "templates/maintests.scm"))
                     ("m4/m4_ax_check_class.m4"
                      ,(local-file
                        "templates/m4/m4_ax_check_class.m4"))
                     ("m4/m4_ax_check_classpath.m4"
                      ,(local-file
                        "templates/m4/m4_ax_check_classpath.m4"))
                     ("m4/m4_ax_check_java_home.m4"
                      ,(local-file
                        "templates/m4/m4_ax_check_java_home.m4"))
                     ("m4/m4_ax_check_java_plugin.m4"
                      ,(local-file
                        "templates/m4/m4_ax_check_java_plugin.m4"))
                     ("m4/m4_ax_check_junit.m4"
                      ,(local-file
                        "templates/m4/m4_ax_check_junit.m4"))
                     ("m4/m4_ax_java_check_class.m4"
                      ,(local-file
                        "templates/m4/m4_ax_java_check_class.m4"))
                     ("m4/m4_ax_java_options.m4"
                      ,(local-file
                        "templates/m4/m4_ax_java_options.m4"))
                     ("m4/m4_ax_prog_jar.m4"
                      ,(local-file
                        "templates/m4/m4_ax_prog_jar.m4"))
                     ("m4/m4_ax_prog_java_cc.m4"
                      ,(local-file
                        "templates/m4/m4_ax_prog_java_cc.m4"))
                     ("m4/m4_ax_prog_javac.m4"
                      ,(local-file
                        "templates/m4/m4_ax_prog_javac.m4"))
                     ("m4/m4_ax_prog_javac_works.m4"
                      ,(local-file
                        "templates/m4/m4_ax_prog_javac_works.m4"))
                     ("m4/m4_ax_prog_javadoc.m4"
                      ,(local-file
                        "templates/m4/m4_ax_prog_javadoc.m4"))
                     ("m4/m4_ax_prog_javah.m4"
                      ,(local-file
                        "templates/m4/m4_ax_prog_javah.m4"))
                     ("m4/m4_ax_prog_java.m4"
                      ,(local-file
                        "templates/m4/m4_ax_prog_java.m4"))
                     ("m4/m4_ax_prog_java_works.m4"
                      ,(local-file
                        "templates/m4/m4_ax_prog_java_works.m4"))
                     ("m4/m4_ax_try_compile_java.m4"
                      ,(local-file
                        "templates/m4/m4_ax_try_compile_java.m4"))
                     ("m4/m4_ax_try_run_java.m4"
                      ,(local-file
                        "templates/m4/m4_ax_try_run_java.m4"))
                     ("m4/tar-edited.m4"
                      ,(local-file "templates/m4/tar-edited.m4"))
                     ("build-aux/test-driver.scm"
                      ,(local-file
                        "templates/build-aux/test-driver.scm")))))
                   `(".emacs.d/templates"
                     ,(local-file "templates"
                                  #:recursive? #true))
                   `(".Xresources"
                     ,(local-file "dotfiles/xresources"
                                  "xresources"))
                   `(".config/mc/ini"
                     ,(local-file "dotfiles/mc.ini" "mc-ini"))
                   `(".config/stumpwm/config"
                     ,(local-file "dotfiles/stumpwmrc" "stumpwmrc"))
                   `(".config/gitconfig.scm"
                     ,(local-file "dotfiles/gitconfig.scm"
                                  "gitconfig-values"))
                   `(".config/gnu-apl/preferences"
                     ,(local-file "dotfiles/gnu-apl-preferences.conf"
                                  "gnu-apl-preferences"))
                   `(".config/stumpwm/window-placement.lisp"
                     ,(local-file "dotfiles/stumpwm-windows.lisp"
                                  "stumpwm-windows.lisp"))
                   `(".local/bin/u-ctags"
                     ,(file-append my-u-ctags "/bin/u-ctags")))))))
