;; This "manifest" file can be passed to 'guix package -m' to reproduce
;; the content of your profile.  This is "symbolic": it only specifies
;; package names.  To reproduce the exact same profile, you also need to
;; capture the channels being used, as returned by "guix describe".
;; See the "Replicating Guix" section in the manual.


;; As of 2022-11-12

(load "emacs-packages.scm")
(load "texlive-packages.scm")
(load "other-packages.scm")

(specifications->manifest
 (append my-emacs-packages
         my-texlive-packages
         my-other-packages))
