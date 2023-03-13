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
 (guix derivations)
 (guix build utils)
 (guix packages)
 (gnu packages code)
 (gnu packages curl)
 (gnu packages gtk)
 (gnu packages fcitx5)
 (gnu packages java)
 (gnu packages maven)
 (cdr255 fixes)
 (cdr255 agda)
 (gnu packages emacs-xyz))

(load "gtk-immodule-cache-fcitx5.scm")

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
                 "    xterm*|rxvt*|eterm*|screen*|alacritty*)\n"
                 "        tty -s && export PS1=\""
                 my-ps1-prompt
                 "\"\n"
                 "        ;;\n"
                 "esac\n"))
(load "emacs-packages.scm")
(load "texlive-packages.scm")
(load "other-packages.scm")

; Package Graveyard: "nomad"

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
(define use-new-java-logback-classic
  ;; This is a procedure to replace OPENSSL by LIBRESSL,
  ;; recursively.
  (package-input-rewriting `((,java-logback-classic . ,java-logback-classic-fixed))))

(define maven-with-replaced-jlc
  (use-new-java-logback-classic maven))
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
(define my-agda-lib-list
  (map specification->package+output
       my-agda-lib-string-list))
(define (find-agda-lib-file package)
  (string-join
          (find-files
           (derivation->output-path
            (run-with-store
             (open-connection)
             (package->derivation package)))
           ".+\\.agda-lib")
          "\n"
          'infix))
(define (find-agda-lib-files list-of-packages)
  (string-join
   (map find-agda-lib-file
        list-of-packages)
   "\n"
   'infix))
(define my-agda-libraries
  (plain-file
   "agda-libraries"
   (find-agda-lib-files my-agda-lib-list)))
(define my-transformed-packages
  ;; (map my-transformation
    ;;           my-no-test-packages)
  (list maven-with-replaced-jlc))
(define my-spec-list (append
                      '()
                      my-packages))
(define my-package-list
  (append '() my-transformed-packages
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
             ("LC_ALL" . "en_US.UTF-8")
             ("INPUT_METHOD" . "fcitx")
             ("GTK_IM_MODULE" . "fcitx")
             ("QT_IM_MODULE" . "fcitx")
             ("XIM" . "fcitx")
             ("XIM_PROGRAM" . "fcitx")
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
                   `(".local/share/refcards"
                     ,(local-file "refcards"
                                  #:recursive? #true))
                   `(".Xresources"
                     ,(local-file "dotfiles/xresources"
                                  "xresources"))
                   `(".Xdefaults"
                     ,(local-file "dotfiles/xresources"
                                  "xdefaults"))
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
                   `(".config/alacritty/alacritty.yml"
                     ,(local-file "dotfiles/alacritty.yml"
                                  "alacritty-yml"))
                   `(".config/stumpwm/window-placement.lisp"
                     ,(local-file "dotfiles/stumpwm-windows.lisp"
                                  "stumpwm-windows.lisp"))
                   `(".local/bin/u-ctags"
                     ,(file-append my-u-ctags "/bin/u-ctags"))
                   `(".local/share/bash/yewscion.bash"
                     ,(local-file "dotfiles/yewscion.bash"
                                  "yewscion.bash"))
                   `(".agda/libraries"
                     ,my-agda-libraries))))))
