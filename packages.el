;; -*- no-byte-compile: t; -*-

;; ui
(package! beacon) ; global minor mode for a blinking highliter to find where the cursor is.
(package! rotate :pin "091b5ac4fc...") ; window mgmt
(package! xkcd :pin "66e928706f...")
(package! wttrin :recipe (:local-repo "lisp" :no-byte-compile t))
(package! spray :pin "00638bc916...") ; flash words on screen
(package! theme-magic :pin "844c4311bd...") ; terminal theme support
(package! ess-view :pin "d4e5a340b7...") ; data frames all the way down
(package! info-colors :pin "47ee73cc19...") ; makes info pages better
(package! imenu-list)

;; sanity
(package! tldr)
                                        ; TODO: not ready yet: (package! origami) ; fold stuff away

;; org
(package! org-roam-bibtex)
(package! org-roam-server :recipe (:host github :repo "org-roam/org-roam-server" :files ("*")))
(package! org-noter)
(package! org-drill)
(package! anki-editor) ; requires https://github.com/FooSoft/anki-connect#installation - to connect w/ Anki
                                        ;(package! calctex :recipe (:host github :repo "johnbcoughlin/calctex"
                                        ;                           :files ("*.el" "calctex/*.el" "calctex-contrib/*.el" "org-calctex/*.el"))
                                        ; :pin "7fa2673c64...")
(package! org-super-agenda :pin "3264255989...")
(package! org-pomodoro) ; I forget breaks
(package! org-pretty-table-mode
  :recipe (:host github :repo "Fuco1/org-pretty-table") :pin "88380f865a...")
(package! org-fragtog :pin "92119e3ae7...")
(package! org-pretty-tags :pin "40fd72f3e7...")
(package! org-ref :pin "f582e9c53e...") ; citations
(package! org-graph-view :recipe (:host github :repo "alphapapa/org-graph-view") :pin "13314338d7...")
(package! org-chef :pin "5b461ed7d458cdcbff0af5013fbdbe88cbfb13a4") ; url -> orgified version of it
(package! company-org-roam :recipe (:host github :repo "org-roam/company-org-roam"))
(package! graphviz-dot-mode :pin "3642a0a5f41a80c8ecef7c6143d514200b80e194")
(package! ox-gfm :pin "99f93011b0...") ; markdown export with GitHub support

;; themes
(package! leuven-theme) ;; great theme for org
(package! acme-theme) ;; even greater theme
