;;; custom-style.el --- Part of my Emacs setup -*- lexical-binding: t; -*-

;; Copyright (C) 2013-2015  Manuel Uberti

;; Author: Manuel Uberti <manuel@boccaperta.com>
;; Keywords: convenience

;;; Commentary:

;; This file stores the windows customizations.

;;; Code:

(use-package ace-window ; Better movements between windows
  :ensure t
  :bind (("C-x o"   . ace-window)
         ("C-c w w" . ace-window))
  :config (setq aw-keys ; Use home row
                '(?a ?s ?d ?f ?g ?h ?j ?k ?l)
                aw-dispatch-always t))

(use-package ediff-wind ; Ediff window management
  :defer t
  :config
  ;; Prevent Ediff from spamming the frame
  (setq ediff-window-setup-function #'ediff-setup-windows-plain
        ediff-split-window-function #'split-window-horizontally))

(use-package window ; Standard window functions
  :bind (("C-c w =" . balance-windows)
         ("C-c w k" . delete-window)
         ("C-c w /" . split-window-right)
         ("C-c w -" . split-window-below)
         ("C-c w m" . delete-other-windows)))

(use-package windmove ; Move between windows with Shift+Arrow
  :bind (("C-c w <left>"  . windmove-left)
         ("C-c w <right>" . windmove-right)
         ("C-c w <up>"    . windmove-up)
         ("C-c w <down>"  . windmove-down)))

;;; Utilities and keybindings
;;;###autoload
(defun mu/quit-bottom-side-windows ()
  "Quit side windows of the current frame."
  (interactive)
  (dolist (window (window-at-side-list))
    (quit-window nil window)))

;; Taken graciously from Spacemacs
;;;###autoload
(defun mu/switch-to-minibuffer-window ()
  "Switch to current minibuffer window (if active)."
  (interactive)
  (when (active-minibuffer-window)
    (select-window (active-minibuffer-window))))

;;;###autoload
(defun mu/toggle-current-window-dedication ()
  "Toggle dedication state of a window."
  (interactive)
  (let* ((window    (selected-window))
         (dedicated (window-dedicated-p window)))
    (set-window-dedicated-p window (not dedicated))
    (message "Window %sdedicated to %s"
             (if dedicated "no longer " "")
             (buffer-name))))

(bind-key "C-c w q" #'mu/quit-bottom-side-windows)
(bind-key "C-c w d" #'mu/toggle-current-window-dedication)
(bind-key "C-c w b" #'mu/switch-to-minibuffer-window)

;; Better shrink/enlarge windows
(bind-keys*
 ("C-S-<up>"    . enlarge-window)
 ("C-S-<down>"  . shrink-window)
 ("C-S-<left>"  . shrink-window-horizontally)
 ("C-S-<right>" . enlarge-window-horizontally))

(provide 'custom-windows)

;;; custom-windows.el ends here
