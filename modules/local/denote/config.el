;;; local/denote/config.el -*- lexical-binding: t; -*-

;; This is another one of my packages and is extended by several other
;; packages further below.

;; Denote is a simple note-taking tool for Emacs. It is based on the idea
;; that notes should follow a predictable and descriptive file-naming
;; scheme. The file name must offer a clear indication of what the note is
;; about, without reference to any other metadata. Denote basically
;; streamlines the creation of such files while providing facilities to
;; link between them.

;; Denote's file-naming scheme is not limited to "notes". It can be used
;; for all types of file, including those that are not editable in Emacs,
;; such as videos. Naming files in a consistent way makes their
;; filtering and retrieval considerably easier. Denote provides relevant
;; facilities to rename files, regardless of file type.

;; + Package name (GNU ELPA): ~denote~
;; + Official manual: <https://protesilaos.com/emacs/denote>
;; + Change log: <https://protesilaos.com/emacs/denote-changelog>
;; + Git repositories:
;;   - GitHub: <https://github.com/protesilaos/denote>
;;   - GitLab: <https://gitlab.com/protesilaos/denote>
;; + Video demo: <https://protesilaos.com/codelog/2022-06-18-denote-demo/>
;; + Backronyms: Denote Everything Neatly; Omit The Excesses.  Don't Ever
;;   Note Only The Epiphenomenal.



;;; Denote (simple note-taking and file-naming)

