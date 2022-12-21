(define emacs
 (make <service>
   #:provides '(emacs)
   #:requires '(fcitx5)
   #:start (make-system-constructor "emacs --daemon")
   #:stop (make-system-destructor
           "emacsclient --eval \"(kill-emacs)\"")
   #:declarative? #f))

(define fcitx5
  (make <service>
    #:provides '(fcitx5)
    #:requires '()
    #:start (make-system-constructor "fcitx5 -d")
    #:stop (make-kill-destructor)))
