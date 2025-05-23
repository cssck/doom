(use-package! gcmh
  :init
  (setq gc-cons-threshold (* 256 1024 1024))
  (setq read-process-output-max (* 4 1024 1024))
  (setq comp-deferred-compilation t)
  (setq comp-async-jobs-number 8)

  ;; Garbage collector optimization
  (setq gcmh-idle-delay 5)
  (setq gcmh-high-cons-threshold (* 1024 1024 1024))  ; 256MB during idle

  ;; Version control optimization
  (setq vc-handled-backends '(Git))

  ;; Fix x11 issues
  (setq focus-follows-mouse nil)


  :config
  (gcmh-mode 1)

  (setq gc-cons-threshold 200000000)) ; previous 33554432

;; Credentials

;; autosave and backup
(setq auto-save-default t
      make-backup-files t)

;;;; Add dvorak layout
(after! quail
  (add-to-list 'quail-keyboard-layout-alist
               `("dvorak" . ,(concat "                              "
                                     "  1!2@3#4$5%6^7&8*9(0)[{]}`~  "
                                     "  '\",<.>pPyYfFgGcCrRlL/?=+    "
                                     "  aAoOeEuUiIdDhHtTnNsS-_\\|    "
                                     "  ;:qQjJkKxXbBmMwWvVzZ        "
                                     "                              "))))
(quail-set-keyboard-layout "dvorak")

;;;; Add Ukrainian language
(set-input-method "ukrainian-computer")

;;;; Stop Emacs from asking be if I want to kill the buffer
(remove-hook 'kill-buffer-query-functions 'process-kill-buffer-query-function)

;;;; Unmapping extra doom keybindings
(map! :leader
      "a" nil
      "c" nil
      "C-f" nil)