;; Read the manual: <https://protesilaos.com/emacs/denote>.  This does
;; not include all the useful features of Denote.  I have a separate
;; private setup for those, as I need to test everything is in order.
(use-package! denote
  :hook
  ;; If you use Markdown or plain text files you want to fontify links
  ;; upon visiting the file (Org renders links as buttons right away).
  ((text-mode . denote-fontify-links-mode-maybe)
   ;; Highlight Denote file names in Dired buffers.  Below is the
   ;; generic approach, which is great if you rename files Denote-style
   ;; in lots of places as I do.
   ;;
   ;; If you only want the `denote-dired-mode' in select directories,
   ;; then modify the variable `denote-dired-directories' and use the
   ;; following instead:
   ;;
   ;;  (dired-mode . denote-dired-mode-in-directories)
   (dired-mode . denote-dired-mode))
  :bind
  ;; Denote DOES NOT define any key bindings.  This is for the user to
  ;; decide.  Here I only have a subset of what Denote offers.
  ( :map global-map
         ("C-c n n" . denote)
         ("C-c n N" . denote-type)
         ("C-c n d" . denote-sort-dired)
         ;; Note that `denote-rename-file' can work from any context, not
         ;; just Dired buffers.  That is why we bind it here to the
         ;; `global-map'.
         ;;
         ;; Also see `denote-rename-file-using-front-matter' further below.
         ("C-c n r" . denote-rename-file)
         ;; If you intend to use Denote with a variety of file types, it is
         ;; easier to bind the link-related commands to the `global-map', as
         ;; shown here.  Otherwise follow the same pattern for
         ;; `org-mode-map', `markdown-mode-map', and/or `text-mode-map'.
         :map text-mode-map
         ("C-c n i" . denote-link) ; "insert" mnemonic
         ("C-c n I" . denote-add-links)
         ("C-c n b" . denote-backlinks)
         ;; Also see `denote-rename-file' further above.
         ("C-c n R" . denote-rename-file-using-front-matter)
         ;; Key bindings specifically for Dired.
         :map dired-mode-map
         ("C-c C-d C-i" . denote-dired-link-marked-notes)
         ("C-c C-d C-r" . denote-dired-rename-marked-files)
         ("C-c C-d C-k" . denote-dired-rename-marked-files-with-keywords)
         ("C-c C-d C-f" . denote-dired-rename-marked-files-using-front-matter))
  :config
  ;; Remember to check the doc strings of those variables.
  (setq denote-directory (expand-file-name "~/org/notes/"))
  (setq denote-file-type nil) ; Org is the default file type

  ;; If you want to have a "controlled vocabulary" of keywords,
  ;; meaning that you only use a predefined set of them, then you want
  ;; `denote-infer-keywords' to be nil and `denote-known-keywords' to
  ;; have the keywords you need.
  (setq denote-known-keywords '("emacs" "philosophy" "politics" "psychology"))
  (setq denote-infer-keywords t)
  (setq denote-sort-keywords t)
  (setq denote-excluded-directories-regexp nil)
  (setq denote-date-format nil) ; read its doc string
  (setq denote-rename-confirmations nil) ; CAREFUL with this if you are not familiar with Denote!
  (setq denote-backlinks-show-context nil)
  (setq denote-rename-buffer-format "[D] %D%b")
  (setq denote-buffer-has-backlinks-string " (<--->)")

  ;; Automatically rename Denote buffers when opening them so that
  ;; instead of their long file name they have a literal "[D]"
  ;; followed by the file's title.  Read the doc string of
  ;; `denote-rename-buffer-format' for how to modify this.
  (denote-rename-buffer-mode 1))

;; This is another package of mine which extends my ~denote~ package.

;; This is glue code to integrate ~denote~ with Daniel Mendler's
;; ~consult~. The idea is to enhance minibuffer interactions, such as by
;; providing a preview of the file-to-linked/opened and by adding more sources to the
;; ~consult-buffer~ command.

;; + Package name (GNU ELPA): ~consult-denote~
;; + Official manual: <https://protesilaos.com/emacs/consult-denote>
;; + Change log: <https://protesilaos.com/emacs/consult-denote-changelog>
;; + Git repository: <https://github.com/protesilaos/consult-denote>
;; + Backronym: Consult-Orchestrated Navigation and Selection of
;; Unambiguous Targets...denote.

(use-package! consult-denote
  :bind
  (("C-c n f" . consult-denote-find)
   ("C-c n g" . consult-denote-grep))
  :config
  (consult-denote-mode 1))

;; This is another one of my packages. With ~denote-org~, users have
;; Org-specific extensions such as dynamic blocks, links to headings, and
;; splitting an Org subtree into its own standalone file. This package's
;; official manual covers the technicalities.

;; + Package name (GNU ELPA): ~denote-org~
;; + Official manual: <https://protesilaos.com/emacs/denote-org>
;; + Git repository: <https://github.com/protesilaos/denote-org>
;; + Backronym: Denote... Ordinarily Restricts Gyrations.

;; Watch:

;; - [[https://protesilaos.com/codelog/2023-11-25-emacs-denote-org-dynamic-blocks/][Denote Org dynamic blocks]] (2023-11-25)
;; - [[https://protesilaos.com/codelog/2023-12-04-emacs-denote-sort-mechanism/][The new Denote sort mechanism (Dired, Org dynamic blocks)]] (2023-12-04)
;; - [[https://protesilaos.com/codelog/2024-07-30-emacs-denote-exclude-dirs-org-blocks/][Exclude directories in Denote's Org dynamic blocks]] (2024-07-30)
;; - [[https://protesilaos.com/codelog/2024-01-20-emacs-denote-link-org-headings/][Denote links to Org headings]] (2024-01-20)

;;;; Denote Org extras (denote-org)

(use-package! denote-org
  :commands
  ( denote-org-link-to-heading
    denote-org-backlinks-for-heading

    denote-org-extract-org-subtree

    denote-org-convert-links-to-file-type
    denote-org-convert-links-to-denote-type

    denote-org-dblock-insert-files
    denote-org-dblock-insert-links
    denote-org-dblock-insert-backlinks
    denote-org-dblock-insert-missing-links
    denote-org-dblock-insert-files-as-headings))

;; This is another one of my packages. The ~denote-sequence~ package
;; provides an optional extension to ~denote~ for naming files with a
;; sequencing scheme. The idea is to establish hiearchical relationships
;; between files, such that the contents of one logically follow or
;; complement those of another.

;; + Package name (GNU ELPA): ~denote-sequence~
;; + Official manual: <https://protesilaos.com/emacs/denote-sequence>
;; + Git repository: <https://github.com/protesilaos/denote-sequence>
;; + Backronym: Denote... Sequences Efficiently Queue Unsorted Entries
;;   Notwithstanding Curation Efforts.

(use-package! denote-sequence
  :ensure t
  :bind
  ( :map global-map
         ;; Here we make "C-c n s" a prefix for all "[n]otes with [s]equence".
         ;; This is just for demonstration purposes: use the key bindings
         ;; that work for you.  Also check the commands:
         ;;
         ;; - `denote-sequence-new-parent'
         ;; - `denote-sequence-new-sibling'
         ;; - `denote-sequence-new-child'
         ;; - `denote-sequence-new-child-of-current'
         ;; - `denote-sequence-new-sibling-of-current'
         ("C-c n s s" . denote-sequence)
         ("C-c n s f" . denote-sequence-find)
         ("C-c n s l" . denote-sequence-link)
         ("C-c n s d" . denote-sequence-dired)
         ("C-c n s r" . denote-sequence-reparent)
         ("C-c n s c" . denote-sequence-convert))
  :config
  ;; The default sequence scheme is `numeric'.
  (setq denote-sequence-scheme 'alphanumeric))

;; This is another one of my packages. It provides some convenience
;; functions to better integrate Markdown with Deonte. This is mostly
;; about converting links from one type to another so that they can work
;; in different applications (because Markdown does not have a
;; standardised way to define custom link types).

;; + Package name (GNU ELPA): ~denote-markdown~
;; + Official manual: <https://protesilaos.com/emacs/denote-markdown>
;; + Git repository: <https://github.com/protesilaos/denote-markdown>
;; + Backronyms: Denote... Markdown's Ambitious Reimplimentations
;;   Knowingly Dilute Obvious Widespread Norms; Denote... Markup
;;   Agnosticism Requires Knowhow to Do Only What's Necessary.
;;;; Denote Markdown extras (denote-markdown)

(use-package! denote-markdown
  :ensure t
  :commands ( denote-markdown-convert-links-to-file-paths
              denote-markdown-convert-links-to-denote-type
              denote-markdown-convert-links-to-obsidian-type
              denote-markdown-convert-obsidian-links-to-denote-type ))

;; This is another one of my packages. The ~denote-journal~ package makes
;; it easier to use Denote for journaling. While it is possible to use
;; the generic ~denote~ command (and related) to maintain a journal, this
;; package defines extra functionality to streamline the journaling
;; workflow. It also integrates with the built-in ~calendar~, to (i)
;; highlight days that have a journal entry and (ii) provide commands
;; that can be used from inside the ~calendar~ buffer to either visit a
;; journal entry for the current date or create a new entry.

;; + Package name (GNU ELPA): ~denote-journal~
;; + Official manual: <https://protesilaos.com/emacs/denote-journal>
;; + Git repository: <https://github.com/protesilaos/denote-journal>
;; + Backronym: Denote... Journaling Obviously Utilises Reasonableness
;;   Notwithstanding Affectionate Longing.

;;;; Denote Journal extras (denote-journal)

(use-package! denote-journal
  :ensure t
  :commands ( denote-journal-new-entry
              denote-journal-new-or-existing-entry
              denote-journal-link-or-create-entry
              my/denote-journal-new-or-existing-entry )
  :bind ("C-c n j" . my/denote-journal-new-or-existing-entry)
  :hook (calendar-mode . denote-journal-calendar-mode)
  :config
  ;; Use the "journal" subdirectory of the `denote-directory'.  Set this
  ;; to nil to use the `denote-directory' instead.
  (setq denote-journal-directory (expand-file-name "journal" denote-directory))
  ;; Default keyword for new journal entries.  It can also be a list of strings.
  (setq denote-journal-keyword "journal")
  ;; Read the doc string of `denote-journal-title-format'.
  (setq denote-journal-title-format 'day-date-month-year)

  (defun my/denote-journal-new-or-existing-entry ()
    "EXPERIMENTAL Like `denote-journal-new-or-existing-entry' but with no front matter."
    (interactive)
    (cl-letf (((symbol-function #'denote--format-front-matter) (lambda (&rest _) ""))
              (denote-file-type 'text)
              (denote-journal-title-format ""))
      (let* ((internal-date (current-time))
             (files (denote-journal--entry-today internal-date)))
        (if files
            (find-file (denote-journal-select-file-prompt files))
          (call-interactively 'denote-journal-new-entry))))))


;; This is another package of mine. It makes it easier to work with
;; multiple "silos", as explained in the Denote manual. In short, a
;; "silo" is a localised ~denote-directory~ that is not connected to the
;; default/global ~denote-directory~ and other silos.

;; + Package name (GNU ELPA): ~denote-silo~
;; + Official manual: <https://protesilaos.com/emacs/denote-silo>
;; + Git repository: <https://github.com/protesilaos/denote-silo>
;; + Backronym: Denote... Silos Insulate Localised Objects.

;;;; Denote Silo extras (denote-silo)

(use-package! denote-silo
  :ensure t
  ;; Bind these commands to key bindings of your choice.
  :commands ( denote-silo-create-note
              denote-silo-open-or-create
              denote-silo-select-silo-then-command
              denote-silo-dired
              denote-silo-cd )
  :config
  ;; Add your silos to this list.  By default, it only includes the
  ;; value of the variable `denote-directory'.
  (setq denote-silo-directories
        (list denote-directory
              "~/library/books/"
              "~/org/denote-test-silo/")))
