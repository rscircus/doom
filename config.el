;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

(setq user-full-name "Roland Siegbert"
      user-mail-address "roland@siegbert.info")

(setq-default
window-combination-resize t ; take new window space from all windows
x-stretch-cursor t ; stretch cursor to glyph width
)

(setq undo-limit 80000000 ; 80Mb undo limit
      evil-want-fine-undo t ; evil is blobby, except when being fine and granular
      auto-save-default t
      truncate-string-ellipsis "…"
)

(display-time-mode 1) ; show time in mode-line
(unless (equal "Battery status not available" (battery))
  (display-battery-mode 1))
(global-subword-mode 1) ; iterate through CamelCase words

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

(setq doom-font (font-spec :family "JetBrains Mono" :size 20)
      doom-big-font (font-spec :family "JetBrains Mono" :size 24)
      doom-variable-pitch-font (font-spec :family "Overpass" :size 14)
      doom-serif-font (font-spec :family "IBM Plex Mono" :size 20 :weight 'light)
)

(setq display-line-numbers-type t)

;; Fontify the whole line for headings (with a background color).
(setq org-fontify-whole-heading-line t)

;; (setq doom-theme 'doom-acario-light)
;;(load-theme 'leuven t)
(load-theme 'acme t)
(setq acme-theme-black-fg t)

(map! :n [mouse-8] #'better-jumper-jump-backward
      :n [mouse-9] #'better-jumper-jump-forward)

(setq org-directory "~/src/org/")
;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.

(after! company
  (setq company-idle-delay 0.5
        company-minimum-prefix-length 2)
  (setq company-show-numbers t)
  (add-hook 'evil-normal-state-entry-hook #'company-abort)) ;; make aborting less annoying.

(setq-default history-length 1000)
(setq-default prescient-history-length 1000)

(set-company-backend!
  '(text-mode
    markdown-mode
    gfm-mode)
  '(:seperate
    company-ispell
    company-files
    company-yasnippet))

(use-package! info-colors
  :commands (info-colors-fontify-node))

(add-hook 'Info-selection-hook 'info-colors-fontify-node)

(add-hook 'Info-mode-hook #'mixed-pitch-mode)
