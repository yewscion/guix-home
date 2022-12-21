(load "services.scm")
(register-services emacs)
(register-services fcitx5)
(action 'shepherd 'daemonize) ; send shepherd into background
(for-each start (list emacs)) ; services to start automatically
