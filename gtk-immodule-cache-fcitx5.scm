;;; Thanks to lizog and their friend for this procedure, which is needed to
;;; regenerate the gtk-immodule-cache for fcitx5.
(define (generate-gtk-immodule-cache gtk gtk-version . extra-pkgs)
  (define major+minor (version-major+minor gtk-version))

  (define build
    (with-imported-modules '((guix build utils)
                             (guix build union)
                             (guix build profiles)
                             (guix search-paths)
                             (guix records))
      #~(begin
          (use-modules (guix build utils)
                       (guix build union)
                       (guix build profiles)
                       (ice-9 popen)
                       (srfi srfi-1)
                       (srfi srfi-26))

          (define (immodules-dir pkg)
            (format #f "~a/lib/gtk-~a/~a/immodules"
                    pkg #$major+minor #$gtk-version))

          (let* ((moddirs (filter file-exists?
                                  (map immodules-dir
                                       (list #$gtk #$@extra-pkgs))))
                 (modules (append-map (cut find-files <> "\\.so$")
                                      moddirs))
                 (query (format #f "~a/bin/gtk-query-immodules-~a"
                                #$gtk:bin #$major+minor))
                 (pipe (apply open-pipe* OPEN_READ query modules)))

            ;; Generate a new immodules cache file.
            (dynamic-wind
              (const #t)
              (lambda ()
                (call-with-output-file #$output
                  (lambda (out)
                    (while (not (eof-object? (peek-char pipe)))
                      (write-char (read-char pipe) out))))
                #t)
              (lambda ()
                (close-pipe pipe)))))))

  (computed-file (string-append "gtk-query-immodules-" major+minor) build))
