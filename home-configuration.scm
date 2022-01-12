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
  (gnu home services shells)
  (gnu packages bash))

(home-environment
  (packages
    (map (compose list specification->package+output)
         (list "adb"
               "adlmidi"
;               "apl"
               "autoconf"
               "automake"
               "bash"
               "beets"
;               "beets-bandcamp"
               "borg"
               "brasero"
               "cabal-install"
               "chez-scheme"
               "chez-scheme:doc"
               "clisp"
               "clojure"
               "cmake"
               "coq"
               "dfc"
               "docker"
               "elixir"
               "emacs-next"
               "erlang"
               "extempore"
               "fluid-3"
               "fluidsynth"
               "font-gnu-freefont"
               "font-gnu-unifont"
;               "frotz"
               "gauche"
               "gforth"
               "gfortran-toolchain"
               "ghc"
               "gimp"
               "git"
               "glibc-locales"
               "gnu-apl"
               "gnucobol"
               "gnupg"
               "gnurobots"
               "go"
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
;               "idris"
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
               "nethack"
               "newlisp"
               "nim"
               "nmap"
               "node"
;               "nomad"
               "ocaml"
               "owl-lisp"
               "pandoc"
               "password-store"
;               "passwordsafe"
               "pavucontrol"
               "php"
               "picolisp"
               "pkg-config"
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
               "telegram-desktop"
               "telescope"
               "texinfo"
               "timidity++"
               "tintin++"
               "tree"
               "virt-manager"
               "wesnoth"
               "wireshark"
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
                  ("port" . "cd $(cat ~/.sd)")))
              (bash-profile
               (list (plain-file "bash-profile"
                                 (format #f "~a~%~a~%~a~a~a~%~a"
                                         "function dir-git-branch()"
                                         "{"
                                         "git branch 2>/dev/null | "
                                         "grep \"^*\" | "
                                         "sed 's/* /</;s/$/> /'"
                                         "}"))))
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
                 ("PS1" .
                  (string-append "\"\\[\\e[0;2;35m\\][\\[\\e[0;2;"
                                 "35m\\]\\#\\[\\e[0;2;35m\\].\\[\\e["
                                 "0;2;35m\\]0\\[\\e[0;2;35m\\]] "
                                 "\\[\\e[0;2;37m\\]{\\[\\e[0;2;"
                                 "37m\\]\\A\\[\\e[0;2;37m\\]} \\[\\e"
                                 "[0;2;90m\\]\\$("
                                 "dir-git-branch)"
                                 "\\[\\e[0;92m\\]\\u\\[\\e[0m\\]@"
                                 "\\[\\e[0;36m\\]\\h\\[\\e[0m\\]:"
                                 "\\[\\e[0;94m\\]\\W\\[\\e[0;94m\\]"
                                 "/\\[\\e[0m\\]$ \\[\\e[0m\\]\""))))
              (guix-defaults? #t)
              (package bash))))))
