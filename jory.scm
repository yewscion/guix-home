;;; jory.scm
;;;
;;; This is the system-config file for Jory, my Purism Librem 14 Laptop
;;;
;;; Author: Christopher Rodriguez
;;; Created: 2022-04-10
;;; Last Released: 2022-06-09
;;; Contact: yewscion@gmail.com
;;;

(use-modules (gnu)
             (srfi srfi-1)
             (ice-9 textual-ports)
             (guix modules))

(use-service-modules admin avahi base databases desktop docker games mail mcron
                     networking ssh virtualization web xorg )

(use-package-modules admin certs databases emacs games package-management ssh
                     tls version-control xdisorg )

(define %ming-pubkey
  (plain-file "ming_id.pub"
              (string-append "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDvbir"
                             "/LAxFP2O7WPCxX2BL5YIbb4yTPbnmJlooQaM7H5L0Dx"
                             "WAC0/3Q+XXqb6xDGrHmoJHTp3YHD30W1JNWQiKtKuEK"
                             "gYzYypiTWHU2MbZ4ahuQN7v2Bc1KM720MFaHKjDd8ru"
                             "rTya3cOd6PTXOKyhZIMjt1H6OgwYULX92oaYGVdEn+e"
                             "bSlR3xaSMyPXSJ5yPAWcZlHYrQysz7b2KtulTRvsaE0"
                             "gq3muCxFdIXqAlbAcCPScLoDWygEDMLSKN/gjV+4b45"
                             "3oiG21KnmKMhkbczu9YpbUdB46lLH6eb6twe+CNcaDZ"
                             "l/TNIA55l7UtaM9GMxesCQXIsTg0sFV9PZW2zpI4i8/"
                             "6vpAqr++t/1TQVOZjvxxv+5UWMbKVPJqawIXonOaN1I"
                             "z9svDuacMij2cBnyNxcBq5BsOjHO6ch2IYnflapFseP"
                             "fysve5Z3UVVOJJeCanp+nSGSrwDOckreVWnU8G2D0Mu"
                             "V5HNMNaghoI72uBVi5s3GmH2utl0RSh/x81byQ8iyb6"
                             "g8m2XiwwoxDGDu6sePVJOJ9iEUYmLWX4TcA4CVLhdFq"
                             "D1R/9/VE7w+RgvFmzNrufxZEaP3dXJVdIctyeCntGl9"
                             "eZreVc65GpHesIANJj/cDmeNPk8vyfPJpwHgLAZpGY4"
                             "NgbR8hXFnyrZRd+XcTvpkZcJc51OKo7kOQ== ")))

(define updatedb-job
  ;; Run 'updatedb' at 3AM every day.  Here we write the
  ;; job's action as a Scheme procedure.
  #~(job '(next-hour '(3))
         (lambda ()
           (execl (string-append #$findutils "/bin/updatedb")
                  "updatedb"
                  "--prunepaths=/tmp /var/tmp /gnu/store"))))

 (define %my-keyboard-layout
  (keyboard-layout "us,apl" #:options
                   '("ctrl:swapcaps_hyper" "compose:rctrl"
                     "grp:toggle")))

(define %my-desktop-services
  (modify-services %desktop-services
                 (delete elogind-service-type)))

(define %my-service-addons
  (append
   (list
    (service gnome-desktop-service-type)
    (service openssh-service-type
             (openssh-configuration
              (password-authentication? #f)
              (authorized-keys
               `(("ming" ,%ming-pubkey)
                 ("git" ,%ming-pubkey)))))
    (service postgresql-service-type
             (postgresql-configuration
              (postgresql postgresql-10)))
    (service gmnisrv-service-type)
    (service wesnothd-service-type)
    (service docker-service-type)
    (service qemu-binfmt-service-type
             (qemu-binfmt-configuration
              (platforms (lookup-qemu-platforms "arm"
                                                "aarch64"
                                                "risc-v"))))
    (simple-service 'my-cron-jobs
                    mcron-service-type
                    (list updatedb-job))
    (set-xorg-configuration
     (xorg-configuration
      (keyboard-layout %my-keyboard-layout)))
    (elogind-service
     #:config (elogind-configuration
               (handle-power-key 'ignore))))
   %my-desktop-services))

(define %my-services
  (modify-services
   %my-service-addons
   (guix-service-type
    config =>
    (guix-configuration
     (inherit config)
     (authorized-keys
      (append (list (local-file "/etc/cdr255/frostpine.pub"))
              %default-authorized-guix-keys))))))
(define %my-packages
  (list "nss-certs"
        "xorg-server-xwayland"
        "emacs"
        "openssh"
        "rxvt-unicode"
        "git"
        "openjdk"
        "stumpwm"
        "ncurses"
        "guile"))
(operating-system
 (locale "en_US.utf8")
 (timezone "America/New_York")
 (keyboard-layout %my-keyboard-layout)
 (host-name "jory")
 (users (cons* (user-account
                (name "ming")
                (comment "Christopher Rodriguez")
                (group "users")
                (home-directory "/home/ming")
                (supplementary-groups
                 '("wheel" "netdev" "audio" "video" "docker")))
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
 (packages
  (append
   (map (compose list specification->package+output)
        %my-packages)
   %base-packages))
 (services
  %my-services)
 (bootloader
  (bootloader-configuration
   (bootloader grub-bootloader)
   (targets (list "/dev/nvme0n1"))
   (keyboard-layout keyboard-layout)))
 (swap-devices
  (list (swap-space
         (target
          (uuid "0fd9015c-34ca-4d05-843b-584fa94796d3")))))
 (file-systems
  (cons* (file-system
          (mount-point "/")
          (device
           (uuid "ada80f5c-de9b-4a3b-b25d-cd4518d2a8f7"
                 'ext4))
          (type "ext4"))
         (file-system
          (mount-point "/home")
          (device
           (uuid "0ee6f458-e0d7-4bc3-b449-b368901c70fd"
                 'ext4))
          (type "ext4"))
         %base-file-systems)))
