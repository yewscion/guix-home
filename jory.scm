;;; jory.scm
;;;
;;; This is the system-config file for Jory, my Purism Librem 14 Laptop
;;;
;;; Author: Christopher Rodriguez
;;; Created: 2022-04-10
;;; Last Released: 2023-01-22
;;; Contact: yewscion@gmail.com
;;;

(use-modules (gnu)
             (srfi srfi-1)
             (ice-9 textual-ports)
             (guix modules)
             (guix utils)
             (cdr255 kernel))

(use-service-modules admin avahi base cuirass databases desktop docker games
mail mcron networking sddm shepherd ssh virtualization web xorg)

(use-package-modules admin bash certs databases emacs fcitx5 games gtk linux
package-management ssh tls version-control xdisorg)

(load "system-packages.scm")
(load "gtk-immodule-cache-fcitx5.scm")
(define updatedb-job
  ;; Run 'updatedb' at 3AM every day.  Here we write the
  ;; job's action as a Scheme procedure.
  #~(job '(next-hour '(3))
         (lambda ()
           (execl (string-append #$findutils "/bin/updatedb")
                  "updatedb"
                  "--prunepaths=/tmp /var/tmp"))))

(define (generate-l14-stopgap-command limit constraint)
  (string-append "echo "
                 limit
                 " > "
                 "/sys/devices/virtual/powercap/"
                 "intel-rapl/intel-rapl:0/"
                 "constraint_"
                 constraint
                 "_power_limit_uw"))
(define l14-ec-stopgap-service
  ;; Per https://forums.puri.sm/t/librem-14-sudden-crash-when-unplugged/ .
  ;; Stopgap for EC firmware bug.
  (shepherd-service
   (documentation
    (string-append
     "Per "
     "https://forums.puri.sm/t/librem-14-sudden-crash-when-unplugged/"
     " : Stopgap for EC firmware bug."))
   (provision '(librem-ec-stopgap))
   (one-shot? #true)
   (start
    #~(make-system-constructor
         #$(generate-l14-stopgap-command "15000000" "1")
         " && "
         #$(generate-l14-stopgap-command "5000000" "0")))
   (stop
    #~(make-system-destructor
         "echo \""
         "Applied These Stopgaps for Librem 14 EC firmware: \n"
         #$(generate-l14-stopgap-command "15000000" "1")
         "\n"
         #$(generate-l14-stopgap-command "5000000" "0")
         "\n\""))
   (auto-start? #true)))
(define l14-ec-stopgap-service-type
  (shepherd-service-type
   'l14-ec-stopgap
   (const l14-ec-stopgap-service)
   (description "Run the Stopgaps for the Librem 14 EC.")))
(define (l14-ec-stopgap-service)
  (service l14-ec-stopgap-service-type #f))
(define %my-keyboard-layout
  (keyboard-layout "us,apl" #:options
                   '("ctrl:swapcaps_hyper" "compose:rctrl"
                     "grp:toggle")))
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
      (append
       (list (local-file "./public-keys/guix-publish-moonstream.pub"))
              %default-authorized-guix-keys))))))
(define %my-service-addons
  (append
   (list
    (service openssh-service-type
             (openssh-configuration
              (password-authentication? #f)
              (authorized-keys
               `(("ming"
                  ,(local-file "public-keys/ssh-jory.pub")
                  ,(local-file "public-keys/ssh-lark.pub")
                  ,(local-file "public-keys/ssh-crane.pub")
                  ,(local-file "public-keys/ssh-trisana.pub")
                  ,(local-file "public-keys/ssh-frostpine.pub"))
                 ("git"
                  ,(local-file "public-keys/ssh-jory.pub")
                  ,(local-file "public-keys/ssh-lark.pub")
                  ,(local-file "public-keys/ssh-crane.pub")
                  ,(local-file "public-keys/ssh-trisana.pub")
                  ,(local-file "public-keys/ssh-frostpine.pub"))))))
    (service postgresql-service-type
             (postgresql-configuration
              (postgresql postgresql-15)))
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
    (simple-service 'my-system-wide-variables
                    session-environment-service-type
                    %system-wide-environment-variables)
    (extra-special-file "/etc/clamav/clamd.conf"
                        (local-file "dotfiles/clamav-clamd.conf"))
    (extra-special-file "/etc/clamav/freshclam.conf"
                        (local-file "dotfiles/clamav-freshclam.conf"))
    (extra-special-file "/etc/clamav/clamav-milter.conf"
                        (local-file "dotfiles/clamav-clamav-milter.conf"))
    (extra-special-file "/bin/bash"
                        (file-append bash "/bin/bash"))
    (set-xorg-configuration
     (xorg-configuration
      (keyboard-layout %my-keyboard-layout)))
    (service elogind-service-type
	     (elogind-configuration
              (handle-power-key 'ignore)))
    (service libvirt-service-type
             (libvirt-configuration
              (unix-sock-group "libvirt")
              (tls-port "16555")))
    (service virtlog-service-type)
    (l14-ec-stopgap-service))
   %my-desktop-services))
(define %my-firmware
  (list "ath9k-htc-firmware"))
(define %my-kernel-modules
  (list librem-ec-acpi-linux-module))
(define %my-kernel-arguments
  (append (list "panic=30"
                "splash")
          %default-kernel-arguments))
(operating-system
 (kernel linux-libre-jory)
 (firmware %my-firmware)
 (kernel-loadable-modules %my-kernel-modules)
 (kernel-arguments %my-kernel-arguments)
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
                 '("wheel" "netdev" "audio" "video"
                   "docker" "libvirt" "kvm" "cdrom")))
               (user-account
                (name "git")
                (group "git")
                (home-directory "/home/git")
                (comment "For Use With Git")
                (system? #t))
               (user-account
                (name "clamav")
                (group "clamav")
                (home-directory "/home/clamav")
                (comment "For Use With ClamAV")
                (system? #t))
               %base-user-accounts))
 (groups (cons* (user-group
                 (name "git")
                 (system? #t))
                (user-group
                 (name "clamav")
                 (system? #t))
                %base-groups))
 (packages
  (append
   (map (compose list specification->package+output)
        my-gui-system-packages)
   %base-packages))
 (services
  %my-service-addons)
 (bootloader
  (bootloader-configuration
   (bootloader grub-bootloader)
   (targets (list "/dev/nvme0n1"))
   (keyboard-layout keyboard-layout)))
 (swap-devices
  (list (swap-space
         (target
          (uuid "ef7e4ec2-b20a-4d00-beb1-c33c1755511e")))))
 (file-systems
  (cons* (file-system
          (mount-point "/")
          (device
           (uuid "c2a95ae1-a94b-4a2e-9c62-2141b28061ba"
                 'ext4))
          (type "ext4"))
         (file-system
          (mount-point "/home")
          (device
           (uuid "8523cff9-7ef1-468a-9135-c958a326f270"
                 'ext4))
          (type "ext4"))
         %base-file-systems)))