;;;; Mapping capture and agenda where they belong
(map! :desc "org-capture" "C-c c" #'org-capture
      :desc "org-agenda"  "C-c a" #'org-agenda)

(map! :desc "other-window" "M-o" #'other-window)

(setq doom-theme 'modus-operandi-tinted)

;; Prot's fonts are cool too
(setq doom-font (font-spec :family "Aporetic Sans Mono" :size 16 :weight 'regular)
      doom-variable-pitch-font (font-spec :family "Aporetic Sans" :size 16)
      doom-serif-font (font-spec :family "Aporetic Serif" :size 16))

;; Transparency
;;r(set-frame-parameter (selected-frame) 'alpha '(96 . 97))
;;(add-to-list 'default-frame-alist '(alpha . (96 . 97)))

;;;; Adds padding and makes the modeline look cool
(use-package! spacious-padding
  :config
  (spacious-padding-mode 1))

;;;; Display time and battery in mode line
(display-time-mode 1)
(display-battery-mode 1)

(setq display-line-numbers-type 'nil) ;; TODO change to 'visual in org-mode

(add-hook! display-line-numbers-mode
  (custom-set-faces!
    '(line-number :slant normal)
    '(line-number-current-line :slant normal)))

(setq global-hl-line-modes nil)

(use-package! ultra-scroll
  :init
  (setq scroll-conservatively 101 ; important!
        scroll-margin 0)
  :config
  (ultra-scroll-mode 1))

(use-package! pulsar
  :config
  (setq pulsar-pulse t
        pulsar-delay 0.055
        pulsar-iterations 5
        pulsar-face 'pulsar-green
        pulsar-region-face 'pulsar-cyan
        pulsar-highlight-face 'pulsar-magenta)
  ;; Pulse after `pulsar-pulse-region-functions'.
  (setq pulsar-pulse-region-functions pulsar-pulse-region-common-functions)
  :hook
  ;; There are convenience functions/commands which pulse the line using
  ;; a specific colour: `pulsar-pulse-line-red' is one of them.
  ((next-error . (pulsar-pulse-line-red pulsar-recenter-top pulsar-reveal-entry))
   (minibuffer-setup . pulsar-pulse-line-red)
   ;; Pulse right after the use of `pulsar-pulse-functions' and
   ;; `pulsar-pulse-region-functions'.  The default value of the
   ;; former user option is comprehensive.
   (after-init . pulsar-global-mode))
  :bind
  ;; pulsar does not define any key bindings.  This is just my personal
  ;; preference.  Remember to read the manual on the matter.  Evaluate:
  ;;
  ;; (info "(elisp) Key Binding Conventions")
  (("C-x l" . pulsar-pulse-line) ; override `count-lines-page'
   ("C-x L" . pulsar-highlight-dwim))) ; or use `pulsar-highlight-line'

;;; Custom extensions for "focus mode" (logos.el)
;; Read the manual: <https://protesilaos.com/emacs/logos>.
(use-package! olivetti
  :commands (olivetti-mode)
  :config
  (setq olivetti-body-width 0.7)
  (setq olivetti-minimum-body-width 80)
  (setq olivetti-recall-visual-line-mode-entry-state t))

(use-package! logos
  :bind
  (("C-x n n" . logos-narrow-dwim)
   ("C-x ]" . logos-forward-page-dwim)
   ("C-x [" . logos-backward-page-dwim)
   ;; I don't think I ever saw a package bind M-] or M-[...
   ("M-]" . logos-forward-page-dwim)
   ("M-[" . logos-backward-page-dwim)
   ("<f9>" . logos-focus-mode))
  :config
  (setq logos-outlines-are-pages t)
  (setq logos-outline-regexp-alist
        `((emacs-lisp-mode . ,(format "\\(^;;;+ \\|%s\\)" logos-page-delimiter))
          (org-mode . ,(format "\\(^\\*+ +\\|^-\\{5\\}$\\|%s\\)" logos-page-delimiter))
          (markdown-mode . ,(format "\\(^\\#+ +\\|^[*-]\\{5\\}$\\|^\\* \\* \\*$\\|%s\\)" logos-page-delimiter))
          (conf-toml-mode . "^\\[")))

  ;; These apply when `logos-focus-mode' is enabled.  Their value is
  ;; buffer-local.
  (setq-default logos-hide-mode-line t)
  (setq-default logos-hide-header-line t)
  (setq-default logos-hide-buffer-boundaries t)
  (setq-default logos-hide-fringe t)
  (setq-default logos-variable-pitch t) ; see my `fontaine' configurations
  (setq-default logos-buffer-read-only nil)
  (setq-default logos-scroll-lock nil)
  (setq-default logos-olivetti t)

  (add-hook 'enable-theme-functions #'logos-update-fringe-in-buffers)

;;;; Extra tweaks
  ;; place point at the top when changing pages, but not in `prog-mode'
  (defun my/logos--recenter-top ()
    "Use `recenter' to reposition the view at the top."
    (unless (derived-mode-p 'prog-mode)
      (recenter 1))) ; Use 0 for the absolute top

  (add-hook 'logos-page-motion-hook #'my/logos--recenter-top))

(add-to-list 'default-frame-alist '(width . 100))
(add-to-list 'default-frame-alist '(height . 40))

(setq frame-title-format
      '(""
        (:eval
         (if (s-contains-p org-roam-directory (or buffer-file-name ""))
             (replace-regexp-in-string
              ".*/[0-9]*-?" "☰ "
              (subst-char-in-string ?_ ?  buffer-file-name))
           "%b"))
        (:eval
         (let ((project-name (projectile-project-name)))
           (unless (string= "-" project-name)
             (format (if (buffer-modified-p)  " ◉ %s" "  ●  %s") project-name))))))

(after! dirvish
  (setq! dirvish-quick-access-entries
         `(("h" "~/"           "Home")
           ("e" ,doom-user-dir "Doom config")
           ("D" "~/Downloads/" "Downloads")
           ("g" "~/git/"       "Git")
           ("o" "~/org/"       "Org")
           ("d" "~/git/dotfiles" "Dotfiles"))))

(setq org-directory "~/org/"
      org-attach-id-dir "~/org/.attach/"
      org-attach-directory "~/org/.attach/"
      org-roam-directory "~/org/roam/"
      org-use-property-inheritance t
      org-startup-with-inline-images t
      org-hide-emphasis-markers t
      org-edit-src-content-indentation 0
      org-startup-with-latex-preview t)

(after! org
  (custom-set-faces!
    `((org-document-title)
      :foreground ,(face-attribute 'org-document-title :foreground)
      :height 1.3 :weight bold)
    `((org-level-1)
      :foreground ,(face-attribute 'outline-1 :foreground)
      :height 1.1 :weight medium)
    `((org-level-2)
      :foreground ,(face-attribute 'outline-2 :foreground)
      :weight medium)
    `((org-level-3)
      :foreground ,(face-attribute 'outline-3 :foreground)
      :weight medium)
    `((org-level-4)
      :foreground ,(face-attribute 'outline-4 :foreground)
      :weight medium)
    `((org-level-5)
      :foreground ,(face-attribute 'outline-5 :foreground)
      :weight medium)))

(after! org
  (add-to-list 'org-latex-packages-alist '("" "amsmath" t))
  (add-to-list 'org-latex-packages-alist '("" "amssymb" t))
  (add-to-list 'org-latex-packages-alist '("" "mathtools" t))
  (add-to-list 'org-latex-packages-alist '("" "mathrsfs" t)))

;; (use-package! org-preview
;;   :after org
;;   :config
;;   (plist-put org-latex-preview-appearance-options
;;              :page-width 0.8)
;;   (add-hook 'org-mode-hook 'org-latex-preview-auto-mode)
;;   (setq org-latex-preview-auto-ignored-commands
;;         '(next-line previous-line mwheel-scroll
;;           scroll-up-command scroll-down-command))
;;   (setq org-latex-preview-numbered t)
;;   (setq org-latex-preview-live t)
;;   (setq org-latex-preview-live-debounce 0.25))

(use-package! org-modern
  :after org
  :config
  (setq
   org-auto-align-tags t
   org-tags-column 0
   org-fold-catch-invisible-edits 'show-and-error
   org-special-ctrl-a/e t
   org-insert-heading-respect-content t

   ;; agenda
   org-agenda-tags-column 0
   org-agenda-block-separator ?─
   org-agenda-time-grid
   '((daily today require-timed)
     (800 1000 1200 1400 1600 1800 2000)
     " ┄┄┄┄┄ " "┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄")
   org-agenda-current-time-string
   "⭠ now ─────────────────────────────────────────────────")

  (global-org-modern-mode))

(use-package! pdf-tools
  :config
  (pdf-tools-install)
  (setq pdf-view-resize-factor 1.1)
  (setq-default pdf-view-display-size 'fit-page))

(setq doom-modeline-icon t)
(setq doom-modeline-major-mode-icon t)
(setq doom-modeline-major-mode-color-icon t)
