;;; Variables: project-name https://cdr255.com/projects/project-name/ Project Summary
(use-modules
 ;;; These are my commonly needed modules; remove unneeded ones.
 (guix packages)
 ((guix licenses) #:prefix license:)
 (guix download)
 (guix build-system gnu)
 (gnu packages)
 (gnu packages autotools)
 (gnu packages pkg-config)
 (gnu packages texinfo)
 (gnu packages check)
 (guix gexp))

(package
  (name "project-name")
  (version "0.0.1")
  (source (local-file (string-append "./"
                                     name
                                     "-"
                                     version
                                     ".tar.bz2")))
  (build-system gnu-build-system)
  (native-inputs (list autoconf automake pkg-config texinfo check))
  (synopsis "Project Summary")
  (description
   (string-append
    "This is a longer description of the project, which is wrapped using the "
    "string-append function and trailing spaces.."))
  (home-page
   "https://cdr255.com/projects/project-name/")
  (license license:agpl3+))
;; Local Variables:
;; mode: scheme
;; End:
