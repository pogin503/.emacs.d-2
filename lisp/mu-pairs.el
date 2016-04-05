;;; mu-smartparens.el --- Part of my Emacs Setup  -*- lexical-binding: t; -*-

;; Copyright (C) 2016  Manuel Uberti

;; Author: Manuel Uberti <manuel@boccaperta.com>
;; Keywords: convenience

;;; Commentary:

;; This file stores my pairs balancing configuration.

;;; Code:

(use-package smartparens                ; Parenthesis editing and balancing
  :ensure t
  :init
  (smartparens-global-mode)
  (show-smartparens-global-mode)

  (dolist (hook '(inferior-emacs-lisp-mode-hook
                  emacs-lisp-mode-hook
                  clojure-mode-hook))
    (add-hook hook #'smartparens-strict-mode))
  :config
  (setq sp-autoskip-closing-pair 'always
        ;; Don't kill entire symbol on C-k
        sp-hybrid-kill-entire-symbol nil))

(use-package smartparens-config         ; Configure Smartparens
  :ensure smartparens
  :after smartparens
  :bind (:map smartparens-mode-map
              ;; Movement and navigation
              ("C-M-f"       . sp-forward-sexp)
              ("C-M-b"       . sp-backward-sexp)
              ("C-M-u"       . sp-backward-up-sexp)
              ("C-M-d"       . sp-down-sexp)
              ("C-M-p"       . sp-backward-down-sexp)
              ("C-M-n"       . sp-up-sexp)
              ;; Deleting and killing
              ("C-M-k"       . sp-kill-sexp)
              ("C-M-w"       . sp-copy-sexp)
              ;; Depth changing
              ("M-S-<up>"    . sp-splice-sexp)
              ("M-<up>"      . sp-splice-sexp-killing-backward)
              ("M-<down>"    . sp-splice-sexp-killing-forward)
              ("M-C-<up>"    . sp-splice-sexp-killing-around)
              ("M-?"         . sp-convolute-sexp)
              ("M-r"         . sp-raise-sexp)
              ;; Barfage & Slurpage
              ("C-)"         . sp-forward-slurp-sexp)
              ("C-<right>"   . sp-forward-slurp-sexp)
              ("C-}"         . sp-forward-barf-sexp)
              ("C-<left>"    . sp-forward-barf-sexp)
              ("C-("         . sp-backward-slurp-sexp)
              ("C-M-<left>"  . sp-backward-slurp-sexp)
              ("C-{"         . sp-backward-barf-sexp)
              ("C-M-<right>" . sp-backward-barf-sexp)
              ;; Miscellaneous commands
              ("M-S"         . sp-split-sexp)
              ("M-J"         . sp-join-sexp)
              ("C-M-t"       . sp-transpose-sexp))
  :bind (:map smartparens-strict-mode-map
              ("M-q" . sp-indent-defun))
  :config
  (sp-pair "(" ")" :wrap "M-("))

(add-hook 'after-save-hook              ; Look for unbalanced parens when saving
          'check-parens nil t)

(provide 'mu-pairs)

;;; mu-pairs.el ends here
