(list (channel
       (inherit %default-guix-channel)
       ;; (commit "775134ebf537895bcb7bf2a6c541846845403737")
       )
      (channel
        (name 'yewscion)
        (url "https://git.sr.ht/~yewscion/yewscion-guix-channel")
        (branch "trunk")
        (introduction
          (make-channel-introduction
            "2dce8bfec5f2886f7642007bbead3f2fbee26312"
            (openpgp-fingerprint
              "24C4 1BBD 8571 BD9D 1E17  FF38 5D9E 8581 A195 CF7B")))))
;)
