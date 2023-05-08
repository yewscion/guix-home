(define emacs
 (make <service>
   #:provides '(emacs)
   #:requires '(fcitx5)
   #:start (make-system-constructor ",emacsclient")
   #:stop (make-system-destructor
           "emacsclient --eval \"(kill-emacs)\"")))

(define fcitx5
  (make <service>
    #:provides '(fcitx5)
    #:requires '()
    #:start (make-system-constructor "fcitx5 -d")
    #:stop (make-kill-destructor)))

(define mcron
  (make <service>
    #:provides '(mcron)
    ;; Run /usr/bin/mcron without any command-line arguments.
    #:start (make-forkexec-constructor '("mcron"))
    #:stop (make-kill-destructor)
    #:respawn? #t))

(register-services emacs fcitx5 mcron)
(action 'shepherd 'daemonize) ; send shepherd into background
(start-in-the-background '(mcron))
