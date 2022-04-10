(use-modules (gnu)
             (guix modules))
(use-service-modules networking
                     ssh
		     web
		     admin
		     games
		     certbot
                     virtualization
		     desktop)
(use-package-modules admin
                     certs
                     package-management
                     ssh
                     tls
                     emacs
		     xdisorg
		     games
                     version-control)
(define %nginx-deploy-hook
  (program-file
   "nginx-deploy-hook"
   #~(let ((pid (call-with-input-file "/var/run/nginx/pid" read)))
       (kill pid SIGHUP))))

(operating-system
  (host-name "gorse")
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
  (swap-devices (list "/dev/sdb"))

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
  (packages (cons* nss-certs            ;for HTTPS access
                   openssh-sans-x
                   emacs-next
		   rxvt-unicode
                   git
                   %base-packages))

  (services (cons*
	     (service unattended-upgrade-service-type)
             (service dhcp-client-service-type)
             (service openssh-service-type
                      (openssh-configuration
                       (openssh openssh-sans-x)
               (password-authentication? #f)
                       (authorized-keys
                        `(("ming" ,(local-file "ming_rsa.pub"))
                          ("git" ,(local-file "ming_rsa.pub"))))))
	     (service nginx-service-type
		      (nginx-configuration
		       (server-blocks
			(list (nginx-server-configuration
			       (server-name '("cdr255.com"))
			       (root "/srv/http/www/")
			       (ssl-certificate-key "/etc/letsencrypt/live/cdr255.com/privkey.pem")
			       (ssl-certificate "/etc/letsencrypt/live/cdr255.com/cert.pem"))))))
	     (service gmnisrv-service-type)
	     (service wesnothd-service-type)
	     (service certbot-service-type
		      (certbot-configuration
		       (email "cdr255@gmail.com")
		       (webroot "/srv/http/www/")
		       (default-location #f)
		       (certificates
			(list
			 (certificate-configuration
			  (domains '("cdr255.com" "www.cdr255.com"))
			  (deploy-hook %nginx-deploy-hook))))))
             (service qemu-binfmt-service-type
                      (qemu-binfmt-configuration
                       (platforms (lookup-qemu-platforms "arm" "aarch64" "risc-v"))))
	     (elogind-service)
             %base-services)))



