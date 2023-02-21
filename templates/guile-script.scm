#!/usr/bin/env -S guile \\
-e main -s
!#
#|
This program is a part of @PACKAGE_STRING@.

@LICENSE@

You are welcome to change this software in any way You see fit. Some
helpful information should You choose to do so:

Bug Reports: @PACKAGE_BUGREPORT@
Homepage: @PACKAGE_URL@
Documentation: @PACKAGE_DOCS_COMMAND@ @PACKAGE_NAME@

Happy Hacking!
|#
;;; Template Vars: script-name | project-name | main-procedure | namespace
(use-modules (ice-9 getopt-long)   ; For CLI Options and Flags.
             (ice-9 ftw)           ; For Filesystem Access.
             (ice-9 textual-ports) ; For Writing to Files.
             (srfi srfi-19)        ; For Dates.
             (cdr255 userlib)      ; My personal user library.
             (namespace project-name script-name))
;;; Specific Script Variables
(define %default-config
  ;;; This is the default configuration for this script. Should be scheme
  ;;; code that will create the "script-name-configuration" variable.
  ";;; Configuration File for script-name.
;;; Part of the project-name project.
;;;
;;; A brief description for new users. Probably update the default config,
;;; too.
;;;

(define script-name-configuration
 (list
   (foo bar)))
")

(define configuration
  ;;; Load the configuration file (default above) at the given path. Only
  ;;; change this if You really need to; most configurations should be under
  ;;; ~/.config.
  (get-or-create-configuration-file
   "$HOME/.config/project-name/script-name.scm"
   %default-config))

;;; Actually Load the Config into memory.
(eval-string configuration)

;;; Main
(define option-spec
  ;;; CLI Flags.
  ;;;
  ;;; Generic Format:
  ;;;
  ;;; (LONGOPTION (single-char #\c) ;; Short Option (Optional)
  ;;;             (value [#t|#f|optional]) ;; Should this take a value?
  ;;;             (required? [#t|#f]) ;; Is it an error to omit this option?
  ;;;             (predicate (lambda (x) …)) ;; Procedure for value checking.
  '((version (single-char #\v) (value #f))
    (help (single-char #\h) (value #f))
                                        ; Add more here.
    ))

(define (main args)
  (let* ((options (getopt-long args option-spec))
         (version (option-ref options 'version #f))
         (help (option-ref options 'help #f))
                                        ; Add more here, from above. The
                                        ; final field of option-ref is the
                                        ; default on omission.
         (non-options (option-ref options '() '())))
    (cond ((or
            (not (equal? (length non-options) 0)) ; If there's meant to be
                                                  ; non-option arguments,
                                                  ; this needs changed.
            help
            version)
           (display %help-string))
          (%missing
           (display %missing))
                                        ; Add more here to handle
                                        ; options/edge cases.
          (else
           (main-procedure script-name-configuration)))))

;;; Standard Script Variables

(define %command-and-package-alist
  ;;; Add commands that the script uses that need to exist on the system
  ;;; (Left) and the GNU Guix package they can be found in (Right) for each
  ;;; external program used in the script.
  '(("guile" "guile")))

(define description-spec
  ;;; Each option in option-spec needs to be mentioned here. ACTIONS are
  ;;; usually choices about how the program runs, whereas OPTIONS change how
  ;;; those actions run. The final member should be a very brief description
  ;;; of the option, no longer than ~40 characters long (prefix of 32).
  '((help action "Display this help")
    (version action "Display version info")))

(define note-spec
  ;;; This is a list of specific notes to the user on various errata that
  ;;; might help them use the script. Each member of this list should be a
  ;;; string, and should be a self-contained note.
  (list
   (string-append "" "")))

(define license-spec
  ;;; This is the license portion of the help string, which tells the user
  ;;; how this script is licensed, how to get help, and where to send bug
  ;;; reports. It relies on autoconf for some of its features, in its default
  ;;; state.
  (string-append
   "This program is a part of @PACKAGE_STRING@\n"
   "@LICENSE@"
   "Please report bugs to @PACKAGE_BUGREPORT@\n"
   "and see @PACKAGE_URL@\n"
   "for the latest version.\n\n"

   "This program is entirely written in GNU Guile Scheme,\n"
   "and You are welcome to change it how You see fit.\n\n"

   "Guile Online Help: <https://www.gnu.org/software/guile/>\n"
   "Local Online Help: 'info @PACKAGE_STRING@'\n"))

(define %help-string
  ;;; Build the actual help string from the above. The first entry should be
  ;;; the standard "Here are all of the flags or permutations of this
  ;;; command" line that exists at the top of many help strings.
  (generate-help-string "Usage: script-name [-h|-v]"
                        option-spec
                        description-spec
                        note-spec
                        license-spec))
(define %missing
  ;;; Build the missing command string.
  (missing-commands %command-and-package-alist))

;; Local Variables:
;; mode: scheme
;; End:
