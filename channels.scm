(list (channel
        (name 'yewscion)
        (url "https://git.sr.ht/~yewscion/yewscion-guix-channel")
        ;; (commit
        ;;   "c488b1caf99c3a7beb0be79c4fa3242e955bf910")
        (introduction
          (make-channel-introduction
            "3274a13809e8bad53e550970d684035519818ea0"
            (openpgp-fingerprint
              "6E3D E92C 3D0A 0A4D 1CDD  33EC 8EF2 971E D0D0 35B8"))))
      (channel
        (name 'guix)
        (url "https://git.savannah.gnu.org/git/guix.git")
        ;; (commit
        ;;   "653bcab96d70d25e98753681d48657fe6634f8c5")
        (introduction
          (make-channel-introduction
            "9edb3f66fd807b096b48283debdcddccfea34bad"
            (openpgp-fingerprint
              "BBB0 2DDF 2CEA F6A8 0D1D  E643 A2A0 6DF2 A33A 54FA")))))
