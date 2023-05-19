(require 'cdr255)
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
(fset 'cdr:copy-deft-note-as-comment
      (kmacro-lambda-form [?\C-x ?h ?\M-w ?\C-x ?o ?\C-m ?- ?- ?- ?-
                                 ?- ?- ?- ?- ?- ?- ?- ?- ?- ?\C-m ?\C-p ?\C-m ?\C-u ?\C-y ?- ?-
                                 ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?\C-m ?\C-p ?\C-a ?\C- ?\C-s
                                 ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?\C-s ?\C-x ?\C-\;
                                 ?\C-x ?o] 0 "%d"))

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
                     emms-player-mikmod
                     emms-player-xmp
                     emms-player-timidity
                     emms-player-adlmidi)))
    (progn (message "Changing MIDI player to Timidity!")
           (setq emms-player-list
                 '(emms-player-mpv
                   emms-player-mikmod
                   emms-player-xmp
                   emms-player-adlmidi
                   emms-player-timidity)))))

;;; EMMS Description Shims.
(defun cdr:emms-track-description (track)
  "Isolates the filename of TRACK if timidity or mikmod could play it."
  (if (or (emms-player-timidity-playable-p track)
          (emms-player-mikmod-playable-p track)
          (emms-player-xmp-playable-p track)
          )
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
              (not (equal nil (member 'lsp-headerline-breadcrumb-mode
                                      minor-mode-list))))
    (setq header-line-format
          '("%e" mode-line-misc-info))))

(defvar cdr:mode-line-paragraph-number
  "¶0"
  "The current paragraph number, for display in the modeline")
(make-variable-buffer-local 'cdr:mode-line-paragraph-number)

(defun cdr:get-paragraph-number ()
  "Get the paragraph number at point.

This is an action.

Arguments
=========
None.

Returns
=======
A <number> representing the number of times '\n\n' appears above the
point, plus 1. This /should/ equal the paragraph number.

Impurities
==========
Relies on state of buffer (specifically, the point position."
  (interactive)
  (1+ (count-matches "

" (point-min) (point))))
(defun cdr:update-mode-line-paragraph-number ()
  "Update the buffer-local variable for paragraph number in the mode-line.

This is an ACTION.

Arguments
=========
None.

Returns
=======
Unspecified.

Impurities
==========
Sets a buffer-local variable using current buffer state."
  (while-no-input (redisplay)
                  (unless (window-minibuffer-p)
                    (setq cdr:mode-line-paragraph-number
                          (concat
                           "¶"
                           (number-to-string
                            (cdr:get-paragraph-number)))))))


;;; Mode Line Format Function
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
                             cdr:mode-line-paragraph-number
                             " "
                             (vc-mode
                              vc-mode)
                             " "
                             mode-line-modes
                             mode-line-end-spaces
                             ))))
(add-hook 'post-command-hook #'cdr:update-mode-line-paragraph-number)
(defun random-thing-from-a-file (f)
  (interactive "Load Thing from: ")
  (random t)
  (save-excursion
    (find-file f)
    (let ((line-num (random (count-lines (point-min) (point-max)))))
      (goto-line line-num)
      (let ((result (buffer-substring (line-beginning-position)
                                      (line-end-position))))
        (kill-buffer (current-buffer))
        result))))

(defun my:journal-prompt ()
  (interactive)
  (let* ((thing (random-thing-from-a-file
                 "~/.local/share/journal-prompts.txt")))
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
  (setq dired-actual-switches "-DFhikmopqs")
  (revert-buffer))
(defun cdr:diredy-show-dotfiles ()
  "Adds the 'a' flag from dired-listing-switches."
  (interactive)
  (setq dired-actual-switches "-aDFhikmopqs")
  (revert-buffer))
(defun cdr:diredy-xdg-open (&optional command-name prefix file-list)
  "Opens the selected files using xdg-open (or similar command, if specified).

This is an ACTION.

Arguments
=========

COMMAND-NAME <string>: The command to use to open the files.

PREFIX <number>: The prefix argument. Ignored for now.

FILE-LIST <<list> of <paths>>: The files to open.

Returns
=======
Undefined.

Impurities
==========
Deals with external programs and files."
  (interactive
   (let ((files (dired-get-marked-files t current-prefix-arg nil nil t)))
     (list
      "xdg-open"
      current-prefix-arg
      files)))
  (mapcar (lambda (x) (start-process "XDG-OPEN"
                                     nil
                                     command-name
                                     x))
          file-list))

;;; Inserting Templates
(defun cdr:templates-insert-scm-docstring ()
  "Inserts a scheme docstring at the current position."
  (interactive)
  (save-mark-and-excursion
    (insert-file-contents "~/.emacs.d/templates/scheme-docstring")))
(defun cdr:templates-insert-apl-docstring ()
  "Inserts an APL docstring comment at the current position."
  (interactive)
  (save-mark-and-excursion
    (beginning-of-line)
    (insert-file-contents "~/.emacs.d/templates/apl-docstring")))
(defun cdr:templates-insert-java-field-docstring ()
  "Inserts a Javadoc field docstring comment at the beginning of
the current line."
  (interactive)
  (save-mark-and-excursion
    (beginning-of-line)
    (insert-file-contents "~/.emacs.d/templates/java-field-docstring")))
(defun cdr:templates-insert-java-method-docstring ()
  "Inserts a Javadoc method docstring comment at the beginning of
the current line."
  (interactive)
  (save-mark-and-excursion
    (beginning-of-line)
    (insert-file-contents "~/.emacs.d/templates/java-method-docstring")))
(defun cdr:templates-insert-texinfo-chapter ()
  "Inserts the template for the start of a chapter at the beginning
of the current line."
  (interactive)
  (save-mark-and-excursion
    (beginning-of-line)
    (insert-file-contents
     "~/.emacs.d/templates/texinfo-chapter.texi")))
(defun cdr:templates-insert-texinfo-section ()
  "Inserts the template for the start of a section at the beginning
of the current line."
  (interactive)
  (save-mark-and-excursion
    (beginning-of-line)
    (insert-file-contents
     "~/.emacs.d/templates/texinfo-section.texi")))
(defun cdr:templates-insert-texinfo-subsection ()
  "Inserts the template for the start of a subsection at the beginning
of the current line."
  (interactive)
  (save-mark-and-excursion
    (beginning-of-line)
    (insert-file-contents
     "~/.emacs.d/templates/texinfo-subsection.texi")))
(defun cdr:templates-insert-texinfo-procedure-definition ()
  "Inserts the template for a procedure definition at the beginning
of the current line."
  (interactive)
  (save-mark-and-excursion
    (beginning-of-line)
    (insert-file-contents
     "~/.emacs.d/templates/texinfo-procedure-definition.texi")))
(defun cdr:templates-insert-org-header ()
  "Inserts my org header at the current position."
  (interactive)
  (insert-file-contents "~/.emacs.d/templates/header.org"))
(defun cdr:templates-insert-bib-annotation ()
  "Inserts my biblatex annotation template at the current position."
  (interactive)
  (insert-file-contents "~/.emacs.d/templates/bib-annotation"))
(defun cdr:templates-insert-blog-post ()
  "Inserts my blog post template at the current position."
  (interactive)
  (insert-file-contents "~/.emacs.d/templates/blog-post.sxml"))
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
(defun cdr:templates-insert-guix-package ()
  "Inserts my guix package template at the current position."
  (interactive)
  (insert-file-contents "~/.emacs.d/templates/guix-package.scm"))
(defun cdr:templates-insert-dir-locals ()
  "Inserts my .dir-locals.el template at the current position."
  (interactive)
  (insert-file-contents "~/.emacs.d/templates/dir-locals"))
(defun cdr:templates-insert-autoconf-commentable-header ()
  "Inserts the standard commentable autoconf header for source code
files at the beginning of the current line."
  (interactive)
  (save-mark-and-excursion
    (beginning-of-line)
    (insert-file-contents
     "~/.emacs.d/templates/autoconf-commentable-header.in")))
(defun cdr:templates-insert-spaced-repetition-card ()
  "Inserts an empty spaced repetition card template at the
beginning of the current line."
  (interactive)
  (save-mark-and-excursion
    (beginning-of-line)
    (insert-file-contents
     "~/.emacs.d/templates/spaced-repetition-card.org")))
(defun cdr:templates-insert-guile-script ()
  "Inserts an empty guile script template at the
beginning of the current line."
  (interactive)
  (save-mark-and-excursion
    (beginning-of-line)
    (insert-file-contents
     "~/.emacs.d/templates/guile-script.scm")))
(defun cdr:templates-insert-latex-appendix-listings ()
  "Inserts a latex-appendix-listings template at the
beginning of the current line."
  (interactive)
  (save-mark-and-excursion
    (beginning-of-line)
    (insert-file-contents
     "~/.emacs.d/templates/latex-appendix-listings.tex")))
(defun cdr:templates-insert-agda-docstring ()
  "Inserts an empty agda docstring template at the
beginning of the current line."
  (interactive)
  (save-mark-and-excursion
    (beginning-of-line)
    (insert-file-contents
     "~/.emacs.d/templates/agda-docstring.agda")))
;;; End Templates

(defun cdr:edit-region-as-org ()
  "Create an indirect buffer for a region's content, and switch to Org Mode."
  (interactive)
  (edit-indirect-region (region-beginning) (region-end) t)
  (beginning-of-line)
  (org-mode))

(defun cdr:edit-email-as-org ()
  "Create an indirect buffer for an Email Message's content, and
switch to Org Mode."
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
  (cdr:prep-latex-for-copy-remove-title-page)
  (cdr:prep-latex-for-copy-add-rules-and-footnote-section)
  (condition-case nil
      (while t
        (cdr:prep-latex-for-copy-move-footnote))
    (error nil))
  (cdr:clean-up-newlines))

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
    (search-forward "<div class=\"center\" >")
    (end-of-line -2)
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
  (search-forward "<div class=\"center\" >")
  (beginning-of-line)
  (let ((start (point)))
    (search-forward "</div>
<h4")
    (end-of-line)
    (delete-region start (point)))
  (goto-char (point-min)))
(defun cdr:prep-latex-for-copy-remove-empty-anchor ()
  "Remove one of the anchor inserted by lwarp with no display content."
  (goto-char (point-min))
  (search-forward-regexp "<a id=\".+\"></a>")
  (delete-region (line-beginning-position)
                 (line-end-position))
  (goto-char (point-min)))
(defun cdr:prep-latex-for-copy-add-rules-and-footnote-section ()
  "Add horizontal Rules for Footnotes and References."
  (goto-char (point-min))
  (search-forward ">References</h4>")
  (beginning-of-line)
  (insert (concat "<hr />\n<h4 id=\"footnotes\">Footnotes</h4>\n\n"
                  "<!-- FOOTNOTESWILLGOHERE -->\n\n<hr />\n")))

(defun cdr:prep-latex-for-copy-move-footnote ()
  "Move a Footnote to the Footnote Section."
  (goto-char (point-min))
  (search-forward "<div class=\"footnotes\" >")
  (let ((start (point)))
    (search-forward "</p>\n\n</div>")
    (beginning-of-line)
    (kill-region start (point))
    (goto-char start))
  (beginning-of-line)
  (let ((start (point)))
    (search-forward "</div>")
    (delete-region start (point)))
  (search-forward "<!-- FOOTNOTESWILLGOHERE -->")
  (forward-line -1)
  (yank)
  (goto-char (point-min)))
(defun cdr:cleanup-script-output ()
  "Remove Unneeded codes from the output of the Unix script
command. Relies on GNU sed."
  (interactive)
  (shell-command-on-region
   (point-min)
   (point-max)
   (concat "sed 's/\\x1b\\[[0-9;]*[a-zA-Z]//g;s/\\x1b\\[[\\?1-9].....//g;"
           "s///g;s///g'")
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
(defun cdr:readme-guix-instructions (project type namespace main-lib)
  "Templating function for the 'Guix' section of my README.md files."
  (interactive)
  (let ((shell-addons (cond ((string= type "guile")
                             "guile -- guile")
                            ((string= type "emacs")
                             "emacs")
                            ((string= type "java")
                             "icedtea:jdk icedtea")
                            ((string= type "apl")
                             "apl")
                            ((string= type "common-lisp")
                             "sbcl")
                            ((string= type "clojure")
                             "clojure clojuretools -- clj")
                            ((string= type "c")
                             "gcc")
                            (t
                             "--check"))))
    (concat
     "*** GNU Guix\n\n"
     "If You use [[https://guix.gnu.org/][GNU Guix]], this package \n"
     "is on [[https://sr.ht/~yewscion/yewscion-guix-channel/][my channel]]."
     "\n\n"
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
     "guix shell --pure --rebuild-cache -v4 "
     project
     " bash "
     shell-addons
     "\n"
     "#+end_src\n\n"
     "And if You'd rather just try it out "
     "without my channel, You can clone this\nrepo and then do:\n"
     "#+begin_src bash\n"
     "cd "
     project
     "\n./cast.sh\n"
     "#+end_src\n\n"
     "Either of these will create a profile with *just* this project in it, "
     "to mess around with.\n\n")))
(defun cdr:readme-src-instructions (project type namespace main-lib)
  "Templating function for the 'Source' section of my README.md files."
  (interactive)
  (cond ((or (string= type "gnu") (string= type "guile"))
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
          "The needed dependencies are tracked in the =DEPENDENCIES.txt= file\n"
          "to support this use case.\n\n"))
        ((string= type "emacs")
         (concat
          "*** Source\n\n"
          "If You don't want to use [[https://guix.gnu.org/][GNU Guix]],\n"
          "You can clone this repo and install it in the normal way "
          "(assuming You have\n an =~/.emacs.d/init.el=, and that "
          "=~/.emacs.d/lisp= is in Your load-path):\n\n"
          "#+begin_src bash\n"
          "git clone https://git.sr.ht/~yewscion/"
          project
          "\ncd "
          project
          "\ncp -v *.el ~/.emacs.d/lisp/"
          "\ncat >> ~/.emacs.d/init.el <<< (require '"
          namespace
          ")"
          "\n#+end_src\n\n"
          "Then, in Emacs, it's just a matter of restarting (or calling \n"
          "=M-x package-initialize= again!) and You should be good to go.\n\n"
          "You can also just open the ="
          project
          ".el= file and run =M-x eval-buffer=,\n"
          "but that only lasts for the current session.\n\n"
          "If You don't want to use git, or would rather stick with an\n"
          "actual release, then see the tagged releases for some tarballs\n"
          "of the source.\n\n"
          "You can also install using the standard "
          "=./configure && make && make check && make install=\n"
          "sequence, as I use GNU Autotools for all of my projects.\n\n"
          "The needed dependencies are tracked in the =DEPENDENCIES.txt= file\n"
          "to support this use case.\n\n"))
        (t
         "")))

(defun cdr:readme-install-instructions (project &optional type namespace main-lib)
  "Templating function for the 'Install' section of my README.md files."
  (interactive)
  (let ((type (if type type "guile"))
        (namespace (if namespace namespace "cdr255"))
        (main-lib (if main-lib main-lib "core")))
    (concat
     "** Installation\n"
     (cdr:readme-guix-instructions project type namespace main-lib)
     (cdr:readme-src-instructions project type namespace main-lib))))
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
   "If You've made changes without the above precautions, those changes will"
   "\nneed to be confirmed to work in the above environment before merge.\n"
   "\n"))
(defun cdr:readme-license-instructions (project license)
  "Templating function for the 'License' section of my README.md files."
  (interactive)
  (concat
   "** License\n\n"
   "The ="
   project
   "= project and all associated files are ©2022 Christopher\nRodriguez, but"
   " licensed to the public at large under the terms of the:\n\n"
   (cond ((string= license "agpl")
          "[[https://www.gnu.org/licenses/agpl-3.0.html][GNU AGPL3.0+]]")
         ((string= license "fdl")
          "[[https://www.gnu.org/licenses/fdl-1.3.en.html][GNU FDL1.3+]]")
         (t
          "project's"))
   " license.\n\n"
   "Please see the =LICENSE= file and the above link for more information."))
(defun cdr:readme-std-usage-instruction-header (project)
  "Templating function for the header of the 'Usage' section of my
README.md files."
  (concat
   "** Usage\n\n"
   "Full usage is documented in the =doc/"
   project
   ".info= file. Here are\nonly generic instructions.\n\n"))

(setq cdr:binary-message
      (concat "Any binaries or scripts will be available in Your =$PATH=. A "
              "list of these\nis maintained in the info file. They all also "
              "have the =--help= flag, so\nif You prefer learning that way,"
              " that is also available.\n\n"))
(defun cdr:readme-std-usage-instructions (project &optional
                                                  type namespace main-lib
                                                  binary-message)
  "Templating function for the 'Usage' section of my README.md files."
  (interactive)
  (let ((type (if type type "guile"))
        (namespace (if namespace namespace "cdr255"))
        (main-lib (if main-lib main-lib "core"))
        (header (cdr:readme-std-usage-instruction-header project))
        (binary-message (if binary-message binary-message
                          cdr:binary-message)))
    (cond ((string= type "guile")
           (concat
            header
            "You should be able to access all of\nits exported"
            " functions in guile by using its modules:\n\n"
            "#+begin_src scheme\n"
            "(use-modules ("
            namespace
            " "
            main-lib
            "))\n"
            "#+end_src\n\n"
            binary-message))
          ((string= type "emacs")
           (concat
            header
            "Once ="
            project
            "= in installed, You should be able to access all of\nits "
            "functionality in emacs. You may need to add the following"
            " to\nYour init file: \n#+begin_src lisp\n(require '"
            namespace
            ")\n"
            "#+end_src\n\n"))
          ((string= type "java")
           (concat
            header
            "You should be able to access the libaries related to this "
            "project so long as\nYour =CLASSPATH= is set properly. This "
            "can be accomplished either by setting\nthe environment "
            "variable itself, or by calling =java= et. al with the =-cp=\n"
            "flag. When possible, jars are installed alongside the "
            "classfiles themselves,\nin order to allow for the most "
            "versatility when it comes to the end-user's\nwishes.\n\n"
            binary-message))
          ((string= type "apl")
           (concat
            header
            "GNU APL libraries are interestingly different than most "
            "languages, as they\nare organized in workspaces.\n\nIn order "
            "to use the libraries included here, there are a few "
            "options\navailable:\n\n1. You can simply =)PCOPY= the =.apl= "
            "files themselves.\n\n2. Second, You can use the config file or "
            "=)LIBS n <path>= to set\none of Your nine workspaces to the "
            "directory where the files are\ninstalled.\n\n3. Finally, You "
            "can also simply copy the functions You want to use (I\nwould "
            "enjoy a commented attribution, if possible) provided You still "
            "adhere\nto the =LICENSE=.\n\n"
            binary-message))
          ((string= type "common-lisp")
           (concat
            header
            "Common lisp actually has an\n[[https://yewscion.com/common-"
            "common-lisps-in-guix.html][interesting issue]]\nright now in "
            "GNU Guix, so be aware of that if using more than one\n"
            "implementation.\n\nOther than that, loading using =asdf= is "
            "usually the way to go."
            binary-message))
          ((string= type "clojure")
           (concat
            header
            "Clojure has a few design decisions that makes working with it "
            "in GNU Guix\ndifficult, but the basics are the same as normal. "
            "Just remember: No automatic\ndependency management, and no "
            "=leiningen=."
            binary-message))
          ((string= type "c")
           (concat
            header
            "You should be able to access the libraries related to this "
            "project by\nreferencing the =/usr/lib= directory, as normal. "
            "If a subdirectory was\nneeded, I most likely chose "
            "=/usr/lib/yewscion=. If You are using GNU Guix,\nthe actual "
            "directory will be slightly different, depending on Your "
            "profile\nsetup.\n\nYou should be able to access the headers "
            "using the standard =#include=\nsyntax.\n\n"
            binary-message))
          ((string= type "other")
           (concat
            header
            binary-message)))))

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
      ;; We bind `paragraph-start' and `paragraph-separate' temporarily.
      ;; They are buffer-local, but we avoid changing them so that they can
      ;; be set to make `forward-paragraph' and friends do something the user
      ;; wants.
      ;;
      ;; `paragraph-start': The `(' in the character alternative and the
      ;; left-singlequote plus `(' sequence after the \\| alternative prevent
      ;; sexps and backquoted sexps that follow a docstring from being filled
      ;; with the docstring.  This setting has the consequence of inhibiting
      ;; filling many program lines that are not docstrings, which is
      ;; sensible, because the user probably asked to fill program lines by
      ;; accident, or expecting indentation (perhaps we should try to do
      ;; indenting in that case).  The `;' and `:' stop the paragraph being
      ;; filled at following comment lines and at keywords (e.g., in
      ;; `defcustom').  Left parens are escaped to keep font-locking,
      ;; filling, & paren matching in the source file happy.  The `:' must be
      ;; preceded by whitespace so that keywords inside of the docstring
      ;; don't start new paragraphs (Bug#7751).
      ;;
      ;; `paragraph-separate': A clever regexp distinguishes the first line
      ;; of a docstring and identifies it as a paragraph separator, so that
      ;; it won't be filled.  (Since the first line of documentation stands
      ;; alone in some contexts, filling should not alter the contents the
      ;; author has chosen.)  Only the first line of a docstring begins with
      ;; whitespace and a quotation mark and ends with a period or (rarely) a
      ;; comma.
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
;;; This is here to patch org mode for recent geiser.
(defun org-babel-scheme-execute-with-geiser (code output impl repl)
  "Execute code in specified REPL.
If the REPL doesn't exist, create it using the given scheme
implementation.

Returns the output of executing the code if the OUTPUT parameter
is true; otherwise returns the last value."
  (let ((result nil))
    (with-temp-buffer
      (insert (format ";; -*- geiser-scheme-implementation: %s -*-" impl))
      (newline)
      (insert code)
      (geiser-mode)
      (let ((geiser-repl-window-allow-split nil)
            (geiser-repl-use-other-window nil))
        (let ((repl-buffer (save-current-buffer
                             (org-babel-scheme-get-repl impl repl))))
          (when (not (eq impl (org-babel-scheme-get-buffer-impl
                               (current-buffer))))
            (message "Implementation mismatch: %s (%s) %s (%s)" impl
                     (symbolp impl)
                     (org-babel-scheme-get-buffer-impl (current-buffer))
                     (symbolp (org-babel-scheme-get-buffer-impl
                               (current-buffer)))))
          (setq geiser-repl--repl repl-buffer)
          (setq geiser-impl--implementation nil)
          (let ((geiser-debug-jump-to-debug-p nil)
                (geiser-debug-show-debug-p nil))
            (let ((ret (funcall (if (fboundp 'geiser-eval-region/wait)
                                    #'geiser-eval-region/wait
                                  #'geiser-eval-region)
                                (point-min) (point-max))))
              (setq result (if output
                               (or (geiser-eval--retort-output ret)
                                   "Geiser Interpreter produced no output")
                             (geiser-eval--retort-result-str ret "")))))
          (when (not repl)
            (save-current-buffer (set-buffer repl-buffer)
                                 (geiser-repl-exit))
            (set-process-query-on-exit-flag (get-buffer-process repl-buffer)
                                            nil)
            (kill-buffer repl-buffer)))))
    result))
(defun cdr:fill-sexp ()
  "Wrap the s-expression at point 3 characters shy of fill-column.

This is an ACTION.

Arguments
=========
None.

Returns
=======
<undefined>.

Impurities
==========
Acts on the current buffer."
  (interactive)
  (save-excursion
    (cdr:goto-last-open-paren)
    (let ((start (point)))
      (forward-list)
      (let ((end (point)))
        (unfill-region start end)
        (goto-char start)
        (cdr:space-fill end (- fill-column 3))))))
(defun cdr:space-fill (end length)
  "Replace the space closest to LENGTH with a newline until the END point.

This is an ACTION.

Arguments
=========
END <position>: The cursor position where filling should stop.
LENGTH <integer>: The column to ensure no line is longer than.

Returns
=======
<undefined>.

Impurities
==========
Acts on the current buffer."
  (while (< (point) end)
    (forward-char length)
    (if (< (point) end)
        (cdr:fill-at-character " "))))
(defun cdr:fill-at-character (character)
  "Replace the first occurance before the current point of CHARACTER with a
newline.

This is an ACTION.

Arguments
=========
CHARACTER <string>: The character (or string) to replace with a newline.

Returns
=======
<undefined>.

Impurities
==========
Acts on the current buffer."
  (search-backward character)
  (delete-char 1)
  (newline)
  (indent-relative))
(defun cdr:goto-last-open-paren ()
  "Go to the start of the innermost (closest) s-expression.

This is an ACTION.

Arguments
=========
None.

Returns
=======
The <position> of the cursor after the move.

Impurities
==========
Moves the cursor in the current buffer."
  (goto-char (car (last (nth 9 (syntax-ppss))))))
(defun cdr:clean-up-newlines ()
  "Remove Repeated Newlines in Buffer."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (condition-case nil
        (while t
          (re-search-forward "\n+")
          (replace-match "\n"))
      (error nil))))
(defun cdr:strip-c-comments-from-buffer ()
  "Remove all multiline C comments from the current buffer.

Example of such a comment:
/** This
 *  is
 *  a
 *  Comment. */

This is an ACTION.

Arguments
=========
None.

Returns
=======
Undefined.

Impurities
==========
Changes current buffer by stripping away all multiline
C-style comments."
  (interactive)
                                        ;  (let ((regexp "\\/\\*\\*\\(.\\|\n\\)+?\\*\\/")
  (let ((regexp "\\/\\*\\*\\(\n\\|\\([^*]\\(.\\|\n\\)\\||.[^/]\\)\\)+\\*\\/")
        (empty ""))
    (save-excursion
      (goto-char (point-min))
      (replace-regexp regexp empty))))
;;; Skeletons
(define-skeleton hog-skeleton
  "Sets up a new hog template in my org file"
  nil
  "** " '(let ((current-prefix-arg '(16)))(call-interactively
                                           'org-time-stamp-inactive))
  ?\n "*** Hand-Off Details" ?\n "
  #+begin_src markdown" ?\n "    ### Summary" ?\n "    <pre>" ?\n ?\n
  "    </pre>" ?\n " #+end_src" ?\n
  ?\n "*** Start of Shift Summary" ?\n ?\n
  "  #+begin_src org :results html replace"
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

;;; Org Capture
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
(defun offlineimap-get-password (host port)
  (let* ((authinfo (netrc-parse (expand-file-name "~/.authinfo.gpg")))
         (hostentry (netrc-machine authinfo host port port)))
    (when hostentry (netrc-get hostentry "password"))))
(defun replace-in-string (what with in)
  (replace-regexp-in-string (regexp-quote what) with in nil 'literal))

(defun cdr:insert-guix-hash ()
  "Insert the guix hash for the most recent commit in a git repo at point.

This is an ACTION.

Arguments
=========

None.

Returns
=======

Undefined.

Impurities
==========

I/O, Depends on Filesystem and two commands (guix and git),
creates directory and clones user-supplied directory/URI with
git."
  (interactive)
  (let ((repo   (if (y-or-n-p "Local Directory?")
                    (read-directory-name "Hash this Repo:  ")
                  (read-string "Hash this Repo:  "))))
    (insert (cdr:run-guix-hash-in-temp-dir repo))))

(defun cdr:run-guix-hash-in-temp-dir (repo)
  "Compute the guix hash of REPO using a temporary directory.

This is an ACTION.

Arguments
=========

REPO <string>: The path/uri to the repo in question.

Returns
=======

A <string> representing the guix hash of the given REPO.

Impurities
==========

Creates and Deletes a directory in /tmp, changes the current
directory mid-execution, clones a git repo, and runs guix hash on
it."
  (let ((tempdir (make-temp-file "cdr-emacs-guix" t))
        (olddir  (cdr:get-pwd)))
    (unwind-protect
        (progn
          (cd tempdir)
          (shell-command
           (cdr:generate-shell-command-git-clone-pwd repo))
          (string-trim-right
            (shell-command-to-string
             "guix hash -rx .")))
      (progn
        (delete-directory tempdir t)
        (cd olddir)))))

(defun cdr:generate-shell-command-git-clone-pwd (repo)
  "Generate a command to clone REPO into the current (assumed empty) directory.

This is a CALCULATION.

Arguments
=========
REPO<string>: The path/url to the repo in question.

Returns
=======
A <string> representing the command to run to clone REPO into the current
directory.

Impurities
==========
None."
  (concat
   "git clone --quiet "
   repo
   " ."))

(defun cdr:get-pwd ()
  "Returns the canonicalized default directory for the current buffer.

This is an ACTION.

Arguments
=========
None.

Returns
=======
A <string> representing the current directory for the current buffer.

Impurities
==========
Relies on system state."
  (expand-file-name
   default-directory))
(defun cdr:make-daily-journal-entry ()
"Create a new daily entry in my org-journal, with the current
template inserted and default encryption set up for my GPG key.

This is an ACTION.

Arguments
=========
None.

Returns
=======
A <string> representing the resulting contents of the day's
journal file.

Impurities
==========
Creates/Opens a buffer, inserts contents of file on disk, uses
current datetime."
  (interactive)
  (org-journal-new-entry nil)
  (setq-local epa-file-encrypt-to '("1102102EBE7C3AE4"))
  (insert "\n")
  (insert-file-contents (concat (getenv "HOME")
                                "/.emacs.d/templates/journal-entry.org"))
  (buffer-substring-no-properties (point-min) (point-max)))
(defun cdr:orgy-copy-item ()
  "Copy the current item in the org-list at point to the kill ring.

This is an ACTION.

Arguments
=========
None.

Returns
=======
Undefined.

Impurities
==========
Relies on buffer state."
  (interactive)
  (let* ((begin (org-list-get-item-begin))
         (end (org-list-get-item-end begin (org-list-struct))))
    (save-excursion
      (copy-region-as-kill begin end))))

(defun cdr:orgy-copy-rest-of-list ()
  "Copy the current item in the org-list at point, and all items following it
to the kill ring.

This is an ACTION.

Arguments
=========
None.

Returns
=======
Undefined.

Impurities
==========
Relies on buffer state and point."
  (interactive)
  (let* ((current-list (org-list-struct))
         (begin (org-list-get-item-begin))
         (end (org-list-get-bottom-point current-list)))
    (copy-region-as-kill begin end)))

(defun cdr:orgy-empty-list-item-p (&optional item-point struct)
  "Predicate to tell if the list item at ITEM-POINT is empty.

This is an ACTION.

Arguments
=========
ITEM-POINT <number>: The point at which to check for an empty list item.

Returns
=======
Undefined.

Impurities
==========
Relies on buffer state."
  (interactive)
  (save-excursion
    (let ((item-point (if item-point item-point (point))))
      (goto-char item-point)
      (let ((begin-item (org-in-item-p)))
        (unless begin-item
          (error "Point not in a list item."))
        (let* ((struct (if struct struct (org-list-struct)))
               (list-item (assoc begin-item struct))
               (length-of-bullet (length (nth 2 list-item)))
               (length-of-cookie (if (nth 4 list-item)
                                     (length (nth 4 list-item))
                                   0))
               (length-of-item (nth 6 list-item))
               (preamble (+ begin-item length-of-bullet length-of-cookie))
               (spaces (how-many " " preamble length-of-item))
               (minimum (+ preamble spaces 1)))
          (<= length-of-item minimum))))))

;; Thanks to user Vladimir Panteleev at the following URL:
;; https://stackoverflow.com/a/35711240/16201239
(defun delete-current-line ()
  "Delete (not kill) the current line."
  (interactive)
  (save-excursion
    (delete-region
     (progn (forward-visible-line 0) (point))
     (progn (forward-visible-line 1) (point)))))

(defun cdr:orgy-identify-empty-list-items (&optional struct)
  "Remove all empty list items from the current list.

This is an ACTION.

Arguments
=========
None.

Returns
=======
Undefined.

Impurities
==========
Relies on buffer state."
  (interactive)
  (let ((struct (if struct struct (org-list-struct))))
    (unless struct
      (error "Point not in an org-list."))
    (save-excursion
      (cl-loop for item in struct
               collect
               (progn
                 (goto-char (nth 0 item))
                 (cdr:orgy-empty-list-item-p (nth 0 item) struct))))))

(defun cdr:orgy-remove-empty-list-items ()
  "Remove all empty list items from the current list.

This is an ACTION.

Arguments
=========
None.

Returns
=======
Undefined.

Impurities
==========
Relies on buffer state."
  (interactive)
  (let* ((struct (org-list-struct))
         (rev-struct (reverse struct))
         (ids (reverse (cdr:orgy-identify-empty-list-items struct))))
    (save-excursion
      (cdr:orgy-delete-list-items-by-id rev-struct ids))))

(defun cdr:orgy-delete-list-items-by-id (struct ids)
  "Delete list items from the list defined by STRUCT, based on the
boolean list of IDS.

This expects both the STRUCT and the IDS to be in reverse order,
with the last item first.

This is an ACTION.

Arguments
=========
STRUCT <<list> of <org list items>>: The output of org-list-struct, but
reversed (so the last element is first)

IDS <<list> of <booleans>>: A list that matches the length of
STRUCT, with each truthy value indicating an entry should be
deleted, and each falsey value indicating it should stay.

Returns
=======
Undefined.

Impurities
==========
Changes Buffer State."
  (let ((count (- (length struct) 1)))
    (save-excursion
      (cl-loop for n from 0 to count do
               (let ((current-item (nth n struct))
                     (current-id (nth n ids)))
                 (goto-char (nth 0 current-item))
                 (when current-id
                   (delete-region (point)
                                  (nth 6 current-item))))))))
(defun cdr:orgy-journal-date (&optional time)
  "Generates a datecode equivalent to the default for org-journal entries.

This is an ACTION.

Arguments
=========

TIME <number> or <list> or <nil>: A valid time, as specified by
format-time-string. Usually either UNIX seconds or '(HI LO US
PS). nil will use the current time.

Returns
=======

A <string> of the format \"YYYYMMDD\" for the specified time,
which is the default filename format for org-journal files.


Impurities
==========

None if time is specified, otherwise relies on current system time."
  (let ((now (decode-time time)))
    (format
     "%d%02d%02d"
     (nth 5 now)
     (nth 4 now)
     (nth 3 now))))



(defun cdr:orgy-journal-filename (&optional time)
  "Generate the default org-journal filename for the given TIME.

This is an ACTION.

Arguments
=========

TIME <number> or <list> or <nil>: A valid time, as specified by
format-time-string. Usually either UNIX seconds or '(HI LO US
PS). nil will use the current time.

Returns
=======

A <string> of the format \"org-journal-directory/YYYYMMDD.gpg\"
for the specified time, which is the default filename format for
org-journal files. \"org-journal-directory\" is pulled from the
global org-journal-dir variable.


Impurities
==========

Relies on global variables and optionally the current system time."
  (concat
   org-journal-dir
   (cdr:orgy-journal-date time)
   ".gpg"))
(defun cdr:timey-unix (&optional offset amount)
    "Returns the current UNIX time (seconds since the epoch) with an
optional AMOUNT of OFFSET, based on the system clock.

This is an ACTION.

Arguments
=========

OFFSET <string>: One of \"day\", \"week\", \"hour\", \"minute\",
or \"second\". Both omitting this value and putting anything else
will result in no offset, regardless of AMOUNT.

AMOUNT <number>: The count of the specified offset blocks to add
to the current system time. Not specifying this will cause no
offset, regardless of OFFSET.

Returns
=======

Undefined.

Impurities
==========

Relies on current system time."
    (if (or (not offset) (not amount))
        (time-convert nil 'integer)
      (let ((offset (cond ((not offset)
                           0)
                          ((string= "day" offset)
                           86400)
                          ((string= "week" offset)
                           604800)
                          ((string= "hour" offset)
                           3600)
                          ((string= "minute" offset)
                           60)
                          ((string= "second" offset)
                           1)
                          (t
                           0)))
            (amount (if amount amount 0)))
        (+ (time-convert nil 'integer) (* amount offset)))))
(defun cdr:timey-unix-today ()
  "Returns the current UNIX time (seconds since the epoch), based on the
system clock.

This is an ACTION.

Arguments
=========

None.

Returns
=======

Undefined.

Impurities
==========

Relies on current system time."
  (cdr:timey-unix))
(defun cdr:timey-unix-yesterday ()
  "Returns the UNIX time (seconds since the epoch) for exactly one
day in the past, based on the system clock.

This is an ACTION.

Arguments
=========

None.

Returns
=======

Undefined.

Impurities
==========

Relies on current system time."
  (cdr:timey-unix "day" -1))
(defun cdr:timey-unix-tomorrow ()
  "Returns the UNIX time (seconds since the epoch) for exactly one
day in the future, based on the system clock.

This is an ACTION.

Arguments
=========

None.

Returns
=======

Undefined.

Impurities
==========

Relies on current system time."
  (cdr:timey-unix "day" 1))
(defun cdr:timey-unix-last-week ()
  "Returns the UNIX time (seconds since the epoch) for exactly one
day in the future, based on the system clock.

This is an ACTION.

Arguments
=========

None.

Returns
=======

Undefined.

Impurities
==========

Relies on current system time."
  (cdr:timey-unix "week" -1))
(defun cdr:orgy-open-journal-today ()
  "Opens today's org-journal file, or switches to the already-open buffer.

This is an ACTION.

Arguments
=========

None.

Returns
=======

Undefined.

Impurities
==========

Relies on global variables, filesystem state, and current system time."
  (interactive)
  (find-file (cdr:orgy-journal-filename (cdr:timey-unix-today))))
(defun cdr:orgy-open-journal-yesterday ()
  "Opens yesterday's org-journal file, or switches to the already-open buffer.

This is an ACTION.

Arguments
=========

None.

Returns
=======

Undefined.

Impurities
==========

Relies on global variables, filesystem state, and current system time."
  (interactive)
  (find-file (cdr:orgy-journal-filename (cdr:timey-unix-yesterday))))
(defun cdr:orgy-open-journal-last-week ()
  "Opens the org-journal file from one week ago, or switches to the
already-open buffer.

This is an ACTION.

Arguments
=========

None.

Returns
=======

Undefined.

Impurities
==========

Relies on global variables, filesystem state, and current system time."
  (interactive)
  (find-file (cdr:orgy-journal-filename (cdr:timey-unix-last-week))))


;; Without this `mail-user-agent' cannot be set to `mu4e-user-agent'
;; through customize, as the custom type expects a function.  Not
;; sure whether this function is actually ever used; if it is then
;; returning the symbol is probably the correct thing to do, as other
;; such functions suggest.
(defun mu4e-user-agent ()
  "Return the `mu4e-user-agent' symbol."
  'mu4e-user-agent)
(setq mail-user-agent (mu4e-user-agent))
(defun cdr:set-glyphs-for-bqn ()
  (interactive)
  (let ((bqn-glyphs
         '(?× ?÷ ?⋆ ?√ ?⌊ ?⌈ ?¬ ?∧ ?∨ ?≠ ?≤ ?≥ ?≡ ?≢ ?⊣ ?⊢ ?⥊ ?∾ ?≍
              ?⋈ ?↑ ?↓ ?↕ ?« ?» ?⌽ ?⍉ ?⍋ ?⍒ ?⊏ ?⊑ ?⊐ ?⊒ ?∊ ?⍷ ?⊔ ?˙ ?˜ ?˘ ?¨
              ?⌜ ?⁼ ?´ ?˝ ?∘ ?○ ?⊸ ?⟜ ?⌾ ?⊘ ?◶ ?⎉ ?⚇ ?⍟ ?⎊ ?𝕨 ?𝕩 ?𝕗 ?𝕘
              ?𝕤 ?𝕣 ?𝕎 ?𝕏 ?𝔽 ?𝔾 ?𝕊 ?𝕣 ?← ?⇐ ?↩ ?⟨ ?⟩ ?‿ ?· ?⋄)))
    (mapc (lambda (x)
            "Set Font of Character to BQN386 Unicode."
            (set-fontset-font t x (font-spec :family "BQN386 Unicode")))
          bqn-glyphs)))


(defun cdr:kill-buffer ()
  "Add the entirety of the current buffer to the kill ring, with guard rails.

This is an ACTION.

Arguments
=========

None.

Returns
=======

Undefined.

Impurities
==========

Used entirely for Side Effects: Modifies kill-ring and uses
current buffer state."
  (interactive)
  (kill-new (concat
             "--------\n"
             (cdr:remove-ending-newlines
              (cdr255:buffer-as-string))
             "\n"
             "--------\n"
             )))
(defun cdr:kill-buffer-as-comment ()
  "Add the entire buffer to the kill ring as a comment of the current mode's
syntax.

This is an ACTION.

Arguments
=========

None.

Returns
=======

Undefined.

Impurities
==========

Used entirely for Side Effects: Modifies kill-ring and uses
current buffer state and mode."
  (interactive)
  (kill-new (cdr:comment-block-from-buffer)))

(defun cdr:comment-block-from-buffer ()
  "Create a comment block out of the contents of the current buffer.

This is an ACTION.

Arguments
=========

None.

Returns
=======

Undefined.

Impurities
==========

Used entirely for Side Effects: Modifies kill-ring and uses
current buffer state and mode."
  (cdr:create-comment-block (cdr255:buffer-as-string)))

(defun cdr:create-comment-block (string)
  "Create a comment block using STRING as the contents.

This is an ACTION.

Arguments
=========

STRING <string>: The contents of the comment block.

Returns
=======

A <string> with the original STRING surrounded by guard rails and
with comment padding and characters prepended to each line.

Impurities
==========

Relies on current buffer's major mode for comment characters."
  (concat comment-start
          comment-padding
          "--------\n"
          (cdr:comment-string string)
          "\n"
          comment-start
          comment-padding
          "--------\n"))

(defun cdr:comment-string (string)
  "Comment STRING using the current major mode's comment syntax, after
removing any extraneous newlines.

This is an ACTION.

Arguments
=========

STRING <string>: The string to turn into a comment.

Returns
=======

A <string> representing the original STRING with comment padding
and characters prepended to each line.

Impurities
==========

Relies on current buffer's major mode for comment characters."
  (cdr255:comment-multiline-string
   (cdr:remove-ending-newlines string)))


(defun cdr:remove-ending-newlines (string)
  "Removes extra newlines at the end of STRING, leaving none.

This is a CALCULATION.

Arguments
=========

STRING <string>: The string to turn into a comment.

Returns
=======

A <string> representing the original STRING, but with no ending
newlines.

Impurities
==========

None."
  (replace-regexp-in-string "\n+\\'" "" string))


(fset 'cdr:paste-commit-and-update-hash
   (kmacro-lambda-form [?\C-y ?\M-d ?\C-s ?u ?r ?l return ?\C-f
   ?\C-f ?\C- ?\C-s ?\" return ?\C-b ?\M-w ?\C-s ?b ?a ?s ?e ?3
   ?2 return ?\C-s ?\" return ?\M-d ?\M-x ?c ?d ?r ?: ?i ?n ?s ?e
   ?r ?t ?- ?g ?u ?i ?x ?- ?h ?a ?s ?h return ?n ?\C-y ?\M-y
   return] 0 "%d"))
(defun cdr:yank-as-comment ()
  "Yank the top of the kill ring into the current buffer as a comment.

This is an ACTION.

Arguments
=========

None.

Returns
=======

Undefined.

Impurities
==========

Used entirely for Side Effects: Modifies kill-ring and current buffer."
  (interactive)
  (progn (yank)
         (comment-region (mark) (point))))
(defun cdr:ebiby-key-page-description (key db)
  (format "%s (%s)"
          key
          (ebib-get-field-value "pagetotal" key db "???" 'unbraced 'xref)))

(defun cdr:ebiby-title-page-description (key db)
  (format "%s (%s)"
          (ebib-get-field-value "title" key db "Unknown Title" 'unbraced 'xref)
          (ebib-get-field-value "pagetotal" key db "???" 'unbraced 'xref)))
(defun cdr:ebiby-journal-description (key db)
  (format "%s v%sn%s - pages %s (%s)"
          (ebib-get-field-value "journaltitle" key db "Unknown Journal" 'unbraced 'xref)
          (ebib-get-field-value "volume" key db "??" 'unbraced 'xref)
          (ebib-get-field-value "number" key db "??" 'unbraced 'xref)
          (ebib-get-field-value "pages" key db "???-???" 'unbraced 'xref)
          (ebib-get-field-value "pagetotal" key db "???" 'unbraced 'xref)))
(defun cdr:ebiby-chapter-description (key db)
  (format "%s, Chapter %s%s - pages %s (%s)"
          (ebib-get-field-value "booktitle" key db "Unknown Book" 'unbraced 'xref)
          (ebib-get-field-value "chapter" key db "??" 'unbraced 'xref)
          (concat
           ": "
           (ebib-get-field-value "title" key db "" 'unbraced 'xref))
          (ebib-get-field-value "pages" key db "???-???" 'unbraced 'xref)
          (ebib-get-field-value "pagetotal" key db "???" 'unbraced 'xref)))

(defun cdr:ebiby-set-citation-description (name procedure)
  (message (concat
            "Setting Ebib Description to \""
            name
            "\"!"))
  (setq ebib-citation-description-function
        procedure))
(defun cdr:ebiby-toggle-citation-style ()
  (interactive)
  (cond ((equal ebib-citation-description-function
                #'cdr:ebiby-key-page-description)
         (cdr:ebiby-set-citation-description
          "TitlePage" #'cdr:ebiby-title-page-description))
        ((equal ebib-citation-description-function
                #'cdr:ebiby-title-page-description)
         (cdr:ebiby-set-citation-description
          "Journal" #'cdr:ebiby-journal-description))
        ((equal ebib-citation-description-function
                #'cdr:ebiby-journal-description)
         (cdr:ebiby-set-citation-description
          "Chapter" #'cdr:ebiby-chapter-description))
        ((equal ebib-citation-description-function
                #'cdr:ebiby-chapter-description)
         (cdr:ebiby-set-citation-description
          "KeyPage" #'cdr:ebiby-key-page-description))
        (t
         (cdr:ebiby-set-citation-description
          "KeyPage(u)" #'cdr:ebiby-key-page-description))))

(defun cdr:display-refcard-menu ()
  (interactive)
  (cdr255:selection-menu
   "Refcards"
   (cdr255:create-temp-file-menu-alist
    cdr:refcards-alist)))

(defun cdr:hog-it ()
  (interactive)
  (let ((task-clock (cdr:hog-grab-task-clock-as-string))
        (inbox (cdr:hog-grab-inbox-as-string)))
    (save-excursion
      (org-save-outline-visibility t
        (org-fold-hide-sublevels 2)
        (goto-char (org-find-exact-headline-in-buffer "HOG"))
        (next-line 1)
        (org-insert-heading-after-current)
        (setq current-prefix-arg '(16))
        (call-interactively #'org-time-stamp-inactive)
        (insert (concat
                 "\n*** Hand-Off Details\n#+begin_src markdown\n"
                 task-clock
                 "\n#+end_src\n*** Start of Shift Summary\n#+begin_src markdown\n"
                 inbox
                 "\n#+end_src\n"))
        (message "🐽🐽🐽 Hogging It! 🐽🐽🐽")))))
(defun cdr:hog-cleanup-hog-inbox (hog-inbox-string)
  (replace-regexp-in-string
   "\n " ""
   hog-inbox-string))

(defun cdr:hog-cleanup-task-clock (task-clock-string)
  (replace-regexp-in-string
   "-+|" "-|"
   (replace-regexp-in-string
    " +|" " |"
    (replace-regexp-in-string
     "\n\n+" ""
     (replace-regexp-in-string
      "\\\\_ +" ""
      (replace-regexp-in-string
       "/" "*"
       (replace-regexp-in-string
        "\\*" "**"
        (replace-regexp-in-string
         "-\\+-" "-|-"
         (replace-regexp-in-string
          "  #\\+.*" ""
          task-clock-string)))))))))

(defun web:org-element-to-string ()
  (let* ((e (org-element-at-point))
         (beg (org-element-property :begin e))
         (end (org-element-property :end e)))
    (string-trim-right (buffer-substring-no-properties beg end))))


(defun web:heading-contents-to-string ()
  (interactive)
  (save-excursion
    (org-back-to-heading)
    (forward-line)
    (unless (= (point) (point-max))
      (let ((b (point))
            (e (or (outline-next-heading) (point-max))))
        (buffer-substring-no-properties b e)))))

(defun cdr:hog-grab-task-clock-as-string ()
  (interactive)
  (save-excursion
    (org-save-outline-visibility t
      (org-fold-hide-sublevels 2)
      (goto-char (org-find-exact-headline-in-buffer "Tasks"))
      (search-forward "#+name: task-clocktable")
      (search-forward "#+begin")
      (cdr:hog-cleanup-task-clock
       (web:org-element-to-string)))))

(defun cdr:hog-grab-inbox-as-string ()
  (interactive)
  (save-excursion
    (org-save-outline-visibility t
      (org-fold-hide-sublevels 10)
      (goto-char (org-find-exact-headline-in-buffer "HOG Inbox"))
      (cdr:hog-cleanup-hog-inbox
       (web:heading-contents-to-string)))))

(defun cdr:emmsy-play-ost-midi ()
  (interactive)
  (emms-play-directory "~/Music/MIDI/OST")
  (emms-stop)
  (emms-shuffle)
  (dotimes (i 10)
    (emms-next)
    (emms-shuffle))
  (emms-start))

;;; Staging
;; Use monospaced font faces in current buffer
(defun cdr:switch-to-unifont ()
  "Sets a fixed width (monospace) font in current buffer"
  (interactive)
  (setq buffer-face-mode-face '(:family "unifont"))
  (buffer-face-mode))

(defun cdr:set-buffer-local-family (font-family)
  "Sets font in current buffer"
  (interactive "sFont Family: ")
  (defface tmp-buffer-local-face
    '((t :family font-family))
    "Temporary buffer-local face")
  (buffer-face-set 'tmp-buffer-local-face))
(setq cdr:cursor-types
      '((box hollow)
        (hollow bar)
        (bar hbar)
        (hbar box)))
(defun cdr:toggle-cursor ()
  (interactive)
  (cdr255:toggle-proc-var-alist #'cdr:update-cursor-type
                                (cdr:car-or-value cursor-type)
                                cdr:cursor-types)
  (message (concat "Cursor is now "
                   (format "%s" cursor-type)
                   "!")))
(defun cdr:update-cursor-type (new-symbol)
  (setq-default cursor-type
                (if (listp cursor-type)
                    (cons new-symbol
                          (cdr cursor-type))
                  new-symbol)))

(defun cdr:car-or-value (item)
  (if (listp item)
      (car item)
    item))

(fset 'cdr:convert-cbnf-to-list-of-strings
   (kmacro-lambda-form [C-f2 ?i ?\C-x ?h C-f2 ?\C-r ?- ?- ?. ?*
   ?\C-q ?\C-j return return ?\C-x ?h C-f2 ?r ?\; return return
   ?\C-x ?h C-f2 ?r ?  ?| return return C-f2 ?\C-u ?\C-x ?h ?\M-w
   ?\C-c ?\C-k] 0 "%d"))

(defun cdr:insert-indented (string)
  (let ((start (point)))
    (insert string)
    (indent-region start
                   (point))))

(defun cdr:cleanup-shell-output (command)
  (string-trim-right
   (shell-command-to-string
    command)))

(defun cdr:build-guix-import-command (name version importer recursive-p)
  (concat "guix import " importer (if recursive-p " --recursive " " ")
          name (if version
                   (concat "@" version)
                 " ")
          " 2>/dev/null"))

(defun cdr:insert-guix-imported-package (name version importer indent-p recursive-p)
  (let* ((command (cdr:build-guix-import-command
                   name version importer recursive-p))
         (pkg-prefix (if (or
                          (string= importer "elpa -a melpa")
                          (string= importer "elpa -a nongnu"))
                         "emacs"
                       importer))
         (prefix (if (not recursive-p) (concat "(define-public " pkg-prefix "-" name "\n")
                   nil))
         (package-definition (concat (if prefix prefix "")
                                     (cdr:cleanup-shell-output
                                      command)
                                     (if prefix ")" ""))))
    (if (string= "" package-definition)
        (error "No package produced; Check output of `%s` in shell!"
               command))
    (if indent-p (cdr:insert-indented package-definition)
      (insert package-definition))))

(defun cdr:insert-guix-hexpm-package (name version)
  (interactive "sPackage Name?
sVersion(Optional)? ")
  (let ((version (cdr255:empty-string-to-nil version)))
    (cdr:insert-guix-imported-package name version "hexpm" t t)))

(defun cdr:insert-guix-elpa-melpa-package (name)
  (interactive "sPackage Name? ")
  (let ((version nil))
    (cdr:insert-guix-imported-package name version "elpa -a melpa" t t)))

(defun cdr:insert-guix-elpa-melpa-package-nonr (name)
  (interactive "sPackage Name? ")
  (let ((version nil))
    (cdr:insert-guix-imported-package name version "elpa -a melpa" t nil)))

(defun cdr:insert-guix-elpa-nongnu-package (name)
  (interactive "sPackage Name? ")
  (let ((version nil))
    (cdr:insert-guix-imported-package name version "elpa -a nongnu" t t)))

(defun cdr:insert-guix-texlive-package (name)
  (interactive "sPackage Name? ")
  (let ((version nil))
    (cdr:insert-guix-imported-package name version "texlive" t nil)))

(defun cdr:insert-guix-elm-package (name version)
  (interactive "sPackage Name?
sVersion(Optional)? ")
  (let ((version (cdr255:empty-string-to-nil version)))
    (cdr:insert-guix-imported-package name version "elm" t t)))

(defun cdr:insert-guix-opam-package (name)
  (interactive "sPackage Name? ")
  (let ((version nil))
    (cdr:insert-guix-imported-package name version "opam" t t)))

(defun cdr:insert-guix-crate-package (name)
  (interactive "sPackage Name? ")
  (let ((version nil))
    (cdr:insert-guix-imported-package name version "crate" t t)))

(defun cdr:insert-guix-cran-package (name)
  (interactive "sPackage Name? ")
  (let ((version nil))
    (cdr:insert-guix-imported-package name version "cran" t t)))

(defun cdr:insert-guix-gem-package (name version)
  (interactive "sPackage Name?
sVersion(Optional)? ")
  (let ((version (cdr255:empty-string-to-nil version)))
    (cdr:insert-guix-imported-package name version "gem" t t)))

(defun cdr:insert-guix-go-package (name version)
  (interactive "sPackage Name?
sVersion(Optional)? ")
  (let ((version (cdr255:empty-string-to-nil version)))
    (cdr:insert-guix-imported-package name version "go" t t)))

(defun cdr:insert-guix-stackage-package (name version)
  (interactive "sPackage Name?
sLTS Version(Optional;Default is 20.4)? ")
  (let ((version (if (string= "" version) "20.4" version)))
    (cdr:insert-guix-imported-package
     name nil (concat "stackage --lts-version=" version " ") t t)))

(defun cdr:insert-guix-hackage-package (name version)
  (interactive "sPackage Name?
sVersion(Optional)? ")
  (let ((version (cdr255:empty-string-to-nil version)))
    (cdr:insert-guix-imported-package name version "hackage" t t)))

(defun cdr:insert-guix-pypi-package (name)
  (interactive "sPackage Name? ")
  (let ((version nil))
    (cdr:insert-guix-imported-package name version "pypi" t t)))

(defun cdr:shry-save-image (&optional copy-url)
  "Save the image under point to ~/Pictures.
If COPY-URL (the prefix if called interactively) is non-nil, copy
the URL of the image to the kill buffer instead."
  (interactive "P")
(let* ((url (get-text-property (point) 'image-url))
       (filename (car (reverse (split-string url "/")))))
    (cond
     ((not url)
      (message "No image under point"))
     (copy-url
      (with-temp-buffer
        (insert url)
        (copy-region-as-kill (point-min) (point-max))
        (message "Copied %s" url)))
     (t
      (message "Saving %s to ~/Pictures..." url)
      (url-copy-file url (concat "~/Pictures/" filename) t)))))

(defun cdr:orgy-babel-tangle ()
  (interactive)
  (let ((tangledir (file-name-base buffer-file-name))
        (files (org-babel-tangle)))
    (if (not (file-directory-p tangledir))
        (mkdir tangledir))
    (mapc (lambda (x)
            (let ((filedir (if (not
                                (file-name-directory x))
                               ""
                             (file-name-directory x))))
              (if (not (file-directory-p
                        (concat tangledir "/" filedir)))
                  (mkdir (concat tangledir "/" filedir)))
              (rename-file x (concat tangledir
                                     "/"
                                     x)
                           t)))
          files)))

(defun cdr:process-shipt-receipt ()
  (interactive)
   (condition-case nil
      (while t
        (cdr:process-shipt-receipt-item))
    (error nil)))

(defun cdr:process-shipt-receipt-item ()
  (interactive)
  (cdr:kvpl-enclose-value-discarding-key "QTY")
  (cdr:delete-double-nl-add-table-divider)
  (cdr255:delete-previous-line)
  (cdr:delete-double-nl-add-table-divider)
  (cdr:delete-double-nl-add-table-divider)
  (cdr:delete-double-nl-add-table-divider)
  (beginning-of-line)
  (insert " |  |  |  |")
  (cdr255:delete-previous-line)
  (insert "|"))

(defun cdr:kvpl-enclose-value-discarding-key (key)
  (let ((chars-to-delete (+ 1 (length key))))
    (search-forward (concat key ":"))
    (insert " | ")
    (end-of-line)
    (insert " | ")
    (beginning-of-line)
    (delete-char chars-to-delete)))

(defun cdr:delete-preceding-double-newline ()
  (beginning-of-line)
  (delete-char -2))

(defun cdr:delete-double-nl-add-table-divider ()
  (cdr:delete-preceding-double-newline)
  (insert " | "))

(defun cdr:delete-char-multiple-numbers (list-of-numbers)
  (dolist (current list-of-numbers)
    (delete-char current)))

(defun cdr:toggle-input-methods ()
  (interactive)
  (cdr255:toggle-proc-var-alist #'activate-input-method
                             current-input-method
                             cdr:my-input-methods))
;; Local Variables:
;; mode: emacs-lisp
;; End:
