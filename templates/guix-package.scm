(define-public template
  (let* ((tag "")
         (revision "")
         (commit "")
         (version (git-version tag revision commit)))
    (package
      (name "template")
      (version version)
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "")
                      (commit commit)))
                (file-name (git-file-name name version))
                (sha256
                 (base32
                  ""))))
      
      (outputs '("out"))
      (build-system gnu-build-system)
      (arguments
       (list
        #:tests? #t
        ;; #:phases #~(modify-phases
        ;;             %standard-phases
        ;;             )
        ))
      (native-inputs (list ))
      ;; (inputs (list ))
      ;; (propagated-inputs (list ))
      (synopsis "")
      (description ".")
      (home-page "")
      (license license:gpl3))))
