;;; mu-highlight.el --- Part of my Emacs setup -*- lexical-binding: t; -*-

;; Copyright (C) 2014-2018  Manuel Uberti

;; Author: Manuel Uberti manuel.uberti@inventati.org
;; Keywords: convenience

;;; Commentary:

;; This file stores my configuration for highlighting utilities.

;;; Code:

(use-package paren                      ; Highlight paired delimiters
  :init (show-paren-mode))

(use-package diff-hl                    ; Show changes in fringe
  :ensure t
  :hook ((prog-mode          . diff-hl-mode)
         (dired-mode         . diff-hl-dired-mode)
         (magit-post-refresh . diff-hl-magit-post-refresh)))

(use-package symbol-overlay             ; Highlight symbols
  :ensure t
  :bind (:map symbol-overlay-mode-map
              ("M-h" . symbol-overlay-put)
              ("M-n" . symbol-overlay-jump-next)
              ("M-p" . symbol-overlay-jump-prev))
  :hook ((prog-mode . symbol-overlay-mode)
         (html-mode . symbol-overlay-mode)
         (css-mode  . symbol-overlay-mode)
         (yaml-mode . symbol-overlay-mode)
         (conf-mode . symbol-overlay-mode)))

(use-package hl-todo                    ; Highlight TODO and similar keywords
  :ensure t
  :hook (prog-mode . hl-todo-mode))

(use-package highlight-numbers          ; Fontify number literals
  :ensure t
  :hook (prog-mode . highlight-numbers-mode))

(use-package rainbow-mode               ; Highlight colors
  :ensure t
  :bind ("C-c t R" . rainbow-mode)
  :hook (css-mode . rainbow-mode))

(use-package rainbow-delimiters         ; Highlight parens
  :ensure t
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package hi-lock                    ; Custom regexp highlights
  :init (global-hi-lock-mode))

(provide 'mu-highlight)

;; Local Variables:
;; coding: utf-8
;; indent-tabs-mode: nil
;; End:

;;; mu-highlight.el ends here
