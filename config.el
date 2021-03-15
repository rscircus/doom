;;; config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

(setq user-full-name "Roland Siegbert"
      user-mail-address "roland@siegbert.info")

(setq-default
 delete-by-moving-to-trash t
 window-combination-resize t ; take new window space from all windows
 x-stretch-cursor t ; stretch cursor to glyph width
 fill-column 80 ; keep your space
 delete-trailing-lines t ; get ride of white noise
 )

(setq undo-limit 80000000 ; 80Mb undo limit
      evil-want-fine-undo t ; evil is blobby, except when being fine and granular
      auto-save-default t
      inhibit-compacting-font-caches t ; keep glyphs in memory
      truncate-string-ellipsis "…"
      display-line-numbers-type 'relative ; switch with spc t l
      )
(display-time-mode 1) ; show time in mode-line
(delete-selection-mode 1) ; replace selection when inserting text
(global-subword-mode 1) ; iterate through CamelCase words
(show-paren-mode 1)

                                        ;(setq line-spacing 0.3) ; huge line spacing
(unless (equal "Battery status not available" (battery))
  (display-battery-mode 1))

;; disable risky local variables warning
(advice-add 'risky-local-variable-p :override #'ignore)

(setq doom-localleader-key ",")

(if (eq initial-window-system 'x)                 ; if started by emacs command or desktop file
    (toggle-frame-maximized)
  (toggle-frame-fullscreen))

(setq evil-vsplit-window-right t
      evil-split-window-below t
      )
(defadvice! prompt-for-buffer (&rest _)
  :after '(evil-window-split evil-window-vsplit)
  (+ivy/switch-buffer)
  )
(setq +ivy-buffer-preview t)

(map! :map evil-window-map
     "SPC" #'rotate-layout
     ;; Navigation
     "<left>"     #'evil-window-left
     "<down>"     #'evil-window-down
     "<up>"       #'evil-window-up
     "<right>"    #'evil-window-right
     ;; Swapping windows
     "C-<left>"       #'+evil/window-move-left
     "C-<down>"       #'+evil/window-move-down
     "C-<up>"         #'+evil/window-move-up
     "C-<right>"      #'+evil/window-move-right)

(setq frame-title-format
      '(""
        (:eval
         (if (s-contains-p org-roam-directory (or buffer-file-name ""))
             (replace-regexp-in-string ".*/[0-9]*-?" "🢔 " buffer-file-name)
           "%b"))
        (:eval
         (let ((project-name (projectile-project-name)))
           (unless (string= "-" project-name)
             (format (if (buffer-modified-p)  " ◉ %s" "  ●  %s") project-name))))))

(setq doom-modeline-height 18)
(defun doom-modeline-conditional-buffer-encoding ()
  (setq-local doom-modeline-buffer-encoding
              (unless (or (eq buffer-file-coding-system 'utf-8-unix)
                          (eq buffer-file-coding-system 'utf-8)))))
(add-hook 'after-change-major-mode-hook #'doom-modeline-conditional-buffer-encoding)
                                        ;
                                        ;                                        ; and the file name
                                        ;(defadvice! doom-modeline--reformat-roam (orig-fun)
                                        ;  :around #'doom-modeline-buffer-file-name
                                        ;  (message "Reformat?")
                                        ;  (message (buffer-file-name))
                                        ;  (if (s-contains-p org-roam-directory (or buffer-file-name ""))
                                        ;      (replace-regexp-in-string
                                        ;       "\\(?:^\\|.*/\\)\\([0-9]\\{4\\}\\)\\([0-9]\\{2\\}\\)\\([0-9]\\{2\\}\\)[0-9]*-"
                                        ;       "🢔(\\1-\\2-\\3) "
                                        ;       (funcall orig-fun))
                                        ;    (funcall orig-fun)))

(setq ranger-ovverride-dired-mode t)
                                        ;(after! dired
                                        ;  ;; Rust version ls
                                        ;  (when-let (exa (executable-find "exa"))
                                        ;    (setq insert-directory-program "/home/linuxbrew/.linuxbrew/bin/exa")
                                        ;    (setq dired-listing-switches (string-join (list "-ahl" "--group-directories-first") " ")))
                                        ;  )

(use-package! evil-snipe
  :init
  (setq evil-snipe-scope                     'whole-visible
        evil-snipe-spillover-scope           'whole-buffer
        evil-snipe-repeat-scope              'buffer
        evil-snipe-tab-increment             t
        evil-snipe-repeat-keys               t
        evil-snipe-override-evil-repeat-keys t)
  :config
  ;; when f/t/s searching, interpret open/close square brackets to be any
  ;; open/close delimiters, respectively
  (push '(?\[ "[[{(]") evil-snipe-aliases)
  (push '(?\] "[]})]") evil-snipe-aliases)
  ;; "C-;" pre-fills avy-goto-char-2 with most recent snipe
  (map! :map (evil-snipe-parent-transient-map evil-snipe-local-mode-map)
        "C-;" (cmd! (if evil-snipe--last
                        (let ((most-recent-chars (nth 1 evil-snipe--last)))
                          (if (eq 2 (length most-recent-chars))
                              (apply #'avy-goto-char-2 most-recent-chars)
                            (call-interactively #'avy-goto-char-2))))))
  ;; (setq! avy-all-windows t)
  (evil-snipe-override-mode +1))

;(setq! +doom-dashboard-menu-sections
;       '(("Reload last session"
;          :icon (all-the-icons-octicon "history" :face 'doom-dashboard-menu-title)
;          :when (cond ((require 'persp-mode nil t)
;                       (file-exists-p (expand-file-name persp-auto-save-fname persp-save-dir)))
;                      ((require 'desktop nil t)
;                       (file-exists-p (desktop-full-file-name))))
;          :face (:inherit (doom-dashboard-menu-title bold))
;          :action doom/quickload-session)
;         ("Open today's note"
;          :icon (all-the-icons-octicon "book" :face 'doom-dashboard-menu-title)
;          :action org-roam-dailies-today)
;         ("Recently opened files"
;          :icon (all-the-icons-octicon "file-text" :face 'doom-dashboard-menu-title)
;          :action recentf-open-files)
;         ("Open project"
;          :icon (all-the-icons-octicon "repo" :face 'doom-dashboard-menu-title)
;          :action projectile-switch-project)
;         ;; ("Jump to bookmark"
;         ;;  :icon (all-the-icons-octicon "bookmark" :face 'doom-dashboard-menu-title)
;         ;;  :action bookmark-jump)
;         ("Open private configuration"
;          :icon (all-the-icons-octicon "tools" :face 'doom-dashboard-menu-title)
;          :when (file-directory-p doom-private-dir)
;          :action doom/open-private-config))
;       )

(setq doom-font (font-spec :family "JetBrains Mono" :size 20)
      doom-big-font (font-spec :family "JetBrains Mono" :size 24)
      doom-variable-pitch-font (font-spec :family "Overpass" :size 20)
      doom-serif-font (font-spec :family "IBM Plex Mono" :size 24 :weight 'light)
      )

(when (eq system-type 'gnu/linux)
  (set-fontset-font t 'symbol "Noto Color Emoji" nil 'append))

(use-package! doom-themes
  :config
  (setq doom-themes-enable-bold t      ; if nil, bold is universally disabled
        doom-themes-enable-italic t)   ; if nil, italics is universally disabled

  (load-theme 'leuven t)
  ;; (load-theme 'doom-acario-light t)
  ;; (load-theme 'doom-solarized-light t)
  ;; (load-theme 'doom-one-light t)

  ;; Fontify the whole line for headings (with a background color).
  (setq org-fontify-whole-heading-line t)

  ;; (load-theme 'acme t)
  ;;(setq acme-theme-black-fg t)
  (doom-themes-org-config)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)

  ;; Corrects (and improves) org-mode's native fontification.
  )

;;(setq doom-theme 'doom-one-light)

;; Don't scale font height in org-mode
;; Leuven specific
(setq leuven-scale-outline-headlines nil)
(setq leuven-scale-org-agenda-structure nil)
(setq leuven-scale-volatile-highlight nil)

;; Generally don't scale anything
(custom-set-faces
 '(hl-line ((t (:height 1.0))))
 '(org-level-1 ((t (:inherit outline-1 :height 1.0))))
 '(org-level-2 ((t (:inherit outline-2 :height 1.0))))
 '(org-level-3 ((t (:inherit outline-3 :height 1.0))))
 '(org-level-4 ((t (:inherit outline-4 :height 1.0))))
 '(org-level-5 ((t (:inherit outline-5 :height 1.0))))
 )

(map! :n [mouse-8] #'better-jumper-jump-backward
      :n [mouse-9] #'better-jumper-jump-forward)

;; Directories
(setq
 org_notes (concat (getenv "HOME") "/src/org/")
 zot_bib (concat (getenv "HOME") "/src/zotero/zotLib.bib")
 org-directory org_notes
 deft-directory org_notes
 org-roam-directory org_notes
 org-my-anki-file (concat org_notes "anki.org")
 )

;; Defaults
(setq
 org-log-done 'time ; add datetime stamp when a task is done
 org-log-done-with-time t ; add time to datetime
 )

(use-package! org
  :defer t
  :hook (org-mode . toc-org-mode)
  :hook (org-mode . +org-pretty-mode)
  ;; :hook (org-mode . writeroom-mode)
  :hook (org-mode . auto-fill-mode)

  :config
  (add-hook! org-mode (hl-line-mode -1))
  (set-company-backend! '(org-mode org-roam-mode)
    'company-capf)

  ;; basic settings
  (setq org-src-window-setup     'plain
        org-export-with-toc      nil
        org-export-with-section-numbers nil
        org-use-sub-superscripts '{}
        org-export-with-sub-superscripts '{}
        org-export-with-entities t
        org-imenu-depth          9
        org-startup-folded       'content)  ;; showeverything ;; t ;; nil

  )

;(after! org
;  (setq org-agenda-files (directory-files-recursively org_notes "\\.org$"))
;  )

(after! org-capture
  (setq org-capture-templates
        '(("b" "Basic task for future review" entry
           (file+headline "tasks.org" "Basic tasks that need to be reviewed")
           "* %^{Title}\n:PROPERTIES:\n:CAPTURED: %U\n:END:\n\n%i%l"
           :empty-lines 1)

          ("w" "Work")
          ("wt" "Task or assignment" entry
           (file+headline "work.org" "Tasks and assignments")
           "\n\n* TODO [#A] %^{Title} :@work:\nSCHEDULED: %^t\n:PROPERTIES:\n:CAPTURED: %U\n:END:\n\n%i%?"
           :empty-lines 1)

          ("wm" "Meeting, event, appointment" entry
           (file+headline "work.org" "Meetings, events, and appointments")
           "\n\n* MEET [#A] %^{Title} :@work:\nSCHEDULED: %^T\n:PROPERTIES:\n:CAPTURED: %U\n:END:\n\n%i%?"
           :empty-lines 1)

          ("t" "Task with a due date" entry
           (file+headline "tasks.org" "Task list with a date")
           "\n\n* %^{Scope of task||TODO|STUDY|MEET} %^{Title} %^g\nSCHEDULED: %^t\n:PROPERTIES:\n:CAPTURED: %U\n:END:\n\n%i%?"
           :empty-lines 1)

          ;; anki
          ("a" "Anki basic" entry
           (file+headline org-my-anki-file "Dispatch Shelf")
           "* %<%H:%M>   %^g\n:PROPERTIES:\n:ANKI_NOTE_TYPE: Basic\n:ANKI_DECK: Mega\n:END:\n** Front\n%?\n** Back\n%x\n")

          ("A" "Anki cloze" entry
           (file+headline org-my-anki-file "Dispatch Shelf")
           "* %<%H:%M>   %^g\n:PROPERTIES:\n:ANKI_NOTE_TYPE: Cloze\n:ANKI_DECK: Mega\n:END:\n** Text\n%x\n** Extra\n")

          )
        )
  )

(evil-define-command evil-buffer-org-new (count file)
  "Creates a new org buffer replacing the current window, optionally editing a certain FILE"
  :repeat nil
  (interactive "P<f>")
  (if file
      (evil-edit file)
    (let ((buffer (generate-new-buffer "*new org*")))
      (set-window-buffer nil buffer)
      (with-current-buffer buffer
        (org-mode)))))
(map! :leader
      (:prefix "b"
       :desc "New empty ORG buffer" "o" #'evil-buffer-org-new))

;; org-journal the DOOM way
(use-package org-journal
  :after org
  :init
  (setq org-journal-file-format "%Y-%m-%d.org"
        org-journal-file-header "#+title: Week %V, %Y\n#+created: %Y-%m-%d\n#+roam_alias:\n#+roam_tags: \"journal\" \"personal\"\n\n[[file:../journal.org][Journal]]\n\n"
        org-journal-date-format "%A, %d %B %Y")
  :config
  (setq org-journal-find-file #'find-file-other-window )
  (map! :map org-journal-mode-map
        "C-c n s" #'evil-save-modified-and-close )
  )

(setq org-journal-enable-agenda-integration t)

(use-package org-noter
  :after (:any org pdf-view)
  :config
  (setq
   ;; The WM can handle splits
   ;;org-noter-notes-window-location 'other-frame
   ;; Please stop opening frames
   org-noter-always-create-frame nil
   ;; I want to see the whole file
   org-noter-hide-other nil
   ;; Everything is relative to the main notes file
   org-noter-notes-search-path (list org_notes)
   )
  )
(setq org-noter-separate-notes-from-heading t)

(use-package! org-roam
  :after org
  :commands (org-roam-buffer-toggle-display
             org-roam-find-file
             org-roam-dailies-date
             org-roam-dailies-today
             org-roam-dailies-tomorrow
             org-roam-dailies-yesterday)
  :init
  (setq! org-roam-tag-sort                t
         org-roam-tag-sources             '(prop)
         org-roam-verbose                 t
         org-roam-buffer-width            0.2
         org-roam-graph-max-title-length  40
         org-roam-graph-shorten-titles    'truncate
         org-roam-graph-exclude-matcher   '("old/" "Monday" "Tuesday" "Wednesday" "Thursday" "Friday" "Saturday" "Sunday" "journal")
         org-roam-graph-viewer            (executable-find "open"))
  (remove-hook 'org-roam-buffer-prepare-hook 'org-roam-buffer--insert-ref-links)
  (add-hook! 'org-roam-buffer-prepare-hook #'outline-hide-body)
  (setq org-roam-capture-ref-templates `(("r" "ref" plain #'org-roam-capture--get-point
                                          "%?"
                                          :file-name "${slug}"
                                          :head ,(concat "#+title: ${title}\n"
                                                         "#+roam_key: ${ref}\n"
                                                         "#+roam_tags: article\n"
                                                         "* Related: \n"
                                                         "  - [[${ref}][url]]\n")
                                          :unnarrowed t))
        org-roam-capture-templates `(("d" "default" plain #'org-roam-capture--get-point
                                      "%?"
                                      :file-name "%<%Y-%m-%d>-${slug}"
                                      :head ,(concat "#+title: ${title}\n"
                                                     "#+roam_tags:\n")
                                      :unnarrowed t)))
  (map! :map org-mode-map
        "s-TAB" (cmd! (insert "[[roam:]]")
                      (backward-char 2)))
  )

(use-package org-roam-server
  :after org-roam
  :config
  (setq org-roam-server-host "127.0.0.1"
        org-roam-server-port 10080
        org-roam-server-authenticate nil
        org-roam-server-export-inline-images t
        org-roam-server-serve-files nil
        org-roam-server-label-truncate t
        org-roam-server-label-truncate-length 60
        org-roam-server-label-wrap-length 20)
  (defun org-roam-server-open ()
    "Ensure the server is active, then open the roam graph."
    (interactive)
                                        ;(org-roam-server-mode 1)
                                        ; https://github.com/org-roam/org-roam-server/issues/75
    (unless (server-running-p)
      (org-roam-server-mode))
    (browse-url-xdg-open (format "http://localhost:%d" org-roam-server-port))))

(use-package anki-editor
  :after org
  :bind (:map org-mode-map
                                        ; these are not used by doom
         ("<f5>" . anki-editor-cloze-region-auto-incr)
         ("<f6>" . anki-editor-cloze-region-dont-incr)
         ("<f7>" . anki-editor-reset-cloze-number)
         ("<f8>" . anki-editor-push-tree))
  :hook (org-capture-after-finalize . anki-editor-reset-cloze-number) ; Reset cloze-number after each capture.
  :config
  (setq anki-editor-create-decks t ;; Allow anki-editor to create a new deck if it doesn't exist
        anki-editor-org-tags-as-anki-tags t)

  (defun anki-editor-cloze-region-auto-incr (&optional arg)
    "Cloze region without hint and increase card number."
    (interactive)
    (anki-editor-cloze-region my-anki-editor-cloze-number "")
    (setq my-anki-editor-cloze-number (1+ my-anki-editor-cloze-number))
    (forward-sexp))

  (defun anki-editor-cloze-region-dont-incr (&optional arg)
    "Cloze region without hint using the previous card number."
    (interactive)
    (anki-editor-cloze-region (1- my-anki-editor-cloze-number) "")
    (forward-sexp))

  (defun anki-editor-reset-cloze-number (&optional arg)
    "Reset cloze number to ARG or 1"
    (interactive)
    (setq my-anki-editor-cloze-number (or arg 1)))

  (defun anki-editor-push-tree ()
    "Push all notes under a tree."
    (interactive)
    (anki-editor-push-notes '(4))
    (anki-editor-reset-cloze-number))

  ;; Initialize
  (anki-editor-reset-cloze-number)
  )

(use-package deft
  :after org
                                        ;:bind
                                        ;("C-c n d" . deft)
  :init
  (setq deft-default-extension "org"
        ;; de-couples filename and note title:
        deft-use-filename-as-title nil
        deft-use-filter-string-for-filename t
        ;; disable auto-save
        deft-auto-save-interval -1.0
        ;; converts the filter string into a readable file-name using kebab-case:
        deft-file-naming-rules
        '((noslash . "-")
          (nospace . "-")
          (case-fn . downcase)))
  :custom
  (deft-recursive t)
                                        ;(deft-use-filter-string-for-filename t)
                                        ;(deft-default-extension "org")
  )

(use-package nroam
  :after org-roam
  :config
  (add-hook 'org-mode-hook #'nroam-setup-maybe))

(use-package! org-xournalpp
  :config
  (add-hook 'org-mode-hook 'org-xournalpp-mode)
  )

(after! company
  (setq completion-ignore-case t
        company-idle-delay 0.3
        company-minimum-prefix-length 2)
  (setq company-show-numbers t)
  (add-hook 'evil-normal-state-entry-hook #'company-abort)) ;; make aborting less annoying.

(setq-default history-length 1000)
(setq-default prescient-history-length 1000)

(beacon-mode 1) ; beacon blink everywhere
(map! :leader "c b" #'beacon-blink) ; find the cursor

(set-company-backend!
  '(text-mode
    markdown-mode
    gfm-mode)
  '(:seperate
    company-ispell
    company-files
    company-yasnippet))

;;(after! ispell
;;  (setq ispell-program-name (executable-find "hunspell")
;;        ispell-dictionary "en_US,de_DE")
;;
;;  (ispell-set-spellchecker-params)
;;  (ispell-hunspell-add-multi-dic "en_US,de_DE"))

(use-package! info-colors
  :commands (info-colors-fontify-node))

(add-hook 'Info-selection-hook 'info-colors-fontify-node)

(add-hook 'Info-mode-hook #'mixed-pitch-mode)

(setq which-key-idle-delay 0.3) ;; I need the help, I really do
(setq which-key-allow-multiple-replacements t)
(after! which-key
  (pushnew!
   which-key-replacement-alist
   '(("" . "\\`+?evil[-:]?\\(?:a-\\)?\\(.*\\)") . (nil . "◂\\1"))
   '(("\\`g s" . "\\`evilem--?motion-\\(.*\\)") . (nil . "◃\\1"))
   ))

(add-hook 'org-noter-insert-heading-hook #'org-id-get-create)

;; open noter session from visualized org-brain
(defun org-brain-open-org-noter (entry)
    "Open `org-noter' on the ENTRY.
If run interactively, get ENTRY from context."
    (interactive (list (org-brain-entry-at-pt)))
    (org-with-point-at (org-brain-entry-marker entry)
      (org-noter)))

(use-package! imenu-list
  :defer t
  :config
  (set-popup-rules! '(("^\\*Ilist\\*" :side right :size 40 :select t))))
