(if (string-equal system-type "windows-nt")
    (progn (setenv "HOME" "c:/Users/rodnchr")))

(setq custom-file "~/.emacs.d/custom.el")

;;; Package System
(require 'package)
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("nongnu" . "https://elpa.nongnu.org/nongnu/")
                         ("melpa" . "https://melpa.org/packages/")
                         ("melpa-stable" . "https://stable.melpa.org/packages/")))
(package-initialize)
;;; Local Elisp
(add-to-list 'load-path "~/.emacs.d/lisp/")

;;; Regex Builder Config
(require 're-builder)
(setq reb-re-syntax 'string)

  ;;; EMMS Config
(require 'emms-setup)
(require 'emms-player-mpv)
(require 'emms-player-simple)
(require 'emms-streams)
(require 'emms-mode-line-cycle)
(emms-all)
(emms-default-players)
(emms-mode-line-cycle 0)
(define-emms-simple-player xmp '(file)
  (regexp-opt '(".669" ".AMF" ".DSM" ".FAR" ".GDM" ".IT" ".IMF"
		".MED" ".MTM" ".OKT" ".S3M" ".STM" ".STX" ".ULT"
		".APUN" ".XM" ".MOD" ".amf" ".dsm" ".far" ".gdm"
		".it" ".imf" ".mod" ".med" ".mtm" ".okt" ".s3m"
		".stm" ".stx" ".ult" ".apun" ".xm" ".mod" ".MOD"))
  "xmp" "--nocmd")
(define-emms-simple-player adlmidi '(file)
  (regexp-opt '(".mid"))
  "adlmidi-wrapper" "-nl")
(setq emms-source-file-default-directory
      "~/Music/"

      emms-player-list
      '(emms-player-mpv
	emms-player-xmp
        emms-player-adlmidi
	emms-player-timidity) ; Reverse Order of Precedence

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
      emms-mode-line-mode-line-function #'cdr:emms-describe-track)

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
      inferior-julia-program-name "julia"
      geiser-default-implementation 'guile
      python-shell-interpreter "python3"
      inf-janet-program "janet -s")

(setq-default geiser-scheme-implementation 'guile)

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
(setq mastodon-instance-url "https://tech.lgbt/")

;;; ANSI Color
(setq ansi-color-faces-vector
      [default default default
        italic underline success
        warning error])

;;; Dired
(setq dired-listing-switches "-aDFhikmopqs")
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

;;; Load Local Custom
(load "~/.emacs.d/custom.el")

;;; Functions

(defun copy-lines-matching-re (re)
  "find all lines matching the regexp RE in the current region
     putting the matching lines in a buffer named *matching*"
  (interactive "sRegexp to match: ")
  (let ((result-buffer (get-buffer-create "*matching*")))
    (with-current-buffer result-buffer
      (erase-buffer))
    (save-match-data
      (save-excursion
        (save-restriction
          (narrow-to-region (region-beginning) (region-end))
          (goto-char (point-min))
          (while (re-search-forward re nil t)
            (princ
             (string-trim
              (buffer-substring-no-properties
               (line-beginning-position)
               (line-beginning-position 2))
              "[ \t\r]+" "[ \t\r]+")
             result-buffer)))))
    (pop-to-buffer result-buffer)))

;;; Stefan Monnier <foo at acm.org>. Opposite of fill-paragraph
(defun unfill-paragraph (&optional region)
  "Takes a multi-line paragraph and converts
     it into a single line of text."
  (interactive (progn (barf-if-buffer-read-only) '(t)))
  (let ((fill-column (point-max))
        ;; This would override `fill-column' if it's an integer.
        (emacs-lisp-docstring-fill-column t))
    (fill-paragraph nil region)))

;;; ggrocca and Iqbal Ansari from
;;; https://emacs.stackexchange.com
;;; /questions/3981/how-to-copy-links-out-of-org-mode

(defun org-link-grab-url ()
  (interactive)
  (let* ((link-info (assoc :link (org-context)))
         (text (when link-info
                 (buffer-substring-no-properties
                  (or (cadr link-info) (point-min))
                  (or (caddr link-info) (point-max))))))
    (if (not text)
        (error "Not in org link")
      (string-match org-bracket-link-regexp text)
      (kill-new (substring text (match-beginning 1) (match-end 1))))))

(defun my-kill-org-link (text)
  (if (derived-mode-p 'org-mode)
      (insert text)
    (string-match org-bracket-link-regexp text)
    (insert (substring text (match-beginning 1) (match-end 1)))))

(defun my-org-retrieve-url-from-point ()
  (interactive)
  (let* ((link-info (assoc :link (org-context)))
         (text (when link-info
                 ;; org-context seems to return nil
                 ;; if the current element starts at
                 ;; buffer-start or ends at buffer-end
                 (buffer-substring-no-properties
                  (or (cadr link-info) (point-min))
                  (or (caddr link-info) (point-max))))))
    (if (not text)
        (error "Not in org link")
      (add-text-properties 0 (length text)
                           '(yank-handler (my-yank-org-link)) text)
      (kill-new text))))

;;; Dan from https://emacs.stackexchange.com/a/18110

(defun fill-buffer ()
  (interactive)
  (save-excursion
    (save-restriction
      (widen)
      (fill-region (point-min) (point-max)))))

;;; http://ergoemacs.org/emacs/elisp_read_file_content.html
(defun get-string-from-file (filePath)
  "Return filePath's file content."
  (with-temp-buffer
    (insert-file-contents filePath)
    (buffer-string)))
(defun read-lines (filePath)
  "Return a list of lines of a file at filePath."
  (with-temp-buffer
    (insert-file-contents filePath)
    (split-string (buffer-string) "\n" t)))

;;; Orgy, functions that help me work in Org Mode (Self Defined)

(defun orgy-insert-cm-step-properties ()
  "Inserts the default properties for a CM step under the current
     heading."
  (interactive)
  (org-entry-put (point) "Duration" "10m")
  (org-entry-put (point) "Type" "Activity")
  (org-entry-put (point) "CNCE" "None")
  (sit-for 1)
  )

(defun orgy-insert-cm-step-subheadings ()
  "Inserts the default headings for a step, populated with empty
lists."
  (interactive)
  (next-line 1)
  (move-end-of-line nil)
  (insert "
        #+begin_src markdown
          Example Text.
        #+end_src
")
  (move-beginning-of-line nil)
  (org-insert-heading-respect-content)
  (org-do-demote)
  (insert "Activity Checklist
        - Item x 1
        - or
        - Title
          #+begin_src markdown
            Example Text.
          #+end_src
******* Rollback Checklist
        - Item x 1
        - or
        - Title
          #+begin_src markdown
            Example Text.
          #+end_src")
  (forward-line -19)
  )

(defun orgy-setup-cm-step ()
  "Turns the current heading into a CM Step."
  (interactive)
  (orgy-insert-cm-step-properties)
  (orgy-insert-cm-step-subheadings)
  )

(defun orgy-lookup-property (key default)
  (interactive)
  "Takes a Key and returns the Value stored in the matching
  Property of the Org Entry at Point."
  (let ((properties (org-entry-properties)))
    (if (string-empty-p
         (concat (cdr (assoc key properties)))
         )
        default
      (concat (cdr (assoc key properties))))))

(defun orgy-property-from-table-if-not-empty
    (property list value-number header-level)
  "Returns a property line of format 'property: value' with the
      value pulled from a list."
  (if
      (not (eq (nth value-number list) ""))
      (format "%s:%s: %s\n"
              (orgy-indent-header-level header-level)
              property
              (nth value-number list))))

(defun orgy-heading-summary (status list value-number header-level)
  "Returns an Org heading based on supplied values."
  (if
      (not (eq (nth value-number list) ""))
      (format "%s %s %s\n"
              (make-string header-level (char-from-name "ASTERISK"))
              (upcase status)
              (if (> (string-width (nth value-number list)) 50)
                  (substring (nth value-number list) 0 50)
                (nth value-number list)))
    (format "%s %s %s\n"
            (make-string header-level (char-from-name "ASTERISK"))
            "TODO"
            "Generic Heading                           :fixme:"
            )))

(defun orgy-row-to-entry
    (list header-level value-number-for-header
          value-number-for-description list-of-properties status)
  (interactive)
  "For use in Org-Babel. Returns a string which will print a
      row's values as an Org Entry."
  (let ((list-length (length list))
        (prop-length (length list-of-properties))
        (header-string
         (orgy-heading-summary status list
                               value-number-for-header header-level))
        (header-indent (orgy-indent-header-level header-level)))
    (if (not (eq list-length prop-length))
        (message
         (format "Row/Property Length Mismatch! Row: %d Prop: %d"
                 list-length prop-length))
      (concat
       header-string
       header-indent
       ":PROPERTIES:\n"
       (orgy-row-to-properties list list-of-properties header-level)
       header-indent
       ":END:\n\n"
       header-indent
       (nth value-number-for-description list)
       "\n\n"))))

(defun orgy-row-to-properties (value-list property-list header-level)
  "Takes two lists, and create the contents of a :PROPERTIES:
      drawer out of them in the form :property-list: value-list,
      indented by the given header-level."
  (if value-list
      (concat
       (if (not (eq (car value-list) ""))
           (format "%s:%s: %s\n"
                   (orgy-indent-header-level header-level)
                   (car property-list)
                   (car value-list)))
       (orgy-row-to-properties
        (cdr value-list)
        (cdr property-list)
        header-level))))

(fset 'cdr:orgy-pull-task-clock-to-hog
      (kmacro-lambda-form [?\C-c ?\C-e ?\C-b ?\C-s
                                 ?t ?A ?\C- ?\C-s ?\C-q ?\C-j
                                 ?\C-q ?\C-j return ?\M-w ?\C-x
                                 ?k return ?\C-x ?\C-o ?\C-x ?0
                                 ?\M-< ?\C-s ?* ?  ?H ?O ?G
                                 return tab return ?\C-a ?\M-x ?h
                                 ?o ?g ?- ?s ?k ?e ?l tab return
                                 ?\C-r ?< ?p ?r ?e ?> return
                                 ?\C-n ?\C-c ?\' ?\C-y backspace
                                 backspace ?\C-c ?\' ?\C-c ?\C-p]
                          0 "%d"))

(fset 'cdr:orgy-pull-inbox-for-hog
      (kmacro-lambda-form [?\C-s ?* ?* ?  ?I ?n ?b ?o ?x return
                                 ?\M-h ?\M-w ?\C-r ?s ?r ?c ?  ?o
                                 ?r ?g return ?\C-c ?\' ?\C-y
                                 ?\M-x ?o ?r ?g ?- ?s ?h ?o ?w ?-
                                 ?a ?l ?l return ?\M-< ?\C-k
                                 ?\C-d ?\C-c ?\' ?\C-c ?\' ?\C-c
                                 ?\' ?\C-r ?H ?O ?G return]
                          0 "%d"))

(fset 'cdr:orgy-clear-hog-inbox
      (kmacro-lambda-form [?\C-s ?* ?* ?  ?I ?n ?b ?o ?x return
                                 ?\M-h ?\C-w ?\C-r ?* ?  ?h ?o ?g
                                 return ?\C-e return backspace
                                 backspace ?* ?* ?  ?I ?n ?b ?o
                                 ?x return ?- ?  ?\M-x ?o ?r ?g
                                 ?- ?o ?v ?e ?r ?v ?i ?e ?w
                                 return]
                          0 "%d"))

(defun cdr:hog-it ()
  "Populate a HOG report in my workdesk.org file."
  (interactive)
  (progn (end-of-buffer)
         (search-backward "* Tasks")
         (cdr:orgy-pull-task-clock-to-hog)
         (cdr:orgy-pull-inbox-for-hog)
         (cdr:orgy-clear-hog-inbox)
         (message "🐖 Hogging it! 🐖")))

;;; Misc
(defun i-ching-pull ()
  "Casts and Displays the Interpretation of a Hexagram."
  (interactive)
  (let ((cast (i-ching-interpretation (i-ching-cast)))
        (reading-buffer (get-buffer-create "*I Ching*")))
    (with-current-buffer reading-buffer
      (erase-buffer)
      (text-mode)
      (insert cast)
      (fill-individual-paragraphs (point-min) (point-max)))
    (display-buffer reading-buffer))
  t)

(defun org-copy-src-block ()
  "Copies the entire contents of a source or example block as if
      it were the entirety of the buffer."
  (interactive)
  (org-edit-src-code)
  (mark-whole-buffer)
  (easy-kill 1)
  (org-edit-src-abort))

(fset 'orgy-cm-step-next
      (kmacro-lambda-form [?\C-c ?\C-p ?\C-c ?\C-p ?\C-c
                                 ?\C-p ?\M-f ?\C-f tab ?\C-n]
                          0 "%d"))

(defun emmsy-toggle-midi-player ()
  "Toggles between Timidity and ADLMidi without needing to type
      it out every time."
  (interactive)
  (if (equal (cadddr emms-player-list) 'emms-player-timidity)
      (progn (message "Changing MIDI player to ADLMidi!")
             (setq emms-player-list
                   '(emms-player-mpv
                     emms-player-xmp
                     emms-player-timidity
                     emms-player-adlmidi)))
    (progn (message "Changing MIDI player to Timidity!")
           (setq emms-player-list
                 '(emms-player-mpv
                   emms-player-xmp
                   emms-player-adlmidi
                   emms-player-timidity)))))

;;; EMMS Description Shims.
(defun cdr:emms-track-description (track)
  "Isolates the filename of TRACK if timidity or xmp could play it."
  (if (or (emms-player-timidity-playable-p track)
          (emms-player-xmp-playable-p track))
      (car (last (split-string (cdr (assoc 'name track)) "/")))
    (emms-info-track-description track)))

(defun cdr:emms-describe-track ()
  "Describe the currently playing track with metadata unless it is
      a MIDI/MOD file, in which case it will be just the file name."
  (format emms-mode-line-format (cdr:emms-track-description
                                 (emms-playlist-current-selected-track))))

;;; Header Line Format Function
(defun cdr:display-header-line ()
  (unless (or (string-equal (symbol-name major-mode) "ebib-entry-mode")
              (not (equal nil (member 'lsp-headerline-breadcrumb-mode minor-mode-list))))
    (setq header-line-format
          '("%e" mode-line-misc-info))))

;;; Mode Line Formate Function
(defun cdr:display-mode-line ()
  (unless (string-equal (substring (symbol-name major-mode) 0 4) "ebib")
    (setq mode-line-format '("%e" mode-line-front-space
                             mode-line-mule-info
                             mode-line-client
                             mode-line-modified
                             mode-line-remote
                             mode-line-frame-identification
                             mode-line-buffer-identification
                             "   "
                             mode-line-position
                             (vc-mode
                              vc-mode)
                             " "
                             mode-line-modes
                             mode-line-end-spaces))))

(defun random-thing-from-a-file (f)
  (interactive "Load Thing from: ")
  (random t)
  (save-excursion
    (find-file f)
    (let ((line-num (random (count-lines (point-min) (point-max)))))
      (goto-line line-num)
      (let ((result (buffer-substring (line-beginning-position) (line-end-position))))
        (kill-buffer (current-buffer))
        result))))

(defun my:journal-prompt ()
  (interactive)
  (let* ((thing (random-thing-from-a-file "~/Documents/journal-prompts.txt")))
    (message
     (concat "Journal Prompt for Today: "
             thing))))

;; Pull from PRIMARY (same as middle mouse click)
(defun yank-from-primary ()
  (interactive)
  (insert
   (gui-get-primary-selection)))

(defun cdr:orgy-copy-unfilled-subtree ()
  "Kills the subtree at point after unfilling it. Meant to be
  used for transferring information to other sources that
  expect unfilled (line-wrapped) input."
  (interactive)
  (cdr:orgy-mark-subtree)
  (cdr:copy-unfilled-region)
  (org-previous-visible-heading 1)
  (message "Copied Unfilled Subtree!"))

(defun cdr:orgy-mark-subtree ()
  "Marks the entirety of the contents of the current subtree, but
not the heading."
  (interactive)
  (org-previous-visible-heading 1)
  (org-mark-subtree)
  (next-line))

(defun cdr:copy-unfilled-region (&optional region-start region-end)
  "Non-destructively kills the current region in an unfilled
state, for transfer to a system that expects such input."
  (interactive)
  (let ((region-start
         (or region-start (region-beginning)))
        (region-end
         (or region-end (region-end))))
    (unfill-region region-start region-end)
    (kill-ring-save region-start region-end)
    (fill-region region-start region-end)))

(defun kill-matching-lines (regexp &optional rstart rend interactive)
  "Kill lines containing matches for REGEXP.

See `flush-lines' or `keep-lines' for behavior of this command.

If the buffer is read-only, Emacs will beep and refrain from deleting
the line, but put the line in the kill ring anyway.  This means that
you can use this command to copy text from a read-only buffer.
\(If the variable `kill-read-only-ok' is non-nil, then this won't
even beep.)"
  (interactive
   (keep-lines-read-args "Kill lines containing match for regexp"))
  (let ((buffer-file-name nil)) ;; HACK for `clone-buffer'
    (with-current-buffer (clone-buffer nil nil)
      (let ((inhibit-read-only t))
        (keep-lines regexp rstart rend interactive)
        (kill-region (or rstart (line-beginning-position))
                     (or rend (point-max))))
      (kill-buffer)))
  (unless (and buffer-read-only kill-read-only-ok)
    ;; Delete lines or make the "Buffer is read-only" error.
    (flush-lines regexp rstart rend interactive)))

(defun cdr:diredy-hide-dotfiles ()
  "Removes the 'a' flag from dired-listing-switches."
  (interactive)
  (setq dired-listing-switches "-DFhikmopqs"))
(defun cdr:diredy-show-dotfiles ()
  "Adds the 'a' flag from dired-listing-switches."
  (interactive)
  (setq dired-listing-switches "-aDFhikmopqs"))

(defun cdr:templates-insert-scm-docstring ()
  "Inserts a docstring at the current position."
  (interactive)
  (insert-file-contents "~/.emacs.d/templates/scheme-docstring.txt"))
(defun cdr:templates-insert-org-header ()
  "Inserts my org header at the current position."
  (interactive)
  (insert-file-contents "~/.emacs.d/templates/header.org"))
(defun cdr:templates-insert-bib-annotation ()
  "Inserts my biblatex annotation template at the current position."
  (interactive)
  (insert-file-contents "~/.emacs.d/templates/bib-annotation.txt"))
(defun cdr:templates-insert-blog-post ()
  "Inserts my blog post template at the current position."
  (interactive)
  (insert-file-contents "~/.emacs.d/templates/blog-post.sxml"))
(defun cdr:templates-insert-scm-project ()
  "Inserts my scheme project template at the current position."
  (interactive)
  (insert-file-contents "~/.emacs.d/templates/scheme-project.org"))
(defun cdr:templates-insert-setup ()
  "Inserts my org setup file at the current position."
  (interactive)
  (insert-file-contents "~/.emacs.d/templates/setup.org"))
(defun cdr:templates-insert-latex-figure-image ()
  "Inserts the boilerplate for an image figure in LaTeX."
  (interactive)
  (insert-file-contents "~/.emacs.d/templates/latex-figure-image.tex"))
(defun cdr:templates-insert-latex-figure-list ()
  "Inserts the boilerplate for a list figure in LaTeX."
  (interactive)
  (insert-file-contents "~/.emacs.d/templates/latex-figure-list.tex"))

(defun cdr:edit-region-as-org ()
  "Create an indirect buffer for a region's content, and switch to Org Mode."
  (interactive)
  (edit-indirect-region (region-beginning) (region-end) t)
  (beginning-of-line)
  (org-mode))

(defun cdr:edit-email-as-org ()
  "Create an indirect buffer for an Email Message's content, and switch to Org Mode."
  (interactive)
  (goto-char (point-min))
  (search-forward "--text follows this line--")
  (forward-line 1)
  (insert " ")
  (beginning-of-line)
  (let ((beginning-of-region (point)))
    (end-of-line)
    (edit-indirect-region beginning-of-region (point) t)
    (beginning-of-line)
    (delete-char 1)
    (org-mode)))

(defun cdr:message-send-and-exit ()
  "Wrapper for `message-send-and-exit` that also ensures the
  email is signed and that org has been HTMLized."
  (interactive)
  (goto-char (point-min))
  (org-mime-htmlize)
  (mml-secure-message-sign)
  (if (y-or-n-p "Send Email?")
      (message-send-and-exit)
    (message "Email not Sent.")))
;;; Convert Lwarp HTML to copyable discussion post HTML
(defun cdr:prep-latex-for-copy ()
  "Remove parts of the generated HTML from lwarp that I don't
need, and move the anchors to the correct places."
  (interactive)
  (cdr:prep-latex-for-copy-remove-mathjax)
  (cdr:prep-latex-for-copy-remove-ambles)
  (condition-case nil
      (while t
        (cdr:prep-latex-for-copy-move-id))
    (error nil))
  (goto-char (point-max))
  (insert "</section>")
  (condition-case nil
      (while t
        (cdr:prep-latex-for-copy-remove-empty-anchor))
    (error nil))
  (cdr:prep-latex-for-copy-remove-title-page))

(defun cdr:prep-latex-for-copy-remove-ambles ()
  "Remove the stuff before and after the content of our HTML."
  (goto-char (point-min))
  (search-forward "<section class=\"textbody\" >")
  (beginning-of-line)
  (delete-region (point-min) (point))
  (goto-char (point-max))
  (search-backward "</section>")
  (end-of-line 2)
  (delete-region (point) (point-max))
  (goto-char (point-min)))
(defun cdr:prep-latex-for-copy-remove-mathjax ()
  "Remove the MathJax customizations from lwarp's HTML output."
  (goto-char (point-min))
  (search-forward "<!--MathJax customizations:-->")
  (end-of-line 0)
  (let ((start (point)))
    (search-forward "<div class=\"titlepage\" >")
    (end-of-line -1)
    (delete-region start (point)))
  (goto-char (point-min)))
(defun cdr:prep-latex-for-copy-move-id ()
  "Move an HTML ID to the p tag below it."
  (goto-char (point-min))
  (search-forward ">References</h4>")
  (search-forward "<li>
<a id=")
  (let ((start (point)))
    (forward-char 1)
    (search-forward "\"")
    (kill-region start (point))
    (delete-region (line-beginning-position)
                   (line-end-position)))
  (search-forward "<p>")
  (forward-char -1)
  (insert " id=")
  (yank)
  (goto-char (point-min)))
(defun cdr:prep-latex-for-copy-remove-title-page ()
  "Remove the title page from lwarp's HTML output."
  (goto-char (point-min))
  (search-forward "<div class=\"titlepage\" >")
  (beginning-of-line)
  (let ((start (point)))
    (search-forward "</div>

</div>")
    (delete-region start (point)))
  (goto-char (point-min)))
(defun cdr:prep-latex-for-copy-remove-empty-anchor ()
  "Remove one of the anchor inserted by lwarp with no display content."
  (goto-char (point-min))
  (search-forward-regexp "<a id=\".+\"></a>")
  (delete-region (line-beginning-position)
                 (line-end-position))
  (goto-char (point-min)))
(defun cdr:cleanup-script-output ()
  "Remove Unneeded codes from the output of the Unix script
command. Relies on GNU sed."
  (interactive)
  (shell-command-on-region
   (point-min)
   (point-max)
   "sed 's/\\x1b\\[[0-9;]*[a-zA-Z]//g;s/\\x1b\\[[\\?1-9].....//g;s///g;s///g'"
   t t))
(defun cdr:set-variable-from-shell (variable)
  "Pull the value of an environment variable from a newly-spawned
login shell, and set Emacs' corresponding variable to that
value."
  (interactive)
  (let ((path-from-shell
         (replace-regexp-in-string
          "[ \t\n]*$"
          ""
          (shell-command-to-string
           (concat "$SHELL --login -c 'echo $'" variable)))))
    (setenv variable path-from-shell)))
(defun cdr:readme-guix-instructions (project)
  "Templating function for the 'Guix' section of my README.md files."
  (interactive)
   (concat
    "*** GNU Guix\n\n"
    "If You use [[https://guix.gnu.org/][GNU Guix]], this package \n"
    "is on [[https://sr.ht/~yewscion/yewscion-guix-channel/][my channel]]. \n\n"
    "Once You have it "
    "set up, You can just run:\n\n"
    "#+begin_src bash\n"
    "guix pull\n"
    "guix install "
    project
    "\n"
    "#+end_src\n\n"
    "If You just want to try it out, You can use Guix Shell instead:\n\n"
    "#+begin_src bash\n"
    "guix shell "
    project
    " bash --pure\n"
    "#+end_src\n\n"
    "And if You'd rather just try it out "
    "without my channel, You can clone this\nrepo and then do:\n"
    "#+begin_src bash\n"
    "cd "
    project
    "\nguix shell -f guix.scm bash --pure\n"
    "#+end_src\n\n"
    "This'll create a profile with *just* this project in it, "
    "to mess around with.\n\n"))
(defun cdr:readme-src-instructions (project)
  "Templating function for the 'Source' section of my README.md files."
  (interactive)
  (concat
   "*** Source\n\n"
   "If You don't want to use [[https://guix.gnu.org/][GNU Guix]],\n"
   "You can clone this repo and install it in the normal way:\n\n"
   "#+begin_src bash\n"
   "git clone https://git.sr.ht/~yewscion/"
   project
   "\ncd "
   project
   "\n./configure\n"
   "make\n"
   "make check\n"
   "make install\n"
   "#+end_src\n\n"
   "If You don't want to use git, or would rather stick with an\n"
   "actual release, then see the tagged releases for some tarballs\n"
   "of the source.\n\n"
   "The needed dependencies are tracked in the DEPENDENCIES.txt file\n"
   "to support this use case.\n\n"))
(defun cdr:readme-install-instructions (project)
  "Templating function for the 'Install' section of my README.md files."
  (interactive)
  (concat
   "** Installation\n"
  (cdr:readme-guix-instructions project)
  (cdr:readme-src-instructions project)))
(defun cdr:readme-contrib-instructions (project)
  "Templating function for the 'Contributing' section of my README.md files."
  (interactive)
  (concat
   "** Contributing\n"
   "Pull Requests are welcome, as are bugfixes and extensions. Please open\n"
   "issues as needed. If You contribute a feature, needs to be tests and\n"
   "documentation.\n\n"
   "Development is expected to be done using "
   "[[https://guix.gnu.org/][GNU Guix]].\n"
   "If You have =guix= set up, You should be able to enter a development\n"
   "environment with the following:\n\n"
   "#+begin_src bash\n"
   "cd "
   project
   "\n"
   "guix shell -D -f guix.scm bash --pure\n"
   "#+end_src\n\n"
   "If You've made changes without the above precautions, those changes will\n"
   "need to be confirmed to work in the above environment before merge.\n\n"))
(defun cdr:readme-license-instructions (project license)
  "Templating function for the 'License' section of my README.md files."
  (interactive)
  (concat
   "** License\n\n"
   "The ="
   project
   "= project and all associated files are ©2022 Christopher\nRodriguez, but"
   "licensed to the public at large under the terms of the:\n\n"
   (cond ((string= license "agpl")
          "[[https://www.gnu.org/licenses/agpl-3.0.html][GNU AGPL3.0+]]")
         (t
          "project's"))
   " license.\n\n"
   "Please see the =LICENSE= file and the above link for more information."))
(defun cdr:readme-std-usage-instructions (project)
  "Templating function for the 'Usage' section of my README.md files."
  (interactive)
   (concat
    "** Usage\n\n"
    "Full usage is documented in the =doc/"
    project
    ".info= file. Here are\nonly generic instructions.\n\n"
    "Once ="
    project
    "= in installed, You should be able to access all of\nits exported functions"
    "in guile by using its modules:\n\n"
    "#+begin_src scheme\n"
    "(use-modules ("
    (cadr (split-string project "-"))
    " main))\n(library-info) ;; I include this in all my libraries\n"
    "#+end_src\n\n"
    "Any binaries or scripts will be available in Your =$PATH=. A list of these\n"
    "is maintained in the info file. They all also have the =--help== flag, so\n"
    "if You prefer learning that way, that is also available.\n\n"))
(defun cdr:lisp-fill-paragraph (&optional justify)
  "Like \\[fill-paragraph], but handle Emacs Lisp comments and docstrings.
If any of the current line is a comment, fill the comment or the
paragraph of it that point is in, preserving the comment's
indentation and initial semicolons. This version will always wrap
strings according to the fill column of the source file, not the
fill column of the resulting string."
  (interactive "P")
  (or (fill-comment-paragraph justify)
      ;; Since fill-comment-paragraph returned nil, that means we're not in
      ;; a comment: Point is on a program line; we are interested
      ;; particularly in docstring lines.
      ;;
      ;; We bind `paragraph-start' and `paragraph-separate' temporarily.  They
      ;; are buffer-local, but we avoid changing them so that they can be set
      ;; to make `forward-paragraph' and friends do something the user wants.
      ;;
      ;; `paragraph-start': The `(' in the character alternative and the
      ;; left-singlequote plus `(' sequence after the \\| alternative prevent
      ;; sexps and backquoted sexps that follow a docstring from being filled
      ;; with the docstring.  This setting has the consequence of inhibiting
      ;; filling many program lines that are not docstrings, which is sensible,
      ;; because the user probably asked to fill program lines by accident, or
      ;; expecting indentation (perhaps we should try to do indenting in that
      ;; case).  The `;' and `:' stop the paragraph being filled at following
      ;; comment lines and at keywords (e.g., in `defcustom').  Left parens are
      ;; escaped to keep font-locking, filling, & paren matching in the source
      ;; file happy.  The `:' must be preceded by whitespace so that keywords
      ;; inside of the docstring don't start new paragraphs (Bug#7751).
      ;;
      ;; `paragraph-separate': A clever regexp distinguishes the first line of
      ;; a docstring and identifies it as a paragraph separator, so that it
      ;; won't be filled.  (Since the first line of documentation stands alone
      ;; in some contexts, filling should not alter the contents the author has
      ;; chosen.)  Only the first line of a docstring begins with whitespace
      ;; and a quotation mark and ends with a period or (rarely) a comma.
      ;;
      ;; The `fill-column' is temporarily bound to
      ;; `emacs-lisp-docstring-fill-column' if that value is an integer.
      (let ((paragraph-start
             (concat paragraph-start
                     "\\|\\s-*\\([(;\"]\\|\\s-:\\|`(\\|#'(\\)"))
	    (paragraph-separate
	     (concat paragraph-separate "\\|\\s-*\".*[,\\.]$"))
            (fill-column (if (and (integerp emacs-lisp-docstring-fill-column)
                                  (derived-mode-p 'emacs-lisp-mode))
                             emacs-lisp-docstring-fill-column
                           fill-column)))
        (save-restriction
          (save-excursion
          (let ((ppss (syntax-ppss))
                (start (point)))

            ;; If we're in a string, then narrow (roughly) to that
            ;; string before filling.  This avoids filling Lisp
            ;; statements that follow the string.
            (when (ppss-string-terminator ppss)
              ;; (goto-char (ppss-comment-or-string-start ppss))
              ;; (beginning-of-line)
              ;; (let (current-position (point))
              ;; ;; The string may be unterminated -- in that case, don't
              ;; ;; narrow.
              ;; (when (ignore-errors
              ;;         (progn
              ;;           (forward-sexp 1)
              ;;           t))
              ;;   (narrow-to-region (ppss-comment-or-string-start ppss)
              ;;                     (point))))
            ;; Move back to where we were.
            (goto-char start)
	    (fill-paragraph justify)))))
      ;; Never return nil.
      t)))

;;; Skeletons
(define-skeleton hog-skeleton
  "Sets up a new hog template in my org file"
  nil
  "** " '(let ((current-prefix-arg '(16)))(call-interactively
                                           'org-time-stamp-inactive)) ?\n "*** Hand-Off Details" ?\n "
  #+begin_src markdown" ?\n "    ### Summary" ?\n "    <pre>" ?\n ?\n
  "    </pre>" ?\n " #+end_src" ?\n
  ?\n "*** Start of Shift Summary" ?\n ?\n "  #+begin_src org :results html replace"
  ?\n ?\n "  #+end_src" ?\n)

(define-skeleton teammeeting-skeleton
  "Sets up a new Team Meeting template in my org file"
  nil
  "** Team Meeting "
  '(let ((current-prefix-arg '(16)))(call-interactively
                                     'org-time-stamp-inactive))
  ?\n "*** SSSPACER" ?\n "**** Safety" ?\n
  "**** Std Work" ?\n "**** Success" ?\n
  "*** Projects" ?\n "**** PIT9" ?\n
  "**** PIT2" ?\n "**** PIT5" ?\n "**** ECs"
  ?\n "*** Upcoming CMs" ?\n "**** PIT9" ?\n
  "**** PIT2" ?\n "**** PIT5" ?\n
  "*** Business News" ?\n "*** Round Robin"
  ?\n " ")

(define-skeleton 1:1-skeleton
  "Sets up a new 1:1 Prep template in my org file"
  nil
  "** Prep for 1:1 Scheduled "
  '(let ((current-prefix-arg '(4)))
     (call-interactively 'org-time-stamp-inactive))
  ?\n
  "*** Motivation" ?\n
  "*** Drains" ?\n
  "*** Growth" ?\n
  "*** Positives" ?\n
  "*** Negatives" ?\n
  "*** Focus" ?\n
  "*** Questions" ?\n
  "    - " ?\n
  "    - " ?\n
  "    - " ?\n
  "*** Projects" ?\n
  "    - " ?\n
  "    - " ?\n
  "    - " ?\n
  ?\n)

(fset 'cdr:run-genpro-and-update
      (kmacro-lambda-form [?\M-! ?g ?e ?n ?p ?r ?o ?  ?- ?p return
                                 ?\C-x ?o ?\C-x ?k return ?g ?y ?e ?s return ?\C-x ?o] 0 "%d"))

;; Org Mode Config

;;; Ensure Packages are Loaded
(require 'org-chef)
(require 'org-ebib)

;;; Local Lisp
(load "~/.emacs.d/lisp/ob-markdown.el")

(add-hook 'org-mode-hook 'org-display-inline-images)

;;; Org Agenda
(setq org-agenda-files
      (file-expand-wildcards "~/Documents/org/*.org"))

;;; Customization
(setq org-log-into-drawer t
      org-return-follows-link t
      org-startup-folded t
      org-image-actual-width 590
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
;;; TODO
      org-todo-keywords
      '((sequence "TODO(t!)" "|" "DONE(d@)")
        (sequence "TT(T!)" "ACTION ITEM(A!)" "|" "FIXED(F@)")
        (sequence "UNPLANNED(u!)" "PLANNED(p!)" "IN PROGRESS(i!)" "|"
                  "DELAYED(D@)" "COMPLETE(c@)")
        (sequence "UNSUBMITTED(U!)" "DRAFT(f!)" "PENDING APPROVAL(P!)"
                  "REWORK REQUIRED(r@)" "SCHEDULED(s!)" "|"
                  "DISCARDED(I@)" "SUCCESSFUL(S!)" "OFF-SCRIPT(o@)"
                  "ABORTED(a@)")
        (sequence "RESEARCHING(r@)" "ONGOING(O!)"
                  "AWAITING RESPONSE(w@)" "|"
                  "HANDED OFF(h@)" "CANCELED(C@)")))

;;; Capture
(defun my-org-capture:contacts-template ()
  "Org Capture Template for Contact Creation." ; Needs Rewrite
  "* %^{Given Name}
%^{Middle-Name}p%^{Work-Email}p%^{Personal-Email}p"
  "%^{Main-Phone}p%^{Alt-Phone}p%^{Company}p"
  "%^{Department}p%^{Office}p%^{Title}p"
  "%^{Handle}p%^{Manager}p%^{Assistant}p"
  "%^{Birthday}p%^{Street-Address}p%^{Street-Address-Line-2}p"
  "%^{City-Address}p%^{State-Address}p%^{Zip-Address}p"
  "%^{Zip-Plus-4-Address}p%^{Country}p
%^{Notes}")

(defun my-org-capture:grocery-template ()
  "Org Capture Template for Grocery List Creation."
  "**** %<%Y-W%W>
     :LOGBOOK:
     # NOTE: Remember to add clock out time after --!
     #       (C-u M-x org-ina RET RET M-x org-cl-may)
     CLOCK: %U--
     :END:
***** Baking%?
***** Dairy
***** Frozen
***** Grains
***** Junk
***** Produce
***** Protein
***** Sundries")

(defun my-org-capture:health-template ()
  "Org Capture Template for Grocery List Creation."
  "|%u|%^{Anxiety (1-10)}|%^{Depression (1-10)}|"
  "%^{Headache: (0-5)}|%^{Sick: 0-1}")

(defun my-org-capture:recipe-template ()
  "Org Capture Template for Recipe Creation."
  "* %^{Recipe title: }
  :PROPERTIES:
  :source-url:
  :servings:
  :prep-time:
  :cook-time:
  :ready-in:
  :END:
** Ingredients
   %?
** Directions
")

(defun my-org-capture:note-template ()
  "Org Capture Template for Note Creation."
  "* %U %^{Short Description of Note|Quick Note} %^G
%^{Enter Note}
%?")

(defun my-org-capture:link-template ()
  "Org Capture Template for Link Capture from Clipboard."
  "** %^{Identifier|Bookmark} %^G
   %(org-cliplink-capture)
   %?")

(defun my-org-capture:wishlist-template ()
  "Org Capture Template for Budget-Control Wishlist."
  "* %U %^{Short Description of Note|Desired Item} %^G
%^{Location}p%^{Price}p%^{Category}p%^{Optional Description}
%?")

(setq org-capture-templates
      '(("r" "Recipes (using org-chef)")
        ("ru" "Import Recipe from URL" entry
         (file "~/Documents/org/recipes.org")
         "%(org-chef-get-recipe-from-url)"
         :empty-lines 1)
        ("rm" "Import Recipe Manually" entry
         (file "~/Documents/org/recipes.org")
         (function my-org-capture:recipe-template))
        ("n" "Notes, Links, and Contacts")
        ("nn" "Note" entry
         (file "~/Documents/org/inbox.org")
         (function my-org-capture:note-template))
        ("nc" "Contact" entry
         (file "~/Documents/org/contacts.org")
         (function my-org-capture:contacts-template))
        ("nl" "Link from Clipboard" entry
         (file+headline "~/Documents/org/bookmarks.org"
                        "Inbox")
         (function my-org-capture:link-template))
        ("d" "Data Aggregation")
        ("dh" "Daily Health Check In" table-line
         (file+headline "~/Documents/org/metrics.org"
                        "Health")
         (function my-org-capture:health-template) :unnarrowed t)
        ("dw" "Wishlist Item" entry
         (file "~/Documents/org/wishlist.org")
         (function my-org-capture:wishlist-template))
        ("c" "Chores")
        ("cg" "Grocery Shopping List" entry
         (file+headline "~/Documents/org/chores.org"
                        "Make Shopping List")
         (function my-org-capture:grocery-template))))

;;; Babel
(org-babel-do-load-languages
 'org-babel-load-languages
 '((abc . t)
   (C . t)
   (clojure . t)
   (browser . t)
   (dot . t)
   (elixir . t)
   (elm . t)
   (elvish . t)
   (emacs-lisp . t)
   (haskell . t)
   (hledger . t)
   (http . t)
   (js . t)
   (julia . t)
   (kotlin . t)
   (lilypond . t)
   (lisp . t)
   (lua . t)
   (makefile . t)
   (markdown . t)
   (mermaid . t)
   (nim . t)
   (org . t)
   (perl . t)
   (prolog . t)
   (python . t)
   (raku . t)
   (ruby . t)
   (rust . t)
   (scheme . t)
   (shell . t)
   (shen . t)
   (sql . t)
   (sqlite . t)
   ))
(setq org-confirm-babel-evaluate nil)
(add-hook 'org-babel-after-execute-hook 'org-display-inline-images)

;;;; Babel for Raku
(setq org-babel-raku-command "rakudo")

;;; Load the Library
(org-babel-lob-ingest "~/.emacs.d/library-of-babel.org")

;;; Make it so code blocks in Org Babel Behave Consistently.
(setq org-src-preserve-indentation t)

;;; LSP stuff

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
      lsp-ui-doc-use-webkit t)

;;; Ebib
(setq ebib-bibtex-dialect 'biblatex
      ebib-preload-bib-files '("~/Documents/biblio/main.bib")
      ebib-reading-list-file "~/Documents/org/data/reading-list.org"
      ebib-file-associations '()
      ebib-hidden-fields
      '("addendum" "afterword" "annotator" "archiveprefix" "bookauthor" "booksubtitle" "booktitleaddon" "commentator" "edition" "editora" "editorb" "editorc" "eid" "eventdate" "eventtitle" "foreword" "holder" "howpublished" "introduction" "isrn" "issuesubtitle" "issuetitle" "issuetitleaddon" "journaltitleadddon" "journalsubtitle" "mainsubtitle" "maintitle" "maintitleaddon" "month" "pagetotal" "part" "primaryclass" "remark" "subtitle" "titleaddon" "translator" "venue" "version" "volumes")
      ebib-use-timestamp t)

(setq org-cite-global-bibliography
      '("~/Documents/biblio/main.bib"))

(setq org-mime-export-options '(:with-latex dvipng
                                            :section-numbers nil
                                            :with-author nil
                                            :with-toc nil)
      org-mime-export-ascii 'utf-8)

(defun offlineimap-get-password (host port)
  (let* ((authinfo (netrc-parse (expand-file-name "~/.authinfo.gpg")))
         (hostentry (netrc-machine authinfo host port port)))
    (when hostentry (netrc-get hostentry "password"))))

(setq send-mail-function 'sendmail-send-it
      message-send-mail-function 'sendmail-send-it
      sendmail-program "msmtp"
      mail-specify-envelope-from t
      message-sendmail-envelope-from 'header
      mail-envelope-from 'header
      mml-secure-openpgp-signers '("F39CD46349A576F88EF924791102102EBE7C3AE4")
      user-mail-address ""
      mh-mml-method-default "pgp"
      mml-default-encrypt-method "pgp"
      mml-default-sign-method "pgp"
      message-sendmail-extra-arguments '("--read-envelope-from"))
(add-hook 'message-setup-hook 'mml-secure-message-sign)

(require 'mu4e)
(add-to-list 'mu4e-bookmarks
             '( :name  "Non-Trashed"
                :query "not maildir:/trash and not maildir:/sent"
                :key   ?n))

(setq mu4e-contexts
      `( ,(make-mu4e-context
           :name "cdr255"
           :enter-func (lambda () (mu4e-message "Entering 'cdr255' context"))
           :leave-func (lambda () (mu4e-message "Leaving 'cdr255' context"))
           :match-func (lambda (msg)
                         (when msg
                           (string-match-p "^/cdr255" (mu4e-message-field msg :maildir))))
           :vars '( ( user-mail-address	    . "cdr255@gmail.com"  )
                    ( user-full-name	    . "Christopher Rodriguez" )
                    ( mu4e-compose-signature .
                      (concat
                       "--\n\n"
                       "Christopher Rodriguez\n"))))
         ,(make-mu4e-context
           :name "work"
           :enter-func (lambda () (mu4e-message "Entering 'work' context"))
           :leave-func (lambda () (mu4e-message "Leaving 'work' context"))
           :match-func (lambda (msg)
                         (when msg
                           (string-match-p "^/rodnchr" (mu4e-message-field msg :maildir))))
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
           :match-func (lambda (msg)
                         (when msg
                           (string-match-p "^/csuglobal" (mu4e-message-field msg :maildir))))
           :vars '( ( user-mail-address	     . "christopher.rodriguez@csuglobal.edu" )
                    ( user-full-name	     . "Christopher Rodriguez" )
                    ( mu4e-compose-signature  .
                      (concat
                       "--\n\n"
                       "Christopher Rodriguez\n"))))
         ,(make-mu4e-context
           :name "yewscion"
           :enter-func (lambda () (mu4e-message "Entering 'yewscion' context"))
           :leave-func (lambda () (mu4e-message "Leaving 'yewscion' context"))
           :match-func (lambda (msg)
                         (when msg
                           (string-match-p "^/yewscion" (mu4e-message-field msg :maildir))))
           :vars '( ( user-mail-address	     . "yewscion@gmail.com" )
                    ( user-full-name	     . "Christopher Rodriguez" )
                    ( mu4e-compose-signature  .
                      (concat
                       "--\n\n"
                       "Christopher Rodriguez\n"))))))

(setq mu4e-compose-context-policy nil
      mu4e-context-policy 'pick-first
      mu4e-compose-keep-self-cc t)
(add-hook 'mu4e-compose-mode-hook 'cdr:edit-email-as-org)
(substitute-key-definition 'message-send-and-exit 'cdr:message-send-and-exit mu4e-compose-mode-map)
(define-mail-user-agent 'mu4e-user-agent
  'mu4e-compose-mail
  'message-send-and-exit
  'message-kill-buffer
  'message-send-hook)
;; Without this `mail-user-agent' cannot be set to `mu4e-user-agent'
;; through customize, as the custom type expects a function.  Not
;; sure whether this function is actually ever used; if it is then
;; returning the symbol is probably the correct thing to do, as other
;; such functions suggest.
(defun mu4e-user-agent ()
  "Return the `mu4e-user-agent' symbol."
  'mu4e-user-agent)

(setq mail-user-agent (mu4e-user-agent))

;;; Theming and UI
(require 'eterm-256color)
(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)
(column-number-mode 1)
(display-time-mode 1)
(guru-global-mode 1)
(global-disable-mouse-mode)
(display-battery-mode)
(set-face-attribute 'default nil
                    :family "FreeMono"
                    :height 110
                    :weight 'normal
                    :width 'normal)
(set-face-attribute 'fixed-pitch nil
                    :family "FreeMono"
                    :height 110
                    :weight 'normal
                    :width 'normal)
(set-face-attribute 'header-line nil
                    :background "#808080"
                    :foreground "#333333"
                    :family "unifont")
(set-face-attribute 'mode-line nil
                    :background "#212931"
                    :foreground "#eeeeec"
                    :family "unifont")
(set-face-attribute 'org-mode-line-clock nil
                    :inherit 'header-line)
(set-face-attribute 'term-color-black nil
                    :background "#2d3743"
                    :foreground "#2d3743")
(set-face-attribute 'term-color-blue nil
                    :background "#34cae2"
                    :foreground "#34cae2")
(set-face-attribute 'term-color-cyan nil
                    :background "#e67128"
                    :foreground "#e67128")
(set-face-attribute 'term-color-green nil
                    :background "#338f86"
                    :foreground "#338f86")
(set-face-attribute 'term-color-magenta nil
                    :background "#ee7ae7"
                    :foreground "#ee7ae7")
(set-face-attribute 'term-color-red nil
                    :background "#ff4242"
                    :foreground "#ff4242")
(set-face-attribute 'term-color-white nil
                    :background "#e1e1e0"
                    :foreground "#e1e1e0")
(set-face-attribute 'term-color-yellow nil
                    :background "#ffad29"
                    :foreground "#ffad29")
(require 'projectile)
;;; Projectile
(projectile-register-project-type 'genpro '(".metadata")
                                  :project-file ".metadata"
				  :compile "genpro -p")
(projectile-register-project-type 'java-ant '("build.xml")
                                  :project-file "build.xml"
				  :compile "ant compile"
                                  :package "ant dist"
                                  :run "ant run")

(setq projectile-track-known-projects-automatically nil)
(define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)

;;; Set Up UI
(when (display-graphic-p)
  (progn ;; Emoji Support
    (setq use-default-font-for-symbols nil
          emojify-display-style 'unicode
          emojify-emoji-styles '(github unicode))
    (defun my-emoji-fonts ()
      (set-fontset-font t 'unicode
                        (face-attribute 'default :family))
      (set-fontset-font t '(#x2300 . #x27e7)
                        (font-spec :family "Emoji One"))
      (set-fontset-font t '(#x27F0 . #x1FAFF)
                        (font-spec :family "Emoji One"))
      (set-fontset-font t 'unicode
                        "Unifont, Upper" nil 'append))
    (my-emoji-fonts)))

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
      whitespace-line-column nil)
(setq-default fill-column 80
              indent-tabs-mode nil
              show-trailing-whitespace nil)

(set-face-attribute 'fixed-pitch nil :font "FreeMono")
(prefer-coding-system 'utf-8)

;;; Enabled Commands
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'capitalize-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)

;;; Header Line and Mode Line
(add-hook 'buffer-list-update-hook
          'cdr:display-header-line)
(add-hook 'buffer-list-update-hook
          'cdr:display-mode-line)

(if (display-graphic-p)
    (setq global-mode-string
          '("🎼"
            emms-mode-line-string
            emms-playing-time-string
            " ⌚"
            display-time-string
            " 🔋"
            battery-mode-line-string
            " 🦆"
            org-mode-line-string))
  (setq global-mode-string
        '("♪"
          emms-mode-line-string
          emms-playing-time-string
          " ✪ "
          display-time-string
          " ䷡"
          battery-mode-line-string
          " ✿"
          org-mode-line-string)))
(setq
 display-time-default-load-average
 nil
 
 display-time-day-and-date
 't

 display-time-load-average-threshold
 10000)

;;; Header Line Format

(setq emms-mode-line-cycle-current-title-function
      'cdr:emms-describe-track)

(pinentry-start)

(setq show-paren-mode t
      term-buffer-maximum-size 16384
      term-set-terminal-size t
      titlecase-style 'apa
      user-full-name "Christopher Rodriguez"
      vterm-kill-buffer-on-exit nil
      vterm-shell "bash -l"
      comint-use-prompt-regexp t
      scroll-preserve-screen-position t)

;;; Zone Mode - Screensaverlike
(require 'zone)
(zone-when-idle 120)

(pdf-tools-install)

;;; Printing PDFs      

(setq pdf-misc-print-program-args
      '("-o media=letter" "-o fit-to-page" "-o sides=two-sided-long-edge")
      pdf-misc-print-program-executable "/usr/bin/lpr")

;;; Elfeed

(setq elfeed-feeds
      '(("https://jany.st/rss.xml" tech hardware)
       ("https://alhassy.github.io/rss.xml" tech code lisp cl)
       ("http://retro-style.software-by-mabe.com/blog-atom-feed" tech code lisp cl)
       ("https://freedom-to-tinker.com/feed/rss/" tech policy)
       ("https://planet.lisp.org/rss20.xml" tech code lisp cl)
       ("https://andysalerno.com/index.xml" tech)
       ("https://yewscion.com/feed.xml" personal tech code)
       ("https://blog.tecosaur.com/tmio/rss.xml" tech emacs org-mode)
       ("https://guix.gnu.org/feeds/blog.atom" tech gnu guix lisp scheme guile)
       ("https://www.webtoons.com/en/challenge/the-prettiest-platypus/rss?title_no=463063" comic trans)
       ("https://xkcd.com/atom.xml" comic)
       ("https://www.questionablecontent.net/QCRSS.xml" comic nsfw)
       ("https://somethingpositive.net/feed/" comic nsfw)
       ("https://www.gnu.org/software/guile/news/feed.xml" tech code lisp scheme guile)
       ("https://planet.scheme.org/atom.xml" tech code lisp scheme)
       ("https://www.wingolog.org/feed/atom" tech code lisp scheme guile)))

;; Maps

;;; Prefixes

(define-prefix-command 'template-map)
(define-prefix-command 'subprocess-map)
(define-prefix-command 'process-buffer-map)
(define-prefix-command 'transform-map)

;;; Template Map

(define-key template-map (kbd "d") #'cdr:templates-insert-scm-docstring)
(define-key template-map (kbd "b") #'cdr:templates-insert-bib-annotation)
(define-key template-map (kbd "C-b") #'cdr:templates-insert-blog-post)
(define-key template-map (kbd "h") #'cdr:templates-insert-org-header)
(define-key template-map (kbd "C-s") #'cdr:templates-insert-scm-project)
(define-key template-map (kbd "s") #'cdr:templates-insert-setup)
(define-key template-map (kbd "l") #'cdr:templates-insert-latex-figure-image)
(define-key template-map (kbd "C-l") #'cdr:templates-insert-latex-figure-list)

;;; Subprocess Map

(define-key subprocess-map (kbd "s") #'slime)
(define-key subprocess-map (kbd "c") #'cider)
(define-key subprocess-map (kbd "g") #'run-guile)
(define-key subprocess-map (kbd "p") #'run-python)
(define-key subprocess-map (kbd "C-p") #'run-prolog)
(define-key subprocess-map (kbd "j") #'run-janet)
(define-key subprocess-map (kbd "C-g") #'run-geiser)
(define-key subprocess-map (kbd "v") #'vterm)
(define-key subprocess-map (kbd "r") #'run-ruby)
(define-key subprocess-map (kbd "e") #'eshell)
(define-key subprocess-map (kbd "l") #'lsp)

;;; Process Buffer Map

(define-key process-buffer-map (kbd "C-w") #'org-copy-src-block)
(define-key process-buffer-map (kbd "C-n") #'orgy-cm-step-next)
(define-key process-buffer-map (kbd "C-h") #'cdr:orgy-pull-task-clock-to-hog)
(define-key process-buffer-map (kbd "w") #'whitespace-report)
(define-key process-buffer-map (kbd "c") #'whitespace-cleanup)

;;; Transform Map
(define-key transform-map (kbd "r") #'replace-string)
(define-key transform-map (kbd "C-r") #'replace-regexp)
(define-key transform-map (kbd "o") #'cdr:edit-region-as-org)
(define-key transform-map (kbd "u") #'upcase-dwim)
(define-key transform-map (kbd "d") #'downcase-dwim)
(define-key transform-map (kbd "t") #'titlecase-dwim)
(define-key transform-map (kbd "C-w") #'cdr:copy-unfilled-region)


;; Keys

;;; Function (Major Modes)

;(global-set-key (kbd "<f1>") nil) ; Help prefix
;(global-set-key (kbd "<f2>") nil) ; 2 Column prefix
;(global-set-key (kbd "<f3>") nil) ; Define Macros
;(global-set-key (kbd "<f4>") nil) ; Run Macro
(global-set-key (kbd "<f5>") 'emms)
(global-set-key (kbd "<f6>") 'ebib)
(global-set-key (kbd "<f7>") 'mastodon)
(global-set-key (kbd "<f8>") 'elfeed)
(global-set-key (kbd "<f9>") 'org-agenda)
; (global-set-key (kbd "<f10>") nil) ; GUI Menu Key
; (global-set-key (kbd "<f11>") nil) ; GUI Fullscreen
(global-set-key (kbd "<f12>") 'forms-mode)

;;; Ctrl Function (Maps)

;; (global-set-key (kbd "C-<f1>") nil)
(global-set-key (kbd "C-<f2>") 'transform-map)
(global-set-key (kbd "C-<f3>") 'process-buffer-map)
(global-set-key (kbd "C-<f4>") 'subprocess-map)
(global-set-key (kbd "C-<f5>") 'template-map)
;; (global-set-key (kbd "C-<f6>") nil)
;; (global-set-key (kbd "C-<f7>") nil)
;; (global-set-key (kbd "C-<f8>") nil)
;; (global-set-key (kbd "C-<f9>") nil)
;; (global-set-key (kbd "C-<f10>") nil)
;; (global-set-key (kbd "C-<f11>") nil)
;; (global-set-key (kbd "C-<f12>") nil)

;;; Meta Function (Misc)

(global-set-key (kbd "M-<f1>") 'org-pomodoro)
(global-set-key (kbd "M-<f2>") 'ebib-insert-citation)
(global-set-key (kbd "M-<f3>") 'emms-previous)
(global-set-key (kbd "M-<f4>") 'emms-next) ; Close Program
(global-set-key (kbd "M-<f5>") 'emms-pause)
(global-set-key (kbd "M-<f6>") 'emms-shuffle)
;; (global-set-key (kbd "M-<f7>") nil)
;; (global-set-key (kbd "M-<f8>") nil)
;; (global-set-key (kbd "M-<f9>") nil)
;; (global-set-key (kbd "M-<f10>") nil)
;; (global-set-key (kbd "M-<f11>") nil)
;; (global-set-key (kbd "M-<f12>") nil)

;;; Super (Minor Modes/Special Functions)

;; (global-set-key (kbd "s-q") nil) ; GNOME ?
(global-set-key (kbd "s-w") 'whitespace-mode)
(global-set-key (kbd "s-e") 'show-paren-mode)
(global-set-key (kbd "s-r") 'display-line-numbers-mode)
(global-set-key (kbd "s-t") 'titlecase-dwim)
(global-set-key (kbd "s-y") 'yank-from-primary)
(global-set-key (kbd "s-u") 'unfill-paragraph)
;; (global-set-key (kbd "s-i") nil)
;; (global-set-key (kbd "s-o") nil) ; GNOME ?
;; (global-set-key (kbd "s-p") nil) ; GNOME ?
;; (global-set-key (kbd "s-a") nil) ; GNOME Application Menu
;; (global-set-key (kbd "s-s") nil) ; GNOME Switch Window Menu
;; (global-set-key (kbd "s-d") nil) ; GNOME Show Desktop
(global-set-key (kbd "s-f") 'display-fill-column-indicator-mode)
(global-set-key (kbd "s-g") 'cdr:run-genpro-and-update)
;; (global-set-key (kbd "s-h") nil) ; GNOME ?
;; (global-set-key (kbd "s-j") nil)
;; (global-set-key (kbd "s-k") nil)
;; (global-set-key (kbd "s-l") nil) ; GNOME Lock Screen
;; (global-set-key (kbd "s-z") nil)
;; (global-set-key (kbd "s-x") nil)
(global-set-key (kbd "s-c") 'copy-unfilled-subtree)
;; (global-set-key (kbd "s-v") nil) ; GNOME Show Notifications
;; (global-set-key (kbd "s-b") nil)
;; (global-set-key (kbd "s-n") nil) ; GNOME ?
;; (global-set-key (kbd "s-m") nil) ; GNOME ?
(global-set-key (kbd "s-;") 'projectile-mode)
;; (global-set-key (kbd "s-q") nil)
;; (global-set-key (kbd "s-q") nil)
;; (global-set-key (kbd "s-q") nil)
;; (global-set-key (kbd "s-q") nil)
;; (global-set-key (kbd "s-q") nil)
(global-set-key (kbd "s-<tab>") 'indent-relative)

;;; Mode-specific Keybindings Made Global
(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "C-;") 'iedit-mode)

;;; Ensure paths are set properly
(cdr:set-variable-from-shell "HOME")
(cdr:set-variable-from-shell "PATH")
(cdr:set-variable-from-shell "CLASSPATH")
(setq exec-path (split-string (getenv "PATH") path-separator))

;;; Load Initial File.
(find-file "~/Documents/org/main.org")

