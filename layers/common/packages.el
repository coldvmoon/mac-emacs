;;; packages.el --- common layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2017 Sylvain Benner & Contributors
;;
;; Author: coldvmoon <coldvmoon@coldvmoons-iMac.local>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;;; Commentary:

;; See the Spacemacs documentation and FAQs for instructions on how to implement
;; a new layer:
;;
;;   SPC h SPC layers RET
;;
;;
;; Briefly, each package to be installed or configured by this layer should be
;; added to `common-packages'. Then, for each package PACKAGE:
;;
;; - If PACKAGE is not referenced by any other Spacemacs layer, define a
;;   function `common/init-PACKAGE' to load and initialize the package.

;; - Otherwise, PACKAGE is already referenced by another Spacemacs layer, so
;;   define the functions `common/pre-init-PACKAGE' and/or
;;   `common/post-init-PACKAGE' to customize the package as it is loaded.

;;; Code:
(setq base-project "/Volumes/work/emacs")
(defconst common-packages
  '(
    all-the-icons
    neotree
    )
  "The list of Lisp packages required by the common layer.

Each entry is either:

1. A symbol, which is interpreted as a package to be installed, or

2. A list of the form (PACKAGE KEYS...), where PACKAGE is the
    name of the package to be installed or loaded, and KEYS are
    any number of keyword-value-pairs.

    The following keys are accepted:

    - :excluded (t or nil): Prevent the package from being loaded
      if value is non-nil

    - :location: Specify a custom installation location.
      The following values are legal:

      - The symbol `elpa' (default) means PACKAGE will be
        installed using the Emacs package manager.

      - The symbol `local' directs Spacemacs to load the file at
        `./local/PACKAGE/PACKAGE.el'

      - A list beginning with the symbol `recipe' is a melpa
        recipe.  See: https://github.com/milkypostman/melpa#recipe-format")

