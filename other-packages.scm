(define my-agda-lib-string-list
  (list "agda-stdlib"))
(define my-other-packages
  (append
   my-agda-lib-string-list
   '(
     "agda@2.6.3"
     "alsa-plugins"
     "alsa-plugins:pulseaudio"
     "anki"
     "ant"
     "ant-junit"
     "apl-primer"
     "autoconf"
     "automake"
     "b3sum"
     "bash"
     "beets"
     "biber"
     "bison"
     "borg"
     "brightnessctl"
     "bsd-games"
     "btrfs-progs"
     "carp" ;; 2023-02-26 • No instance for (Eq Context) arising from the superclasses of an instance declaration
     "cbqn"
     "cl-asdf"
     "clisp"
     "clojure"
     "codechallenge-solutions"
     "coreutils"
     "curl"
     "dbqn"
     "dfc"
     "dmidecode"
     "docker"
     "dosfstools"
     "efibootmgr"
     "elm"
     "endless-sky"
     "erlang"
     "erofs-utils"
     "esbuild"
     "espeak-ng"
     "exa"
     "exempi"
     "exfat-utils"
     "exfatprogs"
     "expect"
     "extundelete"
     "fcitx5"
     "fcitx5-anthy"
     "fcitx5-chinese-addons"
     "fcitx5-configtool"
     "fcitx5-gtk"
     "fcitx5-gtk4"
     "fcitx5-gtk:gtk2"
     "fcitx5-gtk:gtk3"
     "fcitx5-lua"
     "fcitx5-material-color-theme"
     "fcitx5-qt"
     "fcitx5-rime"
     "fennel"
     "ffmpeg"
     "file"
     "flex"
     "fluid-3"
     "fluidsynth"
     "font-3270"
     "font-bqn386"
     "font-gnu-freefont"
     "font-gnu-unifont"
     "font-gnu-unifont:bin"
     "font-gnu-unifont:pcf"
     "font-gnu-unifont:psf"
     "font-google-noto"
     "font-openmoji"
     "font-terminus"
     "font-tex-gyre"
     "fontforge"
     "gambit-c"
     "gash"
     "gauche"
     "gcc-toolchain"
     "genpro"
     "gerbil"
     "gfortran-toolchain"
     "ghc"
     "ghc-alex"
     "ghc-bnfc"
     "ghc-happy"
     "ghostscript"
     "gifsicle"
     "gimp"
     "git"
     "git-filter-repo"
     "git:send-email"
     "glibc-locales"
     "gnu-apl"
     "gnupg"
     "gnuplot"
     "gnurobots"
     "gparted"
     "graphviz"
     "grep"
     "groovy"
     "gtk+:bin"
     "guildhall"
     "guile"
     "guile-bash"
     "guile-cdr255"
     "guile-chickadee"
     "guile-colorized"
     "guile-git"
     "guile-goblins"
     "guile-hall"
     "guile-ncurses"
     "guile-readline"
     "guile-sqlite3"
     "guile-ssh"
     "gv"
     "gwl"
     "haunt"
     "htop"
     "httrack"
     "icecat"
     "imagemagick"
     "inkscape"
     "innoextract"
     "ispell"
     "janet"
     "java-bigdecimal-math"
     "java-bsh"
     "java-cglib"
     "java-guice"
     "java-junit"
     "java-log4j-core"
     "jpegoptim"
     "kawa"
     "knock"
     "le-certs"
     "libadlmidi"
     "libreoffice"
     "libvirt"
     "links"
     "lxc"
     "make"
                                        ;"maven" ;; Frequently Troubled.
     "mc"
     "milkytracker"
     "mpv"
     "msmtp"
     "mu"
     "my-frotz"
     "nasm"
     "ncdu"
     "ncurses"
     "netcat"
     "nethack"
     "newlisp"
     "newt"
     "nmap"
     "node"
     "nss-certs"
     "offlineimap3"
     "openjdk:doc"
     "openjdk:jdk" ;; openjdk@15:jdk allowed installation of lsps.
     "optipng"
     "orca-music"
     "owl-lisp"
     "p7zip"
     "pagr"
     "pamixer"
     "password-store"
     "patchelf"
     "patchelf-wrapper"
     "pavucontrol"
     "perl"
     "perl-image-exiftool"
     "picolisp"
     "pinentry-emacs"
     "pioneer"
     "pkg-config"
     "plantuml"
     "poppler"
     "portmidi"
     "postgresql"
     "pseudotaxus"
     "pseudotaxus-emacs"
     "pseudotaxus-grove"
     "pulseaudio"
     "python"
     "python-beautifulsoup4"
     "python-css-html-js-minify"
     "python-lsp-server"
     "python-pillow"
     "python-pygments"
     "python-pygments-pseudotaxus"
     "python-pypa-build"
     "python-requests"
     "qemu"
     "rebar3"
     "restic"
     "ripgrep"
     "rlwrap"
     "rsync"
     "ruby"
     "ruby-kramdown"
     "rxvt-unicode"
     "sbcl"
     "sbcl-deploy"
     "sbcl-esrap"
     "sbcl-ironclad"
     "my-sbcl-stumpwm-battery-portable"
     "sbcl-stumpwm-notify"
     "sbcl-stumpwm-screenshot"
     "sbcl-zpng"
     "scheme-primer"
     "screen"
     "sdl2"
     "sed"
     "sedsed"
     "setxkbmap"
     "sfarklib"
     "shellcheck"
     "shepherd"
     "shotwell"
     "signing-party"
     "sshfs"
     "sshpass"
     "stumpish"
     "stumpwm"
     "stumpwm:lib"
     "swi-prolog"
     "talkfilters"
     "telescope"
     "texinfo"
     "texmacs"
     "the-silver-searcher"
     "timidity++"
     "tintin++"
     "transmission"
     "trash-cli"
     "tree"
     "universal-ctags"
     "unzip"
     "uxn"
     "virt-manager"
     "virt-viewer"
     "vlang"
     "wesnoth"
     "which"
     "wine64-staging"
     "wordnet"
     "xapian"
     "xboard"
     "xdg-utils"
     "xdotool"
     "xdpyprobe"
     "xfontsel"
     "xindy"
     "xkeyboard-config"
     "xmp"
     "xorriso"
     "xprop"
     "xrdb"
     "yewscion-scripts"
     "yt-dlp"
     "zenity"
     "zutils")))
