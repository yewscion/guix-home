;; This is an operating system configuration generated
;; by the graphical installer.

(use-modules (gnu)
	     (srfi srfi-1)
             (guix utils)
             (ice-9 textual-ports))

(use-service-modules admin avahi base cuirass cups databases desktop docker games
mail mcron networking sddm shepherd ssh virtualization web xorg)

(use-package-modules admin base bash certs cups databases emacs fcitx5 games gtk
package-management ssh tls version-control xdisorg)

(load "gtk-immodule-cache-fcitx5.scm")
(define %my-keyboard-layout
  (keyboard-layout "us,apl" #:options
                   '("ctrl:swapcaps_hyper" "compose:rctrl"
                     "grp:toggle")))
(define %duckdns-update
  (string-append
   "echo url=\"https://www.duckdns.org/update?domains=cdr255&"
   "token=13e5c729-35ca-4c6d-a6ab-c5019b7e4aca&ip=\" \| "
   "curl -k -o ~/duckdns/duck.log -K -"))
(define duckdns-update-job
  #~(job "5 0 * * *"            ;Vixie cron syntax
         #$%duckdns-update)) 
(define updatedb-job
  ;; Run 'updatedb' at 3AM every day.  Here we write the
  ;; job's action as a Scheme procedure.
  #~(job '(next-hour '(3))
         (lambda ()
           (execl (string-append #$findutils "/bin/updatedb")
                  "updatedb"
                  "--prunepaths=/tmp /var/tmp"))))
(define %system-wide-environment-variables
  `(("GTK_IM_MODULE" . "fcitx")
    ("QT_IM_MODULE" . "fcitx")
    ("XMODIFIERS" . "@im=fcitx")
    ("SDL_IM_MODULE" . "fcitx")
    ("GLFW_IM_MODULE" . "ibus")
    ("PYTHONPYCACHEPREFIX" . "/tmp")
    ("GUIX_GTK3_IM_MODULE_FILE" .
     ,(generate-gtk-immodule-cache
       gtk+
       "3.0.0"
       #~(begin #$fcitx5-gtk:gtk3)))
    ("GUIX_GTK2_IM_MODULE_FILE" .
     ,(generate-gtk-immodule-cache
       gtk+
       "2.0.0"
       #~(begin #$fcitx5-gtk:gtk2)))))
(load "system-packages.scm")
(define %my-desktop-services
  (modify-services
   %desktop-services
   (delete elogind-service-type)
   (guix-service-type
    config =>
    (guix-configuration
     (inherit config)
     (substitute-urls
      (append (list "http://guix.cdr.gdn")
              %default-substitute-urls))
     (authorized-keys
      (append (list (local-file "./public-keys/guix-publish-moonstream.pub"))
              %default-authorized-guix-keys))))))
(define %my-services
  (append
   (list
    (simple-service 'my-system-wide-variables
                    session-environment-service-type
                    %system-wide-environment-variables)
    (service docker-service-type)
    (service elogind-service-type)
    (service openssh-service-type
             (openssh-configuration
              (password-authentication? #f)
              (authorized-keys
               `(("ming"
                  ,(local-file "public-keys/ssh-jory.pub")
                  ,(local-file "public-keys/ssh-crane.pub")
                  ,(local-file "public-keys/ssh-lark.pub")
                  ,(local-file "public-keys/ssh-trisana.pub")
                  ,(local-file "public-keys/ssh-frostpine.pub")
                  ,(local-file "public-keys/ssh-evvy.pub"))
                 ("git"
                  ,(local-file "public-keys/ssh-jory.pub")
                  ,(local-file "public-keys/ssh-crane.pub")
                  ,(local-file "public-keys/ssh-lark.pub")
                  ,(local-file "public-keys/ssh-trisana.pub")
                  ,(local-file "public-keys/ssh-frostpine.pub")
                  ,(local-file "public-keys/ssh-evvy.pub"))))))
    (service postgresql-service-type
             (postgresql-configuration
              (postgresql postgresql-15)
              (port 5432)
              (data-directory "/var/lib/postgresql/db")
              (log-directory "/var/log/postgresql/db")))
    (service cups-service-type
         (cups-configuration
           (web-interface? #t)
           (extensions
             (list cups-filters brlaser))))
    (service qemu-binfmt-service-type
             (qemu-binfmt-configuration
              (platforms (lookup-qemu-platforms "arm"
                                                "aarch64"
                                                "risc-v"))))
    (service wesnothd-service-type)
    (extra-special-file "/usr/bin/env"
			(file-append coreutils "/bin/env"))
    (extra-special-file "/bin/bash"
                        (file-append bash "/bin/bash"))

    (simple-service 'my-cron-jobs
                    mcron-service-type
                    (list duckdns-update-job
                          updatedb-job))
    (service libvirt-service-type
             (libvirt-configuration
              (unix-sock-group "libvirt")
              (tls-port "16555")))
    (extra-special-file "/bin/bash"
                        (file-append bash "/bin/bash"))
    (set-xorg-configuration
     (xorg-configuration
      (keyboard-layout %my-keyboard-layout)))
    (service virtlog-service-type))
   %my-desktop-services))
(operating-system
 (locale "en_US.utf8")
 (timezone "America/New_York")
 (keyboard-layout %my-keyboard-layout)
 (host-name "frostpine")
 (users (cons* (user-account
                (name "ming")
                (comment "Christopher Rodriguez")
                (group "users")
                (home-directory "/home/ming")
                (supplementary-groups
                 '("wheel" "netdev" "audio" "video" "docker" "cdrom")))
               %base-user-accounts))
 (packages (append (map (compose list specification->package+output)
                        my-gui-system-packages) %base-packages))
 (services %my-services)
 (bootloader
  (bootloader-configuration
   (bootloader grub-efi-bootloader)
   (targets '("/boot/efi"))
   (keyboard-layout keyboard-layout)))
 (swap-devices
  (list (swap-space
         (target
          (uuid "e8ea5677-338f-40c5-86c9-36c54293c223")))))
 (file-systems
  (cons* (file-system
          (mount-point "/boot/efi")
          (device (uuid "F393-3E81" 'fat32))
          (type "vfat"))
         (file-system
          (mount-point "/")
          (device
           (uuid "8d09815c-2531-4e52-b3b8-b2dc3c247d73"
                 'ext4))
          (type "ext4"))
         (file-system
          (mount-point "/home")
          (device
           (uuid "a86a24cc-e095-4f39-9a83-f4216f2c1b78"
                 'ext4))
          (type "ext4"))
         %base-file-systems)))
 
