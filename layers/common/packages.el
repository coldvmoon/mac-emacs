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

(setq my-warehouse-root "/Volumes/work/emacs")

;;projectile
(setq projectile-project-root my-warehouse-root)


;;agenda
(setq org-agenda-files (list (concat my-warehouse-root "/agenda/")))

