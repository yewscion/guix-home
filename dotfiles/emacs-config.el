(if (string-equal system-type "windows-nt")
    (progn (setenv "HOME" "c:/Users/rodnchr")))

(setq custom-file "~/.emacs.d/custom.el")

;;; Package System
(require 'package)
(setq package-archives '(("gnu" .
                          "https://elpa.gnu.org/packages/")
                         ("nongnu" .
                          "https://elpa.nongnu.org/nongnu/")
                         ("melpa" .
                          "https://melpa.org/packages/")
                         ("melpa-stable" .
                          "https://stable.melpa.org/packages/")))
(package-initialize)
;;; Local Elisp
(add-to-list 'load-path "~/.emacs.d/lisp/")

;;; Load Libraries for Configuration
(require 're-builder)
(require 'emms-setup)
(require 'emms-player-mpv)
(require 'emms-player-simple)
(require 'emms-streams)
(require 'emms-mode-line-cycle)
(require 'mastodon)
(require 'bqn-mode)
(require 'org-chef)
(require 'org-ebib)
(require 'org-drill)
(require 'ebib)
(require 'biblio)
(require 'ebib-biblio)
(require 'mu4e)
(require 'projectile)
(require 'eterm-256color)
(require 'zone)
(require 'forms)
(require 'pdf-view)
(require 'pseudotaxus)
(require 'elfeed)

;;; Load Local Custom
(load "~/.emacs.d/custom.el")

;;; Load Personal Procedures
(load "~/.emacs.d/procs.el")

;;;; Tooling
(defmacro cdr:make-face
    (name inherit weight slant foreground background description)
  "Make a customizable face, and assign it to a customizable
variable of the same name."
  (let ((face-name (intern (concat "cdr:" name "-face"))))
  `(defface ,face-name
     ((t :inherit ,inherit
         :weight ,weight
         :slant ,slant
         :foreground ,foreground
         :background ,background))
  ,description)
  `(defvar ,face-name (quote ,face-name)
     ,description)))

;;;; Fontspecs
(setq cdr:fonts-freemono (font-spec
                          :family "FreeMono"
                          :weight 'normal
                          :slant 'normal
                          :width 'normal
                          :foundry "GNU" ; symbol or string representing foundry, 'misc'
                          :size 13 ; integers are pixels, floats are points.
                          :spacing 'm ; [p]roportional [d]ual [m]ono [c]harcell
                          :name "FreeMono" ; fontconfig-style name
                          :script 'latin ; look in script-representative-chars
                          :lang  'en ; ISO639 codes, 'ja' or 'en'
                          ))
(setq cdr:fonts-unifont (font-spec
                         :family "Unifont"
                         :weight 'normal
                         :slant 'normal
                         :width 'normal
                         :foundry "GNU" ; symbol or string representing foundry, 'misc'
                         :size 12.0 ; integers are pixels, floats are points.
                         :spacing 'd ; [p]roportional 0 [d]ual 90 [m]ono 100 [c]harcell 110
                         :name "Unifont" ; fontconfig-style name
                         :script 'unicode ; look in script-representative-chars
                         :lang  'en ; ISO639 codes, 'ja' or 'en'
                         ))
;;;; Generic
(cdr:make-face "good"
               default
               bold
               nil
               yewscion-colors-green
               nil
               "Personal Face For 'Good' text.")
(cdr:make-face "info"
               default
               bold
               nil
               yewscion-colors-yellow
               nil
               "Personal Face For 'Informational' text.")
(cdr:make-face "warning"
               default
               bold
               nil
               yewscion-colors-orange
               nil
               "Personal Face For 'Warning' text.")
(cdr:make-face "bad"
               default
               bold
               nil
               yewscion-colors-red
               nil
               "Personal Face For 'Bad' text.")
(cdr:make-face "emphasis"
               default
               nil
               italic
               yewscion-colors-white
               nil
               "Personal Face For 'Emphasized' text.")
(cdr:make-face "strong"
               default
               bold
               nil
               yewscion-colors-white
               nil
               "Personal Face For 'Strong' text.")
(cdr:make-face "system"
               default
               bold
               nil
               yewscion-colors-cyan
               nil
               "Personal Face For 'System' text.")
(cdr:make-face "awesome"
               default
               bold
               nil
               yewscion-colors-magenta
               nil
               "Personal Face For 'Awesome' text.")
(cdr:make-face "orgy-new-todo"
               org-todo
               nil
               nil
               yewscion-colors-cyan
               nil
               "Personal Face For New TODOs.")
(cdr:make-face "orgy-blocked-todo"
               org-todo
               nil
               nil
               yewscion-colors-red
               nil
               "Personal Face For Blocked TODOs.")
(cdr:make-face "orgy-deferred-todo"
               org-todo
               nil
               nil
               yewscion-colors-magenta
               nil
               "Personal Face For Deferred TODOs.")
(cdr:make-face "orgy-ongoing-todo"
               org-todo
               nil
               nil
               yewscion-colors-orange
               nil
               "Personal Face For Orange TODOs.")
(cdr:make-face "orgy-cancelled-todo"
               org-todo
               nil
               nil
               yewscion-colors-yellow
               nil
               "Personal Face For Cancelled TODOs.")
(cdr:make-face "orgy-complete-todo"
               org-todo
               nil
               nil
               yewscion-colors-green
               nil
               "Personal Face For Completed TODOs.")
;;; Regex Builder Config
(setq reb-re-syntax 'string)

  ;;; EMMS Config
(emms-all)
(emms-default-players)
(emms-mode-line-cycle 0)
(define-emms-simple-player mikmod '(file)
  (regexp-opt '(".669" ".AMF" ".DSM" ".FAR" ".GDM" ".IT" ".IMF"
                ".MED" ".MTM" ".OKT" ".S3M" ".STM" ".STX" ".ULT"
                ".APUN" ".XM" ".MOD" ".amf" ".dsm" ".far" ".gdm"
                ".it" ".imf" ".mod" ".med" ".mtm" ".okt" ".s3m"
                ".stm" ".stx" ".ult" ".apun" ".xm" ".mod" ".MOD"))
  "mikmod" "-q" "-p" "2" "-X")
(define-emms-simple-player xmp '(file)
  (regexp-opt '(".669" ".AMF" ".DSM" ".FAR" ".GDM" ".IT" ".IMF"
                ".MED" ".MTM" ".OKT" ".S3M" ".STM" ".STX" ".ULT"
                ".APUN" ".XM" ".MOD" ".amf" ".dsm" ".far" ".gdm"
                ".it" ".imf" ".mod" ".med" ".mtm" ".okt" ".s3m"
                ".stm" ".stx" ".ult" ".apun" ".xm" ".mod" ".MOD"))
  "xmp" "-q")
(define-emms-simple-player adlmidi '(file)
  (regexp-opt '(".mid"
                ".midi"))
  "adlmidi-wrapper" "--" "-t" "-v" "-fp" "-frb" "-nl" "-vm 5" "--emu-dosbox" "65")
(setq emms-source-file-default-directory
      "~/Music/"
      ;; emms-player-list
      ;; '(emms-player-mpv
      ;;   emms-player-mikmod
      ;;   emms-player-xmp
      ;;   emms-player-adlmidi
      ;;   emms-player-timidity) ; Reverse Order of Precedence
      emms-player-list
      '(emms-player-adlmidi
        emms-player-mikmod
        emms-player-mpv) ; Order of Precedence

      emms-player-timidity-command-name
      "timidity"

      emms-player-timidity-parameters
      '("-EFreverb=G,127"
        "-EFchorus=s,25"
        "-EFresamp=L"
        "-EFvlpf=m"
        "-c~/.config/timidity/timidity.cfg")

      emms-track-description-function
      'emms-info-track-description

      emms-playing-time-display-format "(%s) "
      emms-mode-line-format "[%s]"
      emms-mode-line-mode-line-function #'cdr:emms-describe-track
      emms-mode-line-cycle-current-title-function
      'cdr:emms-describe-track
      emms-browser-default-browse-type 'info-album)

;;; Clojure Config
(setq org-babel-clojure-backend 'cider)

;;; EPUB Config
(add-to-list 'auto-mode-alist
             '("\\.epub\\'" . nov-mode))
(setq nov-variable-pitch nil
      nov-text-width 80)

;;; Backend Defs
(setq markdown-command "kramdown"
      inferior-lisp-program "sbcl"
      geiser-default-implementation 'guile
      python-shell-interpreter "python3"
      inf-janet-program "janet -s"
      bqn-interpreter-path "bqn"
      youtube-dl-program "yt-dlp")

(setq-default geiser-scheme-implementation 'guile)

;; Assuming the Guix checkout is in ~/Downloads/Checkouts/guix.
(with-eval-after-load 'geiser-guile
  (add-to-list 'geiser-guile-load-path "~/Downloads/Checkouts/guix"))

;;; i-ching-mode
(setq i-ching-hexagram-font "unifont")

;;; plantuml-mode
(setq
 plantuml-default-exec-mode 'executable
 plantuml-jar-path "~/.guix-home/profile/bin/plantuml"
 plantuml-output-type "svg")
(setenv "JAVA_TOOL_OPTIONS")


;;; httpd config
(setq httpd-port 8888)

;;; mpd modes
(setq libmpdel-hostname "s"
      mpc-host "s")

;;; mastodon-mode
(setq mastodon-instance-url "https://scholar.social/"
      mastodon-active-user "yewscion"
      mastodon-media--avatar-height 15
      mastodon-media--enable-image-caching t
      mastodon-media--preview-max-height 80
      mastodon-tl--enable-relative-timestamps nil
      mastodon-tl--show-avatars t
      mastodon-toot--default-media-directory "~/Pictures"
      mastodon-toot--enable-custom-instance-emoji t
      mastodon-toot-timestamp-format "%FT%TZ%z")
;;; ANSI Color
(setq ansi-color-faces-vector
      [default default default
        italic underline success
        warning error])

;;; Dired
(setq dired-listing-switches "-aDFhikmoqs")
(add-hook 'dired-load-hook
          (lambda ()
            (load "dired-x")
            ;; Set dired-x global variables here.  For example:
            ;; (setq dired-guess-shell-gnutar "gtar")
            ;; (setq dired-x-hands-off-my-keys nil)
            ))
(remove-hook 'dired-mode-hook
             (lambda ()
               ;; Set dired-x buffer-local variables here.  For example:
               (dired-omit-mode 0)
               ))

;;; Info
(setq Info-additional-directory-list '("~/.local/share/info"))

;;; TeX
(setq-default TeX-engine 'luatex)
(setenv "TEXMFCACHE" "$HOME/.local/share/texmf-dist" t)

;;; Deft
(setq  deft-extensions '("txt" "org")
       deft-new-file-format "%FT%T%z"
       deft-org-mode-title-prefix nil
       deft-time-format nil)

;;; Describe Char
(setq describe-char-unidata-list
      '(name old-name general-category canonical-combining-class
             bidi-class decomposition decimal-digit-value digit-value
             numeric-value mirrored iso-10646-comment uppercase
             lowercase titlecase))

;;; GNU APL
(setq gnu-apl-auto-function-editor-popup nil
      gnu-apl-interactive-mode-map-prefix "H-"
      gnu-apl-key-prefix 92
      gnu-apl-mode-map-prefix "H-"
      gnu-apl-program-extra-args '("--emacs")
      gnu-apl-show-apl-welcome t
      gnu-apl-show-tips-on-start nil)

;;; Ediprolog
(setq  ediprolog-max-history 8000000
       ediprolog-system 'swi)


;;; Agda

(setq agda-input-user-translations '()
      agda2-backend "GHC"
      agda2-fontset-name cdr:fonts-unifont
      agda2-highlight-level 'interactive
      agda2-information-window-max-height 0.4)

;;; Org Mode
;;;; Local Lisp
(load "~/.emacs.d/lisp/ob-markdown.el")

(add-hook 'org-mode-hook 'org-display-inline-images)

;;;; Org Agenda
(setq org-agenda-files
      (append (file-expand-wildcards "~/Documents/org/goals.org")
              (file-expand-wildcards "~/Documents/org/work.org")))

;;;; Customization
(setq
 org-log-into-drawer t
 org-return-follows-link t
 org-startup-folded t
 org-image-actual-width 590
 org-pomodoro-audio-player "mpv"
 org-adapt-indentation nil
 org-capture-before-finalize-hook nil
 org-contacts-files '("~/Documents/org/contacts.gpg")
 org-export-backends '(ascii beamer html icalendar
                             latex man md odt org
                             texinfo deck rss s5)
 org-refile-targets '((org-agenda-files :maxlevel . 3)
                      (nil :maxlevel . 9)
                      (org-buffer-list :maxlevel . 3))
 org-time-stamp-custom-formats '("%F" . "%F %H:%MZ%z")
;;;; Journal
 org-journal-dir "~/Documents/org/journal/"
 org-journal-encrypt-journal t
;;;; TODO
 org-todo-keyword-faces
 `(("THOUGHT" . ,yewscion-colors-cyan)
   ("GOAL" . ,yewscion-colors-cyan)
   ("UNREAD" . ,yewscion-colors-cyan)
   ("REASONING" . ,yewscion-colors-magenta)
   ("ONGOING" . ,yewscion-colors-magenta)
   ("DIGESTING" . ,yewscion-colors-magenta)
   ("MULTIPLE" . ,yewscion-colors-blue)
   ("STAYED" . ,yewscion-colors-blue)
   ("EXCERPTED" . ,yewscion-colors-blue)
   ("NOTED" . ,yewscion-colors-green)
   ("COMPLETED" . ,yewscion-colors-green)
   ("PORED" . ,yewscion-colors-green)
   ("LACKING" . ,yewscion-colors-yellow)
   ("BLOCKED" . ,yewscion-colors-yellow)
   ("ABEYED" . ,yewscion-colors-yellow)
   ("VOIDED" . ,yewscion-colors-dark-grey)
   ("QUIT" . ,yewscion-colors-dark-grey)
   ("INUTILE" . ,yewscion-colors-dark-grey))
 org-todo-keywords
 ;; Three lines: trmnlv;udiaep;goscbq
 ;; Available letters: fhjkwxyz
 '((sequence
    "THOUGHT(t!)" "|" "REASONING(r!)" "|" "MULTIPLE(m@)"     "|" "NOTED(n!)"
    "|" "LACKING(l@)" "|" "VOIDED(v@)")
   (sequence
    "GOAL(g!)"   "|" "ONGOING(o!)"     "|" "STAYED(s@)"    "|" "COMPLETED(c!)"
    "|" "BLOCKED(b@)" "|" "QUIT(q@)")
   (sequence
    "UNREAD(u!)" "|" "DIGESTING(d!)"   "|" "EXCERPTED(e!)" "|" "PORED(p!)"
    "|" "ABEYED(a@)"  "|" "INUTILE(i@)")))
;;;; Capture
(setq org-capture-templates
      '(("r" "Recipes (using org-chef)")
        ("ru" "Import Recipe from URL" entry
         (file+headline "~/Documents/org/data/recipes.org"
                        "Inbox")
         "%(org-chef-get-recipe-from-url)"
         :empty-lines 1)
        ("rm" "Import Recipe Manually" entry
         (file+headline "~/Documents/org/data/recipes.org"
                        "Inbox")
         (function my-org-capture:recipe-template))
        ("n" "Notes, Links, and Contacts")
        ("nn" "Note" entry
         (file+headline "~/Documents/org/notes.org"
                        "Inbox")
         (function my-org-capture:note-template))
        ("nc" "Contact" entry
         (file "~/Documents/org/data/contacts.org")
         (function my-org-capture:contacts-template))
        ("nl" "Link from Clipboard" entry
         (file+headline "~/Documents/org/data/bookmarks.org"
                        "Inbox")
         (function my-org-capture:link-template))
        ("d" "Data Aggregation")
        ("dh" "Daily Health Check In" table-line
         (file+headline "~/Documents/org/data/metrics.org"
                        "Health")
         (function my-org-capture:health-template) :unnarrowed t)
        ("dw" "Wishlist Item" entry
         (file "~/Documents/org/data/wishlist.org")
         (function my-org-capture:wishlist-template))
        ("c" "Chores")
        ("cg" "Grocery Shopping List" entry
         (file+headline "~/Documents/org/chores.org"
                        "Make Shopping List")
         (function my-org-capture:grocery-template))))

;;;; Babel
(org-babel-do-load-languages
 'org-babel-load-languages
 '((abc . t)
   (C . t)
   (clojure . t)
   (browser . t)
   (dot . t)
   (elm . t)
   (emacs-lisp . t)
   (gnuplot . t)
   (js . t)
   (lilypond . t)
   (lisp . t)
   (lua . t)
   (makefile . t)
   (markdown . t)
   (org . t)
   (perl . t)
   (prolog . t)
   (python . t)
   (raku . t)
   (ruby . t)
   (scheme . t)
   (shell . t)
   (shen . t)
   (sql . t)
   (sqlite . t)
   ))
(setq org-confirm-babel-evaluate nil
      org-babel-raku-command "rakudo"
      org-src-preserve-indentation t
      org-pomodoro-audio-player "mpv")
(add-hook 'org-babel-after-execute-hook 'org-display-inline-images)
(org-babel-lob-ingest "~/.emacs.d/library-of-babel.org")

;;;; Drill
(setq org-drill-hide-item-headings-p t
      org-drill-learn-fraction 0.4
      org-drill-add-random-noise-to-intervals-p t
      org-drill-leech-method 'warn)


;;;; Bibliography
(setq org-cite-global-bibliography
      '("~/Documents/biblio/main.bib"))

;;;; MIME export
(setq org-mime-export-options '(:with-latex dvipng
                                            :section-numbers nil
                                            :with-author nil
                                            :with-toc nil)
      org-mime-export-ascii 'utf-8)


;;; LSP Mode

(setq lsp-headerline-breadcrumb-enable-symbol-numbers t
      lsp-headerline-breadcrumb-icons-enable nil
      lsp-modeline-code-action-fallback-icon "⚕"
      lsp-progress-function 'lsp-on-progress-legacy
      lsp-progress-via-spinner nil
      lsp-server-trace "verbose"
      lsp-ui-doc-enable t
      lsp-ui-doc-header nil
      lsp-ui-doc-position 'at-point
      lsp-ui-doc-show-with-cursor t
      lsp-ui-doc-show-with-mouse nil
      lsp-ui-doc-use-childframe t
      lsp-ui-doc-use-webkit t
      lsp-java-vmargs
      '("-Xmx1G" "-XX:+UseG1GC" "-XX:+UseStringDeduplication"))

;;; Ebib/biblio/etc
(defconst my-ebib-keywords '("ABSTRACTION"
                             "AFRICA"
                             "ALGORITHM design"
                             "ALGORITHMIC information"
                             "ALGORITHMS"
                             "ALGORITHMS - search"
                             "ALGORITHMS - sort - bubble"
                             "ALGORITHMS - sort - quicksort"
                             "ALGORITHMS - sort"
                             "APPROPRIATE access"
                             "ARAB spring uprisings"
                             "ARTIFICIAL intelligence"
                             "ASTROTURFING"
                             "ATTRACTION"
                             "AUTHORITARIAN regimes"
                             "AUTHORITARIANISM"
                             "AUTHORITY"
                             "AUTOMATION"
                             "AWARDS"
                             "BALANCE of power"
                             "BIOLOGICAL pathogens"
                             "BOTS"
                             "BUSINESS communication"
                             "BUSINESS writing"
                             "BUSINESS"
                             "CACHE"
                             "CANADA"
                             "CASE study"
                             "CHINA"
                             "CHINESE people"
                             "CIA triad"
                             "CIVIL society"
                             "CLUSTERING"
                             "CODE quality"
                             "COLLABORATION"
                             "COLLECTIVE leadership"
                             "COLLECTIVE migration"
                             "COMMUNICATION"
                             "COMMUNICATION - interprocess"
                             "COMMUNICATION - mass"
                             "COMMUNICATION - online"
                             "COMMUNICATION - technical"
                             "COMMUNICATIVE competence"
                             "COMMUNIST parties"
                             "COMMUNITIES - VIRTUAL"
                             "COMPILATION"
                             "COMPILERS"
                             "COMPLEXITY - logical"
                             "COMPUTER algorithms"
                             "COMPUTER file format - pdf"
                             "COMPUTER filesystems"
                             "COMPUTER firmware"
                             "COMPUTER hardware"
                             "COMPUTER input-output equipment"
                             "COMPUTER memory"
                             "COMPUTER multitasking"
                             "COMPUTER networks"
                             "COMPUTER operating systems"
                             "COMPUTER processors - multi-core"
                             "COMPUTER science education"
                             "COMPUTER science - artificial intelligence"
                             "COMPUTER science - high performance"
                             "COMPUTER science - language"
                             "COMPUTER science - machine learning"
                             "COMPUTER science - moore's law"
                             "COMPUTER science - parallelism"
                             "COMPUTER science - robotics"
                             "COMPUTER scientists"
                             "COMPUTER security"
                             "COMPUTER software"
                             "COMPUTER software - pgp"
                             "COMPUTER storage"
                             "COMPUTER storage - raid"
                             "COMPUTER systems"
                             "COMPUTER user interfaces"
                             "COMPUTER-AIDED manufacturing"
                             "COMPUTERS"
                             "COMPUTERS - embedded"
                             "CONSENSUS - social science"
                             "CONTRACT management"
                             "CORRESPONDENCE"
                             "COVID-19"
                             "CREATIVE ability"
                             "CREATIVE writing"
                             "CREDIBILITY"
                             "CRIME"
                             "CRISIS communication"
                             "CRITICAL discourse analysis"
                             "CULTURE"
                             "CYBERSECURITY"
                             "DATA analysis"
                             "DATA security"
                             "DATA"
                             "DATABASES - relational"
                             "DATAFICATION"
                             "DEADLOCKS"
                             "DEFINITIONS"
                             "DEMOCRACY"
                             "DEMOCRATIC socialism"
                             "DEMOCRATIZATION"
                             "DEVELOPMENT - economic"
                             "DEVSECOPS"
                             "DIGITAL communication"
                             "DIGITAL media"
                             "DIGITAL technology"
                             "DISCOVERY - scientific"
                             "DISINFORMATION"
                             "ECONOMY"
                             "EDUCATION - distance"
                             "EDUCATION - mathematics"
                             "EDUCATION - programming"
                             "EFFECTIVENESS"
                             "EFFICIENCY - energy"
                             "ELECTIONS"
                             "ELECTIONS - presidential"
                             "ELECTRON"
                             "ENCRYPTION - public-key"
                             "ENTROPY"
                             "ETHICS"
                             "EXECUTIVE Ability"
                             "EXECUTIVES"
                             "FAKE news"
                             "FICTION - science fiction"
                             "FOCUS"
                             "FOLLOWER-LEADER"
                             "FREEDOM - speech"
                             "FUN"
                             "GAME - psychology"
                             "GAME - theory"
                             "GAMES - video games"
                             "GATHERING points"
                             "GENDER"
                             "GENDER - equality"
                             "GENERALITY"
                             "GOVERNMENT forms - parliamentary democracy"
                             "GRAMMAR"
                             "GREAT Britain"
                             "GUIDELINES"
                             "HISTORY - artificial intelligence"
                             "HISTORY - computer science"
                             "HISTORY - laundry"
                             "HISTORY - lisp programming language"
                             "HISTORY - victorian england"
                             "HOAXES"
                             "HOPPER - grace"
                             "HUMAN behavior"
                             "HUMAN beings"
                             "HUMAN multitasking"
                             "HUMAN rights"
                             "HUMANITIES - digital"
                             "IMAN1"
                             "IMMUNIZATION"
                             "IMPROVEMENT - continuous"
                             "INFLUENCE"
                             "INFORMATION technology"
                             "INSTITUTIONS"
                             "INTEGRATED circuits"
                             "INTERFACE - message-passing"
                             "INTERNATIONAL courts"
                             "INTERNATIONAL relations"
                             "INTERNET - advertising"
                             "INTERNET - culture"
                             "INTERNET - protocol"
                             "INTERNET - world wide web"
                             "INVENTIONS"
                             "JACQUARD loom"
                             "LAISSEZ-FAIRE"
                             "LANGUAGE"
                             "LAW"
                             "LEADER"
                             "LEADERSHIP foundations"
                             "LEADERSHIP model"
                             "LEADERSHIP style"
                             "LEADERSHIP"
                             "LEARNING - informal"
                             "LEARNING - machine"
                             "LINUX distribution - debian"
                             "LINUX distribution - slackware linux"
                             "LISP machines"
                             "LITERATURE - romanticism"
                             "LOGIC - boolean"
                             "LOGIC - symbolic"
                             "LOVELACE - ada byron king"
                             "MACHINERY - textile"
                             "MANAGEMENT foundations"
                             "MANAGEMENT model"
                             "MANAGEMENT styles"
                             "MANAGEMENT"
                             "MANAGEMENT - industrial"
                             "MANAGEMENT - information"
                             "MANAGEMENT - knowledge"
                             "MANAGEMENT - personnel"
                             "MANAGEMENT - software"
                             "MANAGEMENT - time"
                             "MASS shootings"
                             "MATHEMATICS - logic"
                             "MEDIA - mass"
                             "METAPHOR"
                             "MICROTARGETING"
                             "MIDDLE east"
                             "MIS"
                             "MOBILIZATION"
                             "MODEL - discrete choice"
                             "MODEL - domain-specific"
                             "MORGAN - augustus de"
                             "MULTITHREADING"
                             "NARRATIVE"
                             "NONLOCAL PDEs"
                             "OPEN source firmware"
                             "OPERATING system - android"
                             "OPERATING system - apple ios"
                             "OPERATING system - bsd"
                             "OPERATING system - cisco ios"
                             "OPERATING system - gnu/linux"
                             "OPERATING system - junos"
                             "OPERATING system - kernel"
                             "OPERATING system - macos"
                             "OPERATING system - microsoft dos"
                             "OPERATING system - microsoft windows"
                             "OPERATING system - os/2"
                             "OPERATING system - unix"
                             "OPERATING systems"
                             "OPERATING systems - security"
                             "ORGANIZATION"
                             "ORGANIZATIONAL behavior"
                             "ORGANIZATIONAL change"
                             "ORGANIZATIONAL effectiveness"
                             "ORGANIZATIONAL sociology"
                             "PARALLELISM - linguistic"
                             "PERFORMANCE"
                             "PERSONALITY"
                             "PERSUASION"
                             "PHILOSOPHY of Mind"
                             "PHILOSOPHY"
                             "POETRY"
                             "POLICY"
                             "POLITICAL advertising"
                             "POLITICAL campaigns"
                             "POLITICAL communication"
                             "POLITICAL community"
                             "POLITICAL development"
                             "POLITICAL engagement"
                             "POLITICAL participation"
                             "POLITICAL science"
                             "POLITICAL socialization"
                             "POLITICAL succession"
                             "POLITICAL systems"
                             "POLITICS"
                             "POLITICS - elite"
                             "POLITICS - global"
                             "POLITICS - middle eastern"
                             "POLITICS - national"
                             "POPULAR culture"
                             "POPULAR works"
                             "POPULISM"
                             "PORTS"
                             "POWER sharing"
                             "POWER"
                             "PRESIDENT"
                             "PROBABILITY"
                             "PRODUCTIVITY"
                             "PRODUCTIVITY - labor"
                             "PROGRAMMING language family - lisp"
                             "PROGRAMMING language - c++"
                             "PROGRAMMING language - clojure"
                             "PROGRAMMING language - common lisp"
                             "PROGRAMMING language - emacs lisp"
                             "PROGRAMMING language - java"
                             "PROGRAMMING language - python"
                             "PROGRAMMING language - rust"
                             "PROGRAMMING language - scheme"
                             "PROGRAMMING language - webassembly"
                             "PROGRAMMING languages"
                             "PROGRAMMING teams"
                             "PROGRAMMING - parallelism"
                             "PSEUDOCODE"
                             "PSYCHOLOGY"
                             "PSYCHOLOGY"
                             "PSYCHOLOGY - cognitive"
                             "PSYCHOLOGY - social"
                             "PUBLIC relations"
                             "PUBLICATIONS"
                             "QUALIFICATIONS"
                             "READING - engaged"
                             "RELATIONSHIPS - professional"
                             "RESEARCH"
                             "RESEARCH - publishing"
                             "SECURITY"
                             "SECURITY - information"
                             "SECURITY - software"
                             "SELECTIVE exposure"
                             "SELF evaluation"
                             "SHIPS"
                             "SOCIAL dominance"
                             "SOCIAL media"
                             "SOCIAL networks"
                             "SOCIAL sciences"
                             "SOCIOLOGY - industrial"
                             "SOFTWARE analysis"
                             "SOFTWARE collaboration"
                             "SOFTWARE creation"
                             "SOFTWARE defects"
                             "SOFTWARE design"
                             "SOFTWARE development - mobile application"
                             "SOFTWARE engineering"
                             "SOFTWARE shells"
                             "SOFTWARE testing"
                             "SOFTWARE"
                             "SOFTWARE - debugging"
                             "SOFTWARE - free - libre - and open source"
                             "STATE - failed"
                             "STATE - fragile"
                             "STUDY - reproduction"
                             "SUCCESS"
                             "SUCCESSION"
                             "SUPERCOMPUTER"
                             "SWARMING"
                             "SYNTAX"
                             "SYSTEMS software"
                             "TASK analysis"
                             "TAXONOMY"
                             "TECHNOLOGY"
                             "TECHNOLOGY - sustainable"
                             "TEXTBOOK"
                             "TILING"
                             "TRANSISTORS"
                             "TWITTER"
                             "UML"
                             "UNITED nations"
                             "UNITED states"
                             "UNIVERSAL basic income (ubi)"
                             "VIRTUAL MACHINES"
                             "VIRTUALIZATION"
                             "VULNERABILITY"
                             "WRITING"
                             "YEMENI civil war 2015"
                             "YOUTUBE"
                             "ZETTELKASTEN"
                             )
  "A list of Keywords I use in my biblatex databases.

This is a DATUM.

Arguments
=========
None.

Returns
=======
None.

Impurities
==========
None; Inert Data.")
(setq ebib-bibtex-dialect 'biblatex
      ebib-preload-bib-files '("~/Documents/biblio/main.bib")
      ebib-reading-list-file "~/Documents/org/data/reading-list.org"
      ebib-reading-list-todo-marker "UNREAD"
      ebib-reading-list-done-marker "PORED"
      ebib-file-associations '()
      ebib-hidden-fields
      '("addendum" "afterword" "annotator" "archiveprefix" "bookauthor"
        "booksubtitle" "booktitleaddon" "commentator" "edition"
        "editora" "editorb" "editorc" "eid" "eprint" "eprintclass"
        "eprinttype" "eventdate" "eventtitle" "foreword" "holder"
        "howpublished" "introduction" "isrn" "issue" "issuesubtitle"
        "issuetitle" "issuetitleaddon" "journal" "journaltitleaddon"
        "journalsubtitle" "language" "mainsubtitle" "maintitle" "maintitleaddon"
        "month" "origlanguage" "part" "primaryclass" "remark" "subtitle" "titleaddon"
        "translator" "venue" "version" "volumes" "year")
      ebib-use-timestamp t
      biblio-bibtex-use-autokey t
      ebib-keywords my-ebib-keywords
      ebib-citation-commands
      '((latex-mode
         (("cite" "\\cite%<[%A]%>[%A]{%(%K%,)}")
          ("nocite" "\\nocite{%(%K%,)}")
          ("paren" "\\parencite%<[%A]%>[%A]{%(%K%,)}")
          ("foot" "\\footcite%<[%A]%>[%A]{%(%K%,)}")
          ("text" "\\textcite%<[%A]%>[%A]{%(%K%,)}")
          ("smart" "\\smartcite%<[%A]%>[%A]{%(%K%,)}")
          ("super" "\\supercite{%K}")
          ("auto" "\\autocite%<[%A]%>[%A]{%(%K%,)}")
          ("cites" "\\cites%<(%A)%>(%A)%(%<[%A]%>[%A]{%K}%)")
          ("parens" "\\parencites%<(%A)%>(%A)%(%<[%A]%>[%A]{%K}%)")
          ("foots" "\\footcites%<(%A)%>(%A)%(%<[%A]%>[%A]{%K}%)")
          ("texts" "\\textcites%<(%A)%>(%A)%(%<[%A]%>[%A]{%K}%)")
          ("smarts" "\\smartcites%<(%A)%>(%A)%(%<[%A]%>[%A]{%K}%)")
          ("supers" "\\supercites%<(%A)%>(%A)%(%<[%A]%>[%A]{%K}%)")
          ("autos" "\\autoscites%<(%A)%>(%A)%(%<[%A]%>[%A]{%K}%)")
          ("author" "\\citeauthor%<[%A]%>[%A]{%(%K%,)}")
          ("title" "\\citetitle%<[%A]%>[%A]{%(%K%,)}")
          ("year" "\\citeyear%<[%A]%>[%A][%A]{%K}")
          ("date" "\\citedate%<[%A]%>[%A]{%(%K%,)}")
          ("full" "\\fullcite%<[%A]%>[%A]{%(%K%,)}")))
        (org-mode
         (("ebib" "[[ebib:%K][%D]]")))
        (org-journal-mode
         (("ebib" "[[ebib:%K][%D]]")))
        (markdown-mode
         (("text" "@%K%< [%A]%>")
          ("paren" "[%(%<%A %>@%K%<, %A%>%; )]")
          ("year" "[-@%K%< %A%>]")))
        (text-mode
         (("page-citation" "%K%<, p.%A%>")
          ("timecode-citation" "%K%<, %A%>")
          ("para-citation" "%K%< \"%A\", para. %A%>")
          ("commit-message" "Notes for %K."))))
      font-latex-user-keyword-classes
      '(("cdr:minted"
         (("mintinline" "{{")
          ("inputminted" "[{{"))
         font-lock-type-face command)
        ("cdr:enquote"
         (("enquote" "{"))
         font-lock-doc-face command)
        ("cdr:cref"
         (("cref" "*{")
          ("Cref" "*{")
          ("crefrange" "*{{")
          ("Crefrange" "*{{")
          ("cpageref" "{")
          ("Cpageref" "{")
          ("cpagerefrange" "{{")
          ("Cpagerefrange" "{{")
          ("namecref" "{")
          ("nameCref" "{")
          ("lcnamecref" "{")
          ("namecrefs" "{")
          ("nameCrefs" "{")
          ("lcnamecrefs" "{")
          ("labelcref" "{")
          ("labelcpageref" "{"))
         font-lock-constant-face command)
        ("cdr:dots"
         ("dots")
         font-latex-sedate-face noarg)
        ("cdr:hyperref-stuff"
         (("hlabel" "{")
          ("href" "{{")
          ("url" "{"))
         font-lock-constant-face command)
        ("cdr:spacing"
         ("singlespacing" "doublespacing" "one-half-spacing")
         font-lock-warning-face noarg)))

;;;; SMTP/IMAP
(setq send-mail-function 'sendmail-send-it
      message-send-mail-function 'sendmail-send-it
      sendmail-program "msmtp"
      mail-specify-envelope-from t
      message-sendmail-envelope-from 'header
      mail-envelope-from 'header
      mml-secure-openpgp-signers
      '("F39CD46349A576F88EF924791102102EBE7C3AE4")
      user-mail-address ""
      mh-mml-method-default "pgp"
      mml-default-encrypt-method "pgp"
      mml-default-sign-method "pgp"
      message-sendmail-extra-arguments '("--read-envelope-from"))
(add-hook 'message-setup-hook 'mml-secure-message-sign)

;;;; MU4E
(add-to-list 'mu4e-bookmarks
             '( :name  "Non-Trashed"
                :query "not maildir:/trash and not maildir:/sent"
                :key   ?n))
(add-to-list 'mu4e-bookmarks
             '( :name  "Work"
                :query "maildir:/rodnchr/INBOX"
                :key   ?a))
(setq mu4e-contexts
      `( ,(make-mu4e-context
           :name "cdr255"
           :enter-func (lambda () (mu4e-message "Entering 'cdr255' context"))
           :leave-func (lambda () (mu4e-message "Leaving 'cdr255' context"))
           :match-func
           (lambda (msg)
             (when msg
               (string-match-p "^/cdr255"
                               (mu4e-message-field msg :maildir))))
           :vars '( ( user-mail-address	    . "cdr255@gmail.com"  )
                    ( user-full-name	    . "Christopher Rodriguez" )
                    ( mu4e-compose-signature .
                      (concat
                       "Christopher Rodriguez\n"
                       "()  ascii ribbon campaign - against html e-mail\n"
                       "/\\  www.asciiribbon.org   - against proprietary "
                       "attachments"))))
         ,(make-mu4e-context
           :name "work"
           :enter-func (lambda () (mu4e-message "Entering 'work' context"))
           :leave-func (lambda () (mu4e-message "Leaving 'work' context"))
           :match-func
           (lambda (msg)
             (when msg
               (string-match-p "^/rodnchr"
                               (mu4e-message-field msg :maildir))))
           :vars '( ( user-mail-address	     . "rodnchr@amazon.com" )
                    ( user-full-name	     . "Christopher Rodriguez" )
                    ( mu4e-compose-signature  .
                      (concat
                       "--\n\n"
                       "Christopher Rodriguez\n"))))
         ,(make-mu4e-context
           :name "school"
           :enter-func (lambda () (mu4e-message "Entering 'school' context"))
           :leave-func (lambda () (mu4e-message "Leaving 'school' context"))
           :match-func
           (lambda (msg)
             (when msg
               (string-match-p "^/csuglobal"
                               (mu4e-message-field msg :maildir))))
           :vars '( ( user-mail-address	.
                      "christopher.rodriguez@csuglobal.edu" )
                    ( user-full-name . "Christopher Rodriguez" )
                    ( mu4e-compose-signature .
                      (concat
                       "Christopher Rodriguez\n"
                       "()  ascii ribbon campaign - against html e-mail\n"
                       "/\\  www.asciiribbon.org   - against proprietary "
                       "attachments"))))
         ,(make-mu4e-context
           :name "yewscion"
           :enter-func (lambda ()
                         (mu4e-message "Entering 'yewscion' context"))
           :leave-func (lambda ()
                         (mu4e-message "Leaving 'yewscion' context"))
           :match-func
           (lambda (msg)
             (when msg
               (string-match-p "^/yewscion"
                               (mu4e-message-field msg :maildir))))
           :vars '( ( user-mail-address	     . "yewscion@gmail.com" )
                    ( user-full-name	     . "Christopher Rodriguez" )
                    ( mu4e-compose-signature .
                      (concat
                       "Christopher Rodriguez\n"
                       "()  ascii ribbon campaign - against html e-mail\n"
                       "/\\  www.asciiribbon.org   - against proprietary "
                       "attachments")))))
      mu4e-compose-context-policy nil
      mu4e-context-policy 'pick-first
      mu4e-compose-keep-self-cc t)
(define-mail-user-agent 'mu4e-user-agent
  'mu4e-compose-new
  'message-send-and-exit
  'message-kill-buffer
  'message-send-hook)

;;; Projectile
(setq cdr:my-assignment-configure-cmd
      (concat "if [ -e content.tex ]; then echo \"Sorry, it looks like this "
              "project has already been configured…\"; else echo "
              "\"Configuring this project now…\"; genpro; emacsclient "
              ".metadata; genpro -g; fi")
      cdr:my-assignment-test-cmd
      (concat "tmpdir=$(mktemp -d); find . -not -wholename './content.tex' "
              "-not -name '.assignment' -not -name '.metadata' -not -name "
              "'.projectile' -delete && mv -vt $tmpdir .assignment "
              ".projectile .metadata content.tex && genpro && mv -vt . "
              "$tmpdir/.metadata $tmpdir/.projectile $tmpdir/.assignment && "
              "emacsclient .metadata && genpro -g && mv -vt . "
              "$tmpdir/content.tex; echo \"Done.\"")
      projectile-track-known-projects-automatically nil)
(projectile-register-project-type 'genpro '(".metadata")
                                  :project-file ".metadata"
                                  :compile "genpro -p")
(projectile-register-project-type 'assignment-paper '(".assignment")
                                  :project-file ".assignment"
                                  :compile "genpro -p"
                                  :configure cdr:my-assignment-configure-cmd
                                  :test cdr:my-assignment-test-cmd)
(projectile-register-project-type 'java-ant '("build.xml")
                                  :project-file "build.xml"
                                  :compile "ant compile"
                                  :package "ant dist"
                                  :run "ant run")
(define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)

;;; Set Up UI
(add-hook 'after-make-frame-functions
          (lambda (the-new-frame)
            (progn
              (setq inhibit-startup-screen t
                  large-file-warning-threshold 100000000
                  undo-limit 16000000
                  garbage-collection-messages t
                  initial-scratch-message nil
                  display-time-24hr-format t
                  nrepl-sync-request-timeout nil
                  mark-ring-max most-positive-fixnum
                  use-file-dialog nil
                  use-dialog-box nil
                  whitespace-line-column nil
                  shell-prompt-pattern "^\\[.*\\..*\\] {..\\:..} .*\\@.*\\:*\\/\\$"
                  tramp-shell-prompt-pattern "$ "
                  show-paren-mode t
                  term-buffer-maximum-size 16384
                  term-set-terminal-size t
                  titlecase-style 'apa
                  user-full-name "Christopher Rodriguez"
                  vterm-kill-buffer-on-exit nil
                  vterm-shell "bash -l"
                  comint-use-prompt-regexp nil
                  scroll-preserve-screen-position t)
            (setq-default fill-column 74
                          indent-tabs-mode nil
                          show-trailing-whitespace nil)
            (prefer-coding-system 'utf-8)
            (menu-bar-mode 0)
            (tool-bar-mode 0)
            (scroll-bar-mode 0)
            (column-number-mode 1)
            (display-time-mode 1)
            (guru-global-mode 1)
            (global-disable-mouse-mode)
            (display-battery-mode)
            (set-face-attribute 'default nil
                                :font cdr:fonts-unifont
                                :width 'condensed
                                :height 120
                                :background yewscion-colors-black
                                :foreground yewscion-colors-white)
            (set-face-attribute 'fixed-pitch nil
                                :font cdr:fonts-unifont)
            (set-face-attribute 'header-line nil
                                :background yewscion-colors-light-grey
                                :foreground yewscion-colors-black
                                :font cdr:fonts-unifont)
            (set-face-attribute 'mode-line nil
                                :background yewscion-colors-dark-grey
                                :foreground yewscion-colors-white
                                :font cdr:fonts-unifont)
            (set-face-attribute 'org-mode-line-clock nil
                                :inherit 'header-line)
            (set-face-attribute 'term-color-black nil
                                :background yewscion-colors-black
                                :foreground yewscion-colors-black)
            (set-face-attribute 'term-color-blue nil
                                :background yewscion-colors-cyan
                                :foreground yewscion-colors-cyan)
            (set-face-attribute 'term-color-cyan nil
                                :background yewscion-colors-orange
                                :foreground yewscion-colors-orange)
            (set-face-attribute 'term-color-green nil
                                :background yewscion-colors-green
                                :foreground yewscion-colors-green)
            (set-face-attribute 'term-color-magenta nil
                                :background yewscion-colors-magenta
                                :foreground yewscion-colors-magenta)
            (set-face-attribute 'term-color-red nil
                                :background yewscion-colors-red
                                :foreground yewscion-colors-red)
            (set-face-attribute 'term-color-white nil
                                :background yewscion-colors-white
                                :foreground yewscion-colors-white)
            (set-face-attribute 'term-color-yellow nil
                                :background yewscion-colors-yellow
                                :foreground yewscion-colors-yellow)
            (set-face-attribute 'mastodon-boost-fave-face nil
                                :inherit cdr:awesome-face)
            (set-face-attribute 'mastodon-boosted-face nil
                                :inherit cdr:good-face :weight 'bold)
            (set-face-attribute 'mastodon-cw-face nil
                                :inherit cdr:warning-face)
            (set-face-attribute 'mastodon-display-name-face nil
                                :inherit cdr:info-face)
            (set-face-attribute 'mastodon-handle-face nil
                                :inherit cdr:emphasis-face)
            (set-face-attribute 'org-table nil
                                :foreground yewscion-colors-cyan
                                :width 'condensed
                                :family "Unifont"))))

;;;; Undo some defaults I don't need.
;;;;; StumpWM takes care of this for me.
(global-unset-key (kbd "C-z"))
;;;;; I don't think I'll ever use this, and
;;;;; keep getting asked about it.
(global-unset-key (kbd "C-x C-n"))
;;;;; Let me mark any variable as safe.
(advice-add 'risky-local-variable-p :override #'ignore)
;;;;; I only want warnings for errors unless I ask.
(setq warning-minimum-level :error)

(setq global-mode-string
      '("♪"
        emms-mode-line-string
        emms-playing-time-string
        " ✪ "
        display-time-string
        " ䷡"
        battery-mode-line-string
        " ✿"
        org-mode-line-string)
      display-time-default-load-average
      nil
      display-time-day-and-date
      't
      display-time-load-average-threshold
      10000)
;;; Zone Mode
(zone-when-idle 600)

;;; Persistent Scratch Mode
(setq persistent-scratch-autosave-mode t
      persistent-scratch-backup-directory "~/.emacs.d/persistent-scratch-backups/"
      persistent-scratch-backup-file-name-format "%Y-%m-%dT%H-%M-%S-%N"
      persistent-scratch-what-to-save '(major-mode point narrowing))


;;; PDFs
(setq pdf-misc-print-program-args
      '("-o media=letter" "-o fit-to-page" "-o sides=two-sided-long-edge")
      pdf-misc-print-program-executable "/usr/bin/lpr"
      pdf-annot-default-annotation-properties
      '((t
         (label . "Christopher Rodriguez"))
        (text
         (color . "brown")
         (icon . "Note"))
        (highlight
         (color . "yellow"))
        (underline
         (color . "blue"))
        (squiggly
         (color . "orange"))
        (strike-out
         (color . "red"))))

;;; Elfeed
(setq
 cdr:elfeed-urls
 '(
   ("Andy Salerno's Blog" "https://andysalerno.com/index.xml" tech blog)
   ("Elephant Town" "https://www.elephant.town/comic/rss" comic)
   ("Freedom to Tinker" "https://freedom-to-tinker.com/feed/rss/" tech politics)
   ("Friends with Benefits" "https://www.webtoons.com/en/challenge/friends-with-benefits/rss?title_no=412808" comic trans)
   ("GNU Guile News" "https://www.gnu.org/software/guile/news/feed.xml" software)
   ("GNU Guix Blog" "https://guix.gnu.org/feeds/blog.atom" software blog)
   ("Lost in Lambduhhs" "https://anchor.fm/s/581d4eb4/podcast/rss" podcast tech)
   ("Lukasz Janyst's Blog" "https://jany.st/rss.xml" tech blog)
   ("Manfred Bergmann's Blog" "http://retro-style.software-by-mabe.com/blog-atom-feed" tech blog)
   ("Musa Al-hassy's Blog" "https://alhassy.github.io/rss.xml" general blog)
   ("Pascal Costanza's Blog" "https://blog.p-cos.net" general blog)
   ("Physics::Journey" "https://p6steve.wordpress.com/rss" tech blog)
   ("Idiomdrottning" "https://idiomdrottning.org/blog" tech blog)
   ("Questionable Content" "https://www.questionablecontent.net/QCRSS.xml" comic)
   ("Serious Trans Vibes" "https://www.webtoons.com/en/challenge/serious-trans-vibes/rss?title_no=206579" comic trans)
   ("Something Positive" "https://somethingpositive.net/feed/" comic)
   ("The Prettiest Platypus" "https://www.webtoons.com/en/challenge/the-prettiest-platypus/rss?title_no=463063" comic trans)
   ("This Month in Org" "https://blog.tecosaur.com/tmio/rss.xml" tech blog)
   ("Transincidental" "https://www.webtoons.com/en/challenge/transincidental/rss?title_no=605328" comic trans)
   ("Why is a raven like a writing desk?" "https://www.elbeno.com/blog/?feed=rss2" tech blog)
   ("Wingo's Blog" "https://www.wingolog.org/feed/atom" tech computer-science)
   ("XKCD" "https://xkcd.com/atom.xml" comic)
   ("Yewscion's Blog" "https://yewscion.com/feed.xml" personal)
   ("rekado's Blog" "https://elephly.net/feed.xml" tech blog)
   ))
(setq
 cdr:podcast-urls
 '(("Planet Money" "https://feeds.npr.org/510289/podcast.xml" economics)
   ("Algorithms + Data Structures = Programs" "https://feeds.buzzsprout.com/1501960.rss" programming)
   ("ArrayCast" "https://arraycast.com/episodes?format=rss" programming)
   ("CoRecursive: Coding Stories" "https://link.chtbl.com/corecursive?id=corecursive&platform=rss" tech)
   ("Two's Complement" "https://www.twoscomplement.org/podcast/feed.xml" programming)
   ("Lost in Lambduhhs" "https://anchor.fm/s/581d4eb4/podcast/rss" tech)
   ("Eric Normand Podcast" "https://feeds.transistor.fm/thoughts-on-functional-programming-podcast-by-eric-normand" csc)
   ))

(setq elfeed-feeds
      (mapcar #'cdr
              (append
               cdr:elfeed-urls
               (mapcar (lambda (x)
                         (append x '(podcast)))
                       cdr:podcast-urls)))
      elfeed-enclosure-default-dir "/home/ming/Downloads/Elfeed/")
(setq-default
 elfeed-search-filter "@1-month-ago +unread -nsfw")

;;; Enabled Commands
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'capitalize-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)

;;; Start Pinentry
(pinentry-start)


;;; Patching BQN mode
(defun bqn-process-execute-region (start end &optional dont-follow return-output)
  (interactive "r")
  (let ((region (buffer-substring-no-properties start end))
        (session (bqn-process-ensure-session))
        (buffer (current-buffer)))
    (bqn-process-execute-region-setup start end session region)
    (bqn-process-execute-region-execute buffer)))
(defun bqn-process-execute-region-setup (start end session region)
  (when (= start end) (error (concat "Attempt to send empty region to "
                                     *bqn-process-buffer-name*)))
  (when bqn-flash-on-send (bqn--flash-region start end))
  (pop-to-buffer (process-buffer session))
  (goto-char (point-max))
  (insert (bqn-format-for-comint region return-output)))

(defun bqn-process-execute-region-execute (buffer)
  (let ((start-of-output (+ (point) 1)))
    (comint-send-input)
    (let ((result (buffer-substring-no-properties start-of-output (point-max))))
      (when (or dont-follow nil)
        (pop-to-buffer buffer))
      result)))
(defun bqn-format-for-comint (code return-output)
  (let ((prefix (if return-output ")escaped \")r " ")escaped \""))
        (suffix "\""))
    (string-join (list prefix
                       (bqn-escape-for-comint code)
                       suffix))))
(defun bqn-escape-for-comint (code)
  (replace-in-string "\n" "\\n"
                     (replace-in-string "\"" "\\\""
                                        (replace-in-string "\\" "\\\\" code))))
(define-key bqn--mode-map (kbd "C-c C-x C-e") #'bqn-process-execute-line)
(define-key bqn--mode-map (kbd "C-c C-x C-b") #'bqn-process-execute-buffer)
(define-key bqn--mode-map (kbd "C-c C-x C-e") #'bqn-process-execute-line)

(setq bqn-glyphs
      "
┌───────┬──────────────────┬──────────────────────────┬───────┬──────────────────┬─────────────────────┐
│ Glyph │ Monadic          │ Dyadic                   │ Glyph │ Monadic          │ Dyadic              │
├───────┼──────────────────┼──────────────────────────┼───────┼──────────────────┼─────────────────────┤
│ +     │ Conjugate        │ Add                      │ ⥊     │ Deshape          │ Reshape             │
│ ─     │ Negate           │ Subtract                 │ ∾     │ Join             │ Join to             │
│ ×     │ Sign             │ Multiply                 │ ≍     │ Solo             │ Couple              │
│ ÷     │ Reciprocal       │ Divide                   │ ⋈     │ Enlist           │ Pair                │
│ ⋆     │ Exponential      │ Power                    │ ↑     │ Prefixes         │ Take                │
│ √     │ Square Root      │ Root                     │ ↓     │ Suffixes         │ Drop                │
│ ⌊     │ Floor            │ Minimum                  │ ↕     │ Range            │ Windows             │
│ ⌈     │ Ceiling          │ Maximum                  │ »     │ Nudge            │ Shift Before        │
│ ∧     │ Sort Up          │ And                      │ «     │ Nudge Back       │ Shift After         │
│ ∨     │ Sort Down        │ Or                       │ ⌽     │ Reverse          │ Rotate              │
│ ¬     │ Not              │ Span                     │ ⍉     │ Transpose        │ Reorder Axes        │
│ │     │ Absolute Value   │ Modulus                  │ /     │ Indices          │ Replicate           │
│ ≤     │                  │ Less Than or Equal to    │ ⍋     │ Grade Up         │ Bins Up             │
│ <     │ Enclose          │ Less Than                │ ⍒     │ Grade Down       │ Bins Down           │
│ >     │ Merge            │ Greater Than             │ ⊏     │ First Cell       │ Select              │
│ ≥     │                  │ Greater Than or Equal to │ ⊑     │ First            │ Pick                │
│ =     │ Rank             │ Equals                   │ ⊐     │ Classify         │ Index of            │
│ ≠     │ Length           │ Not Equals               │ ⊒     │ Occurrence Count │ Progressive Index of│
│ ≡     │ Depth            │ Match                    │ ∊     │ Mark Firsts      │ Member of           │
│ ≢     │ Shape            │ Not Match                │ ⍷     │ Deduplicate      │ Find                │
│ ⊣     │ Identity         │ Left                     │ ⊔     │ Group Indices    │ Group               │
│ ⊢     │ Identity         │ Right                    │ !     │ Assert           │ Assert with Message │
└───────┴──────────────────┴──────────────────────────┴───────┴──────────────────┴─────────────────────┘")

(defvar *bqn-glyphs-buffer-name* "*BQN Glyphs*")

(defun bqn-glyph-mode-kill-buffer ()
  "Close the buffer displaying the keymap."
  (interactive)
  (let ((buffer (get-buffer *bqn-glyphs-buffer-name*)))
    (when buffer
      (delete-windows-on buffer)
      (kill-buffer buffer))))

(defvar bqn-glyph-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "q") 'bqn-glyph-mode-kill-buffer)
    map)
  "Keymap for keymap mode buffers.")

(define-derived-mode bqn-glyph-mode fundamental-mode "BQN-Glyphs"
  "Major mode for displaying the BQN Glyph help."
  (use-local-map bqn-glyph-mode-map)
  (read-only-mode 1)
  (setq truncate-lines t))

(defun bqn-show-glyphs ()
  "Display a table of BQN glyphs."
  (interactive)
  (let ((glyph-buffer (get-buffer *bqn-glyphs-buffer-name*)))
    (unless (and glyph-buffer (get-buffer-window glyph-buffer))
      ;; The buffer is not displayed.
      (let* ((buffer (get-buffer-create *bqn-glyphs-buffer-name*))
             (window (split-window nil)))
        (with-current-buffer buffer
          (insert bqn-glyphs)
          (goto-char (point-min))
          (bqn-glyph-mode))
        (set-window-buffer window buffer)
        (fit-window-to-buffer window)))))

(defvar bqn-keyboard-map
  "
┌────┬────┬────┬────┬────┬────┬────┬────┬────┬────┬────┬────┬────┬─────────┐
│~ ¬ │! ⎉ │@ ⚇ │# ⍟ │$ ◶ │% ⊘ │^ ⎊ │& ⍎ │* ⍕ │( ⟨ │) ⟩ │_ √ │+ ⋆ │Backspace│
│` ˜ │1 ˘ │2 ¨ │3 ⁼ │4 ⌜ │5 ´ │6 ˝ │7   │8 ∞ │9 ¯ │0 • │- ÷ │= × │         │
├────┴──┬─┴──┬─┴──┬─┴──┬─┴──┬─┴──┬─┴──┬─┴──┬─┴──┬─┴──┬─┴──┬─┴──┬─┴──┬──────┤
│Tab    │Q ↙ │W 𝕎 │E ⍷ │R 𝕣 │T ⍋ │Y   │U   │I ⊑ │O ⊒ │P ⍳ │{ ⊣ │} ⊢ │|     │
│       │q ⌽ │w 𝕨 │e ∊ │r ↑ │t ∧ │y   │u ⊔ │i ⊏ │o ⊐ │p π │[ ← │] → │\\     │
├───────┴┬───┴┬───┴┬───┴┬───┴┬───┴┬───┴┬───┴┬───┴┬───┴┬───┴┬───┴─┬──┴──────┤
│Caps    │A ↖ │S 𝕊 │D   │F 𝔽 │G 𝔾 │H « │J   │K ⌾ │L » │: · │\" ˙  │Enter    │
│Lock    │a ⍉ │s 𝕤 │d ↕ │f 𝕗 │g 𝕘 │h ⊸ │j ∘ │k ○ │l ⟜ │; ⋄ │' ↩  │         │
├────────┴──┬─┴──┬─┴──┬─┴──┬─┴──┬─┴──┬─┴──┬─┴──┬─┴──┬─┴──┬─┴──┬──┴─────────┤
│Shift      │Z ⋈ │X 𝕏 │C   │V ⍒ │B ⌈ │N   │M ≢ │< ≤ │> ≥ │? ⇐ │Shift       │
│           │z ⥊ │x 𝕩 │c ↓ │v ∨ │b ⌊ │n   │m ≡ │, ∾ │. ≍ │/ ≠ │            │
└───────────┴────┴────┴────┴────┴────┴────┴────┴────┴────┴────┴────────────┘
                             Space: ‿
"
  "Keyboard map for BQN.")


;; Maps


;;; Refcards
(setq cdr:refcards-alist
      '(("Combinators"
         "~/.local/share/refcards/combinators.txt")
        ("Eisenhower Decision Matrix"
         "~/.local/share/refcards/eisenhower-decision-matrix.txt")
        ("GTD Mind Sweep"
         "~/.local/share/refcards/gtd-worksheet.txt")))

;;; Last Preloads
;;; Prefixes
(define-prefix-command 'template-map)
(define-prefix-command 'latex-template-map)
(define-prefix-command 'subprocess-map)
(define-prefix-command 'imperative-map)
(define-prefix-command 'transform-map)
(define-prefix-command 'imperative-org-map)
(define-prefix-command 'orgy-open-journal-map)

;;; Template Map <F5>

(define-key template-map (kbd "C-a") #'cdr:templates-insert-agda-docstring)
(define-key template-map (kbd "C-b") #'cdr:templates-insert-blog-post)
(define-key template-map (kbd "C-c") #'cdr:templates-insert-spaced-repetition-card)
(define-key template-map (kbd "C-d") #'cdr:templates-insert-dir-locals)
(define-key template-map (kbd "C-i") #'cdr:templates-insert-texinfo-chapter)
(define-key template-map (kbd "C-j") #'cdr:templates-insert-java-field-docstring)
(define-key template-map (kbd "C-o") #'cdr:templates-insert-texinfo-subsection)
(define-key template-map (kbd "l") #'latex-template-map)
(define-key template-map (kbd "C-l") #'latex-template-map)
(define-key template-map (kbd "G") #'cdr:templates-insert-guile-script)
(define-key template-map (kbd "a") #'cdr:templates-insert-apl-docstring)
(define-key template-map (kbd "b") #'cdr:templates-insert-bib-annotation)
(define-key template-map (kbd "c") #'cdr:templates-insert-autoconf-commentable-header)
(define-key template-map (kbd "d") #'cdr:templates-insert-scm-docstring)
(define-key template-map (kbd "g") #'cdr:templates-insert-guix-package)
(define-key template-map (kbd "h") #'cdr:templates-insert-org-header)
(define-key template-map (kbd "i") #'cdr:templates-insert-texinfo-procedure-definition)
(define-key template-map (kbd "j") #'cdr:templates-insert-java-method-docstring)
(define-key template-map (kbd "o") #'cdr:templates-insert-texinfo-section)
(define-key template-map (kbd "s") #'cdr:templates-insert-setup)
(define-key template-map (kbd "r") #'cdr:display-refcard-menu)
(define-key template-map (kbd "C-r") #'cdr:display-refcard-menu)

;;; LaTeX Template Map C-<F5> l or C-<F5> C-l
(define-key latex-template-map (kbd "i") #'cdr:templates-insert-latex-figure-image)
(define-key latex-template-map (kbd "l") #'cdr:templates-insert-latex-figure-list)
(define-key latex-template-map (kbd "a") #'cdr:templates-insert-latex-appendix-listings)

;;; Subprocess Map <F4>
(define-key subprocess-map (kbd "C-g") #'run-geiser)
(define-key subprocess-map (kbd "C-p") #'run-python)
(define-key subprocess-map (kbd "a") #'gnu-apl)
(define-key subprocess-map (kbd "b") #'run-bqn)
(define-key subprocess-map (kbd "c") #'cider)
(define-key subprocess-map (kbd "e") #'eshell)
(define-key subprocess-map (kbd "g") #'run-guile)
(define-key subprocess-map (kbd "j") #'run-janet)
(define-key subprocess-map (kbd "l") #'lsp)
(define-key subprocess-map (kbd "p") #'run-prolog)
(define-key subprocess-map (kbd "r") #'run-ruby)
(define-key subprocess-map (kbd "s") #'slime)
(define-key subprocess-map (kbd "v") #'vterm-toggle)
(define-key subprocess-map (kbd "o") #'tuareg-run-ocaml)

;;; Imperative Map <F3>
(define-key imperative-map (kbd "C-o") #'imperative-org-map)
(define-key imperative-map (kbd "C-w") #'compost-transplant)
(define-key imperative-map (kbd "C-y") #'yank-from-primary)
(define-key imperative-map (kbd "C-a") #'beginning-of-line)
(define-key imperative-map (kbd "b") #'switch-to-buffer)
(define-key imperative-map (kbd "c") #'whitespace-cleanup)
(define-key imperative-map (kbd "d") #'make-directory)
(define-key imperative-map (kbd "f") #'fill-buffer)
(define-key imperative-map (kbd "o") #'imperative-org-map)
(define-key imperative-map (kbd "p") #'cdr:prep-latex-for-copy)
(define-key imperative-map (kbd "r") #'revert-buffer-quick)
(define-key imperative-map (kbd "s") #'cdr:cleanup-script-output)
(define-key imperative-map (kbd "v") #'add-file-local-variable)
(define-key imperative-map (kbd "w") #'whitespace-report)
(define-key imperative-map (kbd "y") #'cdr:paste-commit-and-update-hash)

;;; Imperative Org Map <F3> o / <F3> C-o
(define-key imperative-org-map (kbd "C-j") #'orgy-open-journal-map)
(define-key imperative-org-map (kbd "C-l") #'cdr:orgy-remove-empty-list-items)
(define-key imperative-org-map (kbd "C-h") #'cdr:hog-it)
(define-key imperative-org-map (kbd "h") #'cdr:hog-it)
(define-key imperative-org-map (kbd "i") #'cdr:orgy-copy-item)
(define-key imperative-org-map (kbd "j") #'cdr:make-daily-journal-entry)
(define-key imperative-org-map (kbd "l") #'cdr:orgy-copy-rest-of-list)
(define-key imperative-org-map (kbd "n") #'orgy-cm-step-next)
(define-key imperative-org-map (kbd "o") #'cdr:edit-region-as-org)
(define-key imperative-org-map (kbd "w") #'org-copy-src-block)

;;; Orgy open journal Map <F3> o C-j / <F3> C-o C-j
(define-key orgy-open-journal-map (kbd "C-j") #'cdr:orgy-open-journal-today)
(define-key orgy-open-journal-map (kbd "C-t") #'cdr:orgy-open-journal-today)
(define-key orgy-open-journal-map (kbd "C-w") #'cdr:orgy-open-journal-last-week)
(define-key orgy-open-journal-map (kbd "C-y") #'cdr:orgy-open-journal-yesterday)
(define-key orgy-open-journal-map (kbd "j") #'cdr:orgy-open-journal-today)
(define-key orgy-open-journal-map (kbd "t") #'cdr:orgy-open-journal-today)
(define-key orgy-open-journal-map (kbd "w") #'cdr:orgy-open-journal-last-week)
(define-key orgy-open-journal-map (kbd "y") #'cdr:orgy-open-journal-yesterday)

;;; Transform Map <F2>
(define-key transform-map (kbd "<tab>") #'indent-relative)
(define-key transform-map (kbd "C-r") #'replace-regexp)
(define-key transform-map (kbd "C-u") #'unfill-toggle)
(define-key transform-map (kbd "C-w") #'cdr:copy-unfilled-region)
(define-key transform-map (kbd "d") #'downcase-dwim)
(define-key transform-map (kbd "f") #'cdr:fill-sexp)
(define-key transform-map (kbd "i") #'edit-indirect-region)
(define-key transform-map (kbd "n") #'cdr:clean-up-newlines)
(define-key transform-map (kbd "r") #'replace-string)
(define-key transform-map (kbd "t") #'titlecase-dwim)
(define-key transform-map (kbd "u") #'upcase-dwim)

;; Keys

;;; Function (Major Modes)

;(global-set-key (kbd "<f1>") nil) ; Help prefix
;(global-set-key (kbd "<f2>") nil) ; 2 Column prefix
;(global-set-key (kbd "<f3>") nil) ; Define Macros
;(global-set-key (kbd "<f4>") nil) ; Run Macro
(global-set-key (kbd "<f5>") 'emms)
(global-set-key (kbd "<f6>") 'ebib)
(global-set-key (kbd "<f7>") 'ispell)
(global-set-key (kbd "<f8>") 'elfeed)
(global-set-key (kbd "<f9>") 'org-agenda)
;(global-set-key (kbd "<f10>") nil) ; GUI Menu Key
;(global-set-key (kbd "<f11>") nil) ; GUI Fullscreen
(global-set-key (kbd "<f12>") 'mu4e)

;;; Ctrl Function (Maps)

(global-set-key (kbd "C-<f1>") nil)
(global-set-key (kbd "C-<f2>") 'transform-map)
(global-set-key (kbd "C-<f3>") 'imperative-map)
(global-set-key (kbd "C-<f4>") 'subprocess-map)
(global-set-key (kbd "C-<f5>") 'template-map)
(global-set-key (kbd "C-<f6>") 'compost-prefix)
(global-set-key (kbd "C-<f7>") nil)
(global-set-key (kbd "C-<f8>") nil)
(global-set-key (kbd "C-<f9>") nil)
;; (global-set-key (kbd "C-<f10>") nil) ; Non-Functional
(global-set-key (kbd "C-<f11>") nil)
(global-set-key (kbd "C-<f12>") nil)

;;; Meta Function (Misc)

(global-set-key (kbd "M-<f1>") 'org-pomodoro)
(global-set-key (kbd "M-<f2>") 'ebib-insert-citation)
(global-set-key (kbd "M-<f3>") 'calendar)
(global-set-key (kbd "M-<f4>") nil) ; Close Program
(global-set-key (kbd "M-<f5>") 'emms-browser)
(global-set-key (kbd "M-<f6>") 'cdr:ebiby-toggle-citation-style)
(global-set-key (kbd "M-<f7>") 'ispell)
(global-set-key (kbd "M-<f8>") 'mastodon)
(global-set-key (kbd "M-<f9>") nil)
;; (global-set-key (kbd "M-<f10>") nil) ; Non-Functional
(global-set-key (kbd "M-<f11>") nil)
(global-set-key (kbd "M-<f12>") nil)

;;; Super (Minor Modes/Mode Functions)

;; (global-set-key (kbd "s-q") nil) ; GNOME ?
(global-set-key (kbd "s-w") 'whitespace-mode)
(global-set-key (kbd "s-e") 'show-paren-mode)
(global-set-key (kbd "s-n") 'display-line-numbers-mode)
;; (global-set-key (kbd "s-t") 'vterm-toggle) Moving to Subprocess Map
(global-set-key (kbd "s-y") #'cdr:yank-as-comment)
;; (global-set-key (kbd "s-u") 'unfill-paragraph) Moving to Transform Map
;; (global-set-key (kbd "s-i") nil)
;; (global-set-key (kbd "s-o") nil) ; GNOME ?
;; (global-set-key (kbd "s-p") nil) ; GNOME ?
;; (global-set-key (kbd "s-a") nil) ; GNOME Application Menu
;; (global-set-key (kbd "s-s") nil) ; GNOME Switch Window Menu
;; (global-set-key (kbd "s-d") nil) ; GNOME Show Desktop
(global-set-key (kbd "s-f") 'display-fill-column-indicator-mode)
;; (global-set-key (kbd "s-g") 'cdr:run-genpro-and-update) Unneeded now
;; (global-set-key (kbd "s-h") nil) ; GNOME ?
(global-set-key (kbd "s-j") nil)
(global-set-key (kbd "s-k") 'cdr:kill-buffer)
;; (global-set-key (kbd "s-l") nil) ; GNOME Lock Screen
(global-set-key (kbd "s-z") nil)
(global-set-key (kbd "s-x") (lambda () (interactive) (switch-to-buffer
                                                      "*scratch*")))
;; (global-set-key (kbd "s-c") 'copy-unfilled-subtree) → Imperative Map
;; (global-set-key (kbd "s-v") nil) ; GNOME Show Notifications
(global-set-key (kbd "s-b") nil)
;; (global-set-key (kbd "s-n") nil) ; GNOME ?
;; (global-set-key (kbd "s-m") nil) ; GNOME ?
(global-set-key (kbd "s-;") 'projectile-mode)
(global-set-key (kbd "s-<tab>") 'ediprolog-dwim)

;;; Audio Controls
(global-set-key (kbd "<XF86AudioPrev>") 'emms-previous)
(global-set-key (kbd "<XF86AudioNext>") 'emms-next)
(global-set-key (kbd "<XF86AudioPlay>") 'emms-pause)

(global-set-key (kbd "C-<XF86AudioPlay>") 'emms-stop)

(global-set-key (kbd "M-<XF86AudioPlay>") 'emms-shuffle)
(global-set-key (kbd "M-s-<XF86AudioPlay>") (lambda () (interactive)
                                              (emms-play-directory
                                               "~/Music/MIDI/OST")))

;;; Mode-specific Keybindings Made Global
(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "C-;") 'iedit-mode)

;;; Alterations to mode-specific keymaps
(define-key dired-mode-map (kbd "C-c C-c") #'cdr:diredy-xdg-open)
(define-key text-mode-map (kbd "C-c C-c") #'(lambda nil (interactive)
                                              (progn
                                                (save-buffer)
                                                (kill-current-buffer))))
(add-hook 'forms-mode-hook (lambda nil
                             (local-set-key (kbd "C-c C-c C-c")
                                            #'(lambda nil (interactive)
                                                (forms-save-buffer)
                                                (kill-current-buffer)))))
(define-key pdf-view-mode-map (kbd "s-<mouse-1>") #'compost-annotation-new)
(define-key pdf-view-mode-map (kbd "s-<mouse-3>") #'compost-annotation-done)
(define-key ebib-entry-mode-map (kbd "C") #'ebib-follow-crossref)
(define-key ebib-index-mode-map (kbd "B") #'ebib-biblio-import-doi)
(define-key org-mode-map (kbd "s-<return>") #'org-open-at-point)
(define-key org-mode-map (kbd "M-p") #'org-metaup)
(define-key org-mode-map (kbd "M-n") #'org-metadown)
(define-key org-mode-map (kbd "M-[") #'org-metaleft)
(define-key org-mode-map (kbd "M-]") #'org-metaright)
(define-key org-mode-map (kbd "M-s-p") #'org-shiftmetaup)
(define-key org-mode-map (kbd "M-s-n") #'org-shiftmetadown)
(define-key org-mode-map (kbd "M-s-[") #'org-shiftmetaleft)
(define-key org-mode-map (kbd "M-s-]") #'org-shiftmetaright)
(define-key org-mode-map (kbd "M-<up>") nil)
(define-key org-mode-map (kbd "M-<down>") nil)
(define-key org-mode-map (kbd "M-<left>") nil)
(define-key org-mode-map (kbd "M-<right>") nil)
(define-key org-mode-map (kbd "M-S-<up>") nil)
(define-key org-mode-map (kbd "M-S-<down>") nil)
(define-key org-mode-map (kbd "M-S-<left>") nil)
(define-key org-mode-map (kbd "M-S-<right>") nil)
(define-key elfeed-show-mode-map (kbd "C-c C-C") #'cdr:shry-save-image)

;;; Ensure paths are set properly
(cdr:set-variable-from-shell "HOME")
(cdr:set-variable-from-shell "PATH")
(cdr:set-variable-from-shell "CLASSPATH")
(cdr:set-variable-from-shell "PYTHONPYCACHEPREFIX")
(setq exec-path (split-string (getenv "PATH") path-separator))

(pdf-loader-install)
(add-hook 'TeX-after-compilation-finished-functions
          #'TeX-revert-document-buffer)

;;; Load Pseudotaxus Mode

;;; Last Minute Settings
;;;; BQN glyphs
(cdr:set-glyphs-for-bqn)
;;;; Header Line and Mode Line
(add-hook 'buffer-list-update-hook
          'cdr:display-header-line)
(add-hook 'buffer-list-update-hook
          'cdr:display-mode-line)

;; Local Variables:
;; mode: emacs-lisp
;; End:
