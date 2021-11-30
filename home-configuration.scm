;; This "home-environment" file can be passed to 'guix home reconfigure'
;; to reproduce the content of your profile.  This is "symbolic": it only
;; specifies package names.  To reproduce the exact same profile, you also
;; need to capture the channels being used, as returned by "guix describe".
;; See the "Replicating Guix" section in the manual.

(use-modules
  (gnu home)
  (gnu packages)
  (gnu services)
  (guix gexp)
  (gnu home services shells)
  (gnu packages bash))

(home-environment
  (channels (list (channel
        (name 'yewscion)
        (url "https://git.sr.ht/~yewscion/yewscion-guix-channel")
        (branch "trunk")
        (commit
          "c488b1caf99c3a7beb0be79c4fa3242e955bf910")
        (introduction
          (make-channel-introduction
            "3274a13809e8bad53e550970d684035519818ea0"
            (openpgp-fingerprint
              "6E3D E92C 3D0A 0A4D 1CDD  33EC 8EF2 971E D0D0 35B8"))))
      (channel
        (name 'guix)
        (url "https://git.savannah.gnu.org/git/guix.git")
        (branch "master")
        (commit
          "653bcab96d70d25e98753681d48657fe6634f8c5")
        (introduction
          (make-channel-introduction
            "9edb3f66fd807b096b48283debdcddccfea34bad"
            (openpgp-fingerprint
              "BBB0 2DDF 2CEA F6A8 0D1D  E643 A2A0 6DF2 A33A 54FA"))))))
  (packages
    (map (compose list specification->package+output)
         (list "adb"
               "adlmidi"
               "apl"
               "autoconf"
               "automake"
               "bash"
               "beets"
               "beets-bandcamp"
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
               "frotz"
               "gauche"
               "gforth"
               "gfortran-toolchain"
               "ghc"
               "gimp"
               "git"
               "glibc-locales"
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
               "icedtea"
               "icedtea:doc"
               "idris"
               "janet"
               "julia"
               "libreoffice"
               "links"
               "lua"
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
               "nomad"
               "ocaml"
               "owl-lisp"
               "pandoc"
               "password-store"
               "passwordsafe"
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
               "rust:doc"
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
;                  ("alert" .
;                   "notify-send --urgency=low -i \\\"$([ $? = 0 ] && echo terminal || echo error)\\\" \\\"$(history|tail -n1|sed -e '\\''s/^\\s*[0-9]\\+\\s*//;s/[;&|]\\s*alert$//'\\'')\\\"")
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
                           "")))
              (bashrc
               (list (plain-file "bashrc"
                           "shopt -s checkwinsize autocd cdspell checkhash cmdhist direxpand extglob gnu_errfmt histappend lithist no_empty_cmd_completion progcomp sourcepath xpg_echo")))
              (bash-logout
                (list (plain-file
                        "bash_logout"
                        "")))
              (environment-variables
               '(("SHELL" . "bash")
                 ("HISTCONTROL" . "ignoreboth")
                 ("HISTTIMEFORMAT" . "true")
                 ("PS1" . "\"\\[\\e[0;2;35m\\][\\[\\e[0;2;35m\\]\\#\\[\\e[0;2;35m\\].\\[\\e[0;2;35m\\]$?\\[\\e[0;2;35m\\]] \\[\\e[0;2;37m\\]{\\[\\e[0;2;37m\\]\\A\\[\\e[0;2;37m\\]} \\[\\e[0;2;90m\\]<\\[\\e[0;2;90m\\]$(git branch 2>/dev/null | grep '\"'\"'^*'\"'\"' | colrm 1 2)\\[\\e[0;2;90m\\]> \\[\\e[0;92m\\]\\u\\[\\e[0m\\]@\\[\\e[0;36m\\]\\h\\[\\e[0m\\]:\\[\\e[0;94m\\]\\W\\[\\e[0;94m\\]/\\[\\e[0m\\]\\$ \\[\\e[0m\\]\"")))
              (guix-defaults? #t)
              (package bash))))))