;; neotree
(defun common/init-all-the-icons()
  (require 'all-the-icons)
  )

(defun common/post-init-neotree()
  (setq neo-theme (if (display-graphic-p) 'icons 'arrow))
  )

;;; keymap
(defun open-common-layer-file()
  (interactive)
  (find-file "~/.spacemacs.d/layers/common/packages.el") )
(global-set-key (kbd "<f3>") 'open-common-layer-file)
(defun open-spacemacsd-file()
  (interactive)
  (find-file "~/.spacemacs.d/init.el")
  )
(global-set-key (kbd "<f4>") 'open-spacemacsd-file)


;; agenda
(setq org-agenda-include-diary t)

;; define the refile targets
(defvar org-agenda-dir (expand-file-name "/Volumes/work/emacs/agenda" base-project) "gtd org files location")
(setq org-agenda-file-inbox (expand-file-name "inbox.org" org-agenda-dir))
(setq org-agenda-file-note (expand-file-name "notes.org" org-agenda-dir))
(setq org-agenda-file-gtd (expand-file-name "gtd.org" org-agenda-dir))
(setq org-agenda-file-habbits (expand-file-name "habits.org" org-agenda-dir))
(setq org-agenda-file-journal (expand-file-name "journal.org" org-agenda-dir))
(setq org-agenda-file-code-snippet (expand-file-name "snippet.org" org-agenda-dir))
(setq org-default-notes-file (expand-file-name "gtd.org" org-agenda-dir))
(setq org-agenda-files (list org-agenda-file-gtd org-agenda-file-habbits))

(with-eval-after-load 'org-agenda
  (define-key org-agenda-mode-map (kbd "P") 'org-pomodoro)
  (spacemacs/set-leader-keys-for-major-mode 'org-agenda-mode
    "." 'spacemacs/org-agenda-transient-state/body)
  )
;; the %i would copy the selected text into the template
;;http://www.howardism.org/Technical/Emacs/journaling-org.html
;;add multi-file journal
(setq org-capture-templates
      '(
        ("i" "Inbox" entry (file+headline org-agenda-file-gtd "In box")
         "* TODO [#B] %?\n  %i\n"
         :empty-lines 1)
        ("t" "Todo" entry (file+headline org-agenda-file-gtd "Workspace")
         "* TODO [#B] %?\n  %i\n"
         :empty-lines 1)
        ("n" "notes" entry (file+headline org-agenda-file-note "Quick notes")
         "* %?\n  %i\n %U"
         :empty-lines 1)
        ("b" "Blog Ideas" entry (file+headline org-agenda-file-note "Blog Ideas")
         "* TODO [#B] %?\n  %i\n %U"
         :empty-lines 1)
        ("s" "Code Snippet" entry
         (file org-agenda-file-code-snippet)
         "* %?\t%^g\n#+BEGIN_SRC %^{language}\n\n#+END_SRC")
        ("w" "work" entry (file+headline org-agenda-file-gtd "Cocos2D-X")
         "* TODO [#A] %?\n  %i\n %U"
         :empty-lines 1)
        ("c" "Chrome" entry (file+headline org-agenda-file-note "Quick notes")
         "* TODO [#C] %?\n %(zilongshanren/retrieve-chrome-current-tab-url)\n %i\n %U"
         :empty-lines 1)
        ("l" "links" entry (file+headline org-agenda-file-note "Quick notes")
         "* TODO [#C] %?\n  %i\n %a \n %U"
         :empty-lines 1)
        ("j" "Journal Entry"
         entry (file+datetree org-agenda-file-journal)
         "* %?"
         :empty-lines 1)))

;;An entry without a cookie is treated just like priority ' B '.
;;So when create new task, they are default 重要且紧急
(setq org-agenda-custom-commands
      '(
        ("w" . "任务安排")
        ("wa" "重要且紧急的任务" tags-todo "+PRIORITY=\"A\"")
        ("wb" "重要且不紧急的任务" tags-todo "-Weekly-Monthly-Daily+PRIORITY=\"B\"")
        ("wc" "不重要且紧急的任务" tags-todo "+PRIORITY=\"C\"")
        ("b" "Blog" tags-todo "BLOG")
        ("p" . "项目安排")
        ("pw" tags-todo "PROJECT+WORK+CATEGORY=\"cocos2d-x\"")
        ("pl" tags-todo "PROJECT+DREAM+CATEGORY=\"zilongshanren\"")
        ("W" "Weekly Review"
         ((stuck "") ;; review stuck projects as designated by org-stuck-projects
          (tags-todo "DAILY") ;; review all projects (assuming you use todo keywords to designate projects)
          (tags-todo "WEEKLY") ;; review all projects (assuming you use todo keywords to designate projects)
          ))))

(setq org-refile-targets '(("~/warehouse/gtd/gtd.org" :maxlevel . 3)
                           ("~/warehouse/gtd/someday.org" :level . 1)
                           ("~/warehouse/gtd/tickler.org" :maxlevel . 2)))
(defun org-summary-todo (n-done n-not-done)
  "Switch entry to DONE when all subentries are done, to TODO otherwise."
  (let (org-log-done org-log-states)   ; turn off logging
    (org-todo (if (= n-not-done 0) "DONE" "TODO")))
     
  )
(add-hook 'org-after-todo-statistics-hook 'org-summary-todo)
(defun skip-daily-tasks () 
  (let ((next-headline (save-excursion (or (outline-next-heading) (point-max))))
        (headline (or (and (org-at-heading-p) (point))
                      (save-excursion (org-back-to-heading)))))
    (if (string= (org-get-repeat) "+1d")
        next-headline
      nil)))


(defun my/org-checkbox-todo ()
  "Switch header TODO state to DONE when all checkboxes are ticked, to TODO otherwise"
  (let ((todo-state (org-get-todo-state)) beg end)
    (unless (not todo-state)
      (save-excursion
        (org-back-to-heading t)
        (setq beg (point))
        (end-of-line)
        (setq end (point))
        (goto-char beg)
        (if (re-search-forward "\\[\\([0-9]*%\\)\\]\\|\\[\\([0-9]*\\)/\\([0-9]*\\)\\]"
                               end t)
            (if (match-end 1)
                (if (equal (match-string 1) "100%")
                    (unless (string-equal todo-state "DONE")
                      (org-todo 'done)
                      (org-reset-checkbox-state-subtree)
                      )
                  (unless (string-equal todo-state "TODO")
                    (org-todo 'todo)))
              (if (and (> (match-end 2) (match-beginning 2))
                       (equal (match-string 2) (match-string 3)))
                  (unless (string-equal todo-state "DONE")
                    (org-todo 'done)
                    (org-reset-checkbox-state-subtree)
                    )
                (unless (string-equal todo-state "TODO")
                  (org-todo 'todo)
                  ))))))))
(add-hook 'org-checkbox-statistics-hook 'my/org-checkbox-todo)


;;org-mode config
(setq org-startup-indented t)


(require 'epa-file)
(custom-set-variables '(epg-gpg-program  "/usr/local/bin/gpg2"))
(epa-file-enable)
(setq org-crypt-key "xkwu1990")
;;(setq auto-save-default nil)
