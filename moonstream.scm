;;; jory.scm
;;;
;;; This is the system-config file for Moonstream, my CI Linode.
;;;
;;; Author: Christopher Rodriguez
;;; Created: 2022-02-02
;;; Last Released: 2023-02-02
;;; Contact: yewscion@gmail.com
;;;
(use-modules (gnu)
             (guix modules))
(use-service-modules networking
                     ssh
		     web
		     admin
		     games
		     certbot
                     databases
                     virtualization
		     desktop
		     mcron
		     docker
		     mail
                     cuirass
                     base
                     networking
                     avahi)
(use-package-modules admin
                     certs
                     package-management
                     databases
                     ssh
                     tls
                     emacs
		     xdisorg
		     games
                     sqlite
                     version-control)

(load "emacs-packages.scm")
(load "texlive-packages.scm")
(load "system-packages.scm")
(load "other-packages.scm")


(define %cuirass-specs
  #~(list (specification
           (name "yewscion")
           (build '(channels yewscion))
           (systems  '("x86_64-linux"
                       "aarch64-linux"))
           (priority 1)
           (channels
            (cons (channel
                   (name 'yewscion)
                   (url "https://git.sr.ht/~yewscion/yewscion-guix-channel")
                   (branch "trunk"))
                  %default-channels)))
          (specification
           (name "emacs-packages")
           (build (quote #$(append '(packages) my-emacs-packages)))
           (systems  '("x86_64-linux"
                       "aarch64-linux"))
           (priority 2)
           (channels
            (cons (channel
                   (name 'yewscion)
                   (url "https://git.sr.ht/~yewscion/yewscion-guix-channel")
                   (branch "trunk"))
                  %default-channels)))
          (specification
           (name "texlive-packages")
           (build (quote #$(append '(packages) my-texlive-packages)))
           (systems  '("x86_64-linux"
                       "aarch64-linux"))
           (priority 2)
           (channels
            (cons (channel
                   (name 'yewscion)
                   (url "https://git.sr.ht/~yewscion/yewscion-guix-channel")
                   (branch "trunk"))
                  %default-channels)))
          (specification
           (name "system-packages")
           (build (quote #$(append '(packages) my-gui-system-packages)))
           (systems  '("x86_64-linux"
                       "aarch64-linux"))
           (priority 3)
           (channels
            (cons (channel
                   (name 'yewscion)
                   (url "https://git.sr.ht/~yewscion/yewscion-guix-channel")
                   (branch "trunk"))
                  %default-channels)))
          (specification
           (name "big-ones")
           (build '(packages "clojure-tools" "elm" "emacs" "fluid-3" "fcitx5"
                             "gambit-c" "gauche" "ghc" "icecat" "icedtea"
                             "openjdk" "sbcl" "stumpwm" "timidity++"
                             "ungoogled-chromium" "wesnoth"
                             "wine64-staging" "linux-libre-jory"))
           (channels
            (cons (channel
                   (name 'yewscion)
                   (url "https://git.sr.ht/~yewscion/yewscion-guix-channel")
                   (branch "trunk"))
                  %default-channels))
           (systems '("x86_64-linux"
                      "aarch64-linux"))
           (priority 1))
          (specification
           (name "other-packages")
           (build (quote #$(append '(packages) my-other-packages)))
           (systems  '("x86_64-linux"
                       "aarch64-linux"))
           (priority 2)
           (channels
            (cons (channel
                   (name 'yewscion)
                   (url "https://git.sr.ht/~yewscion/yewscion-guix-channel")
                   (branch "trunk"))
                  %default-channels)))))
(define %nginx-deploy-hook
  (program-file
   "nginx-deploy-hook"
   #~(let ((pid (call-with-input-file "/var/run/nginx/pid" read)))
       (kill pid SIGHUP))))
(define updatedb-job
  ;; Run 'updatedb' at 3AM every day.  Here we write the
  ;; job's action as a Scheme procedure.
  #~(job '(next-hour '(3))
         (lambda ()
           (execl (string-append #$findutils "/bin/updatedb")
                  "updatedb"
                  "--prunepaths=/tmp /var/tmp /gnu/store"))))
(define %local-php-ini
  (plain-file "php.ini"
              "memory_limit = 2G
max_execution_time = 1800"))

(operating-system
  (host-name "moonstream")
  (timezone "America/New_York")
  (locale "en_US.UTF-8")
  ;; This goofy code will generate the grub.cfg
  ;; without installing the grub bootloader on disk.
  (bootloader (bootloader-configuration
               (bootloader
                (bootloader
                 (inherit grub-bootloader)
                 (installer #~(const #t))))))
  (file-systems (cons (file-system
                        (device "/dev/sda")
                        (mount-point "/")
                        (type "ext4"))
                      %base-file-systems))
  (swap-devices (list (swap-space
		       (target "/dev/sdb"))))
  (initrd-modules (cons "virtio_scsi"    ;needed to find the disk
                        %base-initrd-modules))

  (users (cons* (user-account
                (name "ming")
                (group "users")
                (supplementary-groups '("wheel"))
                (home-directory "/home/ming"))
               (user-account
                (name "git")
                (group "git")
                (home-directory "/home/git")
                (comment "For Use With Git")
                (system? #t))
               %base-user-accounts))
  (groups (cons* (user-group
                  (name "git")
                  (system? #t))
                      %base-groups))
  (packages (append (map (compose list specification->package+output)
                         my-system-packages) %base-packages))
  (services (cons*
             (service avahi-service-type)
	     (service unattended-upgrade-service-type)
             (service cuirass-service-type
                      (cuirass-configuration
                       (specifications %cuirass-specs)
                       (host "0.0.0.0")
                       (port 9091)))
             (service guix-publish-service-type
                      (guix-publish-configuration
                       (host "0.0.0.0")
                       (advertise? #f)))
             (service dhcp-client-service-type)
             (service openssh-service-type
                      (openssh-configuration
                       (openssh openssh-sans-x)
                       (password-authentication? #f)
                       (port-number 9418)
                       (authorized-keys
                        `(("ming"
                           ,(local-file "public-keys/ssh-jory.pub")
                           ,(local-file "public-keys/ssh-crane.pub")
                           ,(local-file "public-keys/ssh-radicale.pub")
                           ,(local-file "public-keys/ssh-trisana.pub")
                           ,(local-file "public-keys/ssh-frostpine.pub"))
                          ("git"
                           ,(local-file "public-keys/ssh-jory.pub")
                           ,(local-file "public-keys/ssh-crane.pub")
                           ,(local-file "public-keys/ssh-radicale.pub")
                           ,(local-file "public-keys/ssh-trisana.pub")
                           ,(local-file "public-keys/ssh-frostpine.pub"))))))
             (service postgresql-service-type
                      (postgresql-configuration
                       (postgresql postgresql-15)
                       (port 5432)
                       (data-directory "/var/lib/postgresql/db")
                       (log-directory "/var/log/postgresql/db")))
	     (service elogind-service-type)
	     (simple-service 'my-cron-jobs
			     mcron-service-type
			     (list updatedb-job))
             %base-services)))
