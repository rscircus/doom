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

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "JetBrains Mono" :size 24)
      doom-big-font (font-spec :family "JetBrains Mono" :size 36)
      doom-variable-pitch-font (font-spec :family "Overpass" :size 24)
      doom-serif-font (font-spec :family "IBM Plex Mono" :weight 'light))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-acario-light)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

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
