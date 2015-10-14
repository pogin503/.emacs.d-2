;;; mu-utilities.el --- Part of my Emacs setup -*- lexical-binding: t; -*-

;; Copyright (C) 2013-2015  Manuel Uberti

;; Author: Manuel Uberti <manuel@boccaperta.com>
;; Keywords: convenience

;;; Commentary:

;; This file stores the configurations for random utilities.

;;; Code:

(use-package info ; Info, the documentation browser
  :bind ("C-h C-i" . info-lookup-symbol)
  :config
  ;; Fix `Info-quoted' face by going back to the default face.
  (set-face-attribute 'Info-quoted nil :family 'unspecified
                      :inherit font-lock-constant-face))

;; Let apropos commands perform more extensive searches than default
(setq apropos-do-all t)

(use-package calendar ; Display a calendar
  :bind ("C-c a c c" . calendar)
  :config (setq calendar-week-start-day 1)); Start on Monday

(use-package time ; Display time
  :bind ("C-c a c t" . display-time-world)
  :config
  (setq display-time-world-time-format "%H:%M %Z, %d. %b"
        display-time-world-list '(("Europe/Rome" "Rome")
                                  ("Europe/London" "London")
                                  ("Asia/Hong_Kong" "Hong Kong")
                                  ("Asia/Tokyo" "Tokyo"))))

(use-package calc ; Calculator
  :bind (("C-c a m q" . quick-calc)
         ("C-c a m c" . calc)))

(use-package camcorder ; Record movements from within Emacs
  :ensure t
  :no-require t
  :init (setq camcorder-window-id-offset -2))

(use-package proced ; Manage processes
  :bind ("C-c a a p" . proced)
  :config
  (progn
    ;; Auto-update proced buffer
    (defun proced-settings ()
      (proced-toggle-auto-update 1))

    (add-hook 'proced-mode-hook 'proced-settings)))

(use-package vkill ; Visually kill programs and processes
  :ensure t
  :bind (("C-c a a k" . vkill)
         ("C-c a a h" . vkill-and-helm-occur))
  :init (defun vkill-and-helm-occur ()
          (interactive)
          (vkill)
          (call-interactively #'helm-occur)))

(use-package command-log-mode ; Show event history and command history
  :ensure t
  :bind ("C-c t l" . command-log-mode))

;;; Bugs management
(use-package bug-reference ; Buttonize bug references
  :no-require t
  :init
  (progn (add-hook 'prog-mode-hook #'bug-reference-prog-mode)
         (add-hook 'text-mode-hook #'bug-reference-mode)))

(use-package bug-hunter ; Find bugs in Emacs configuration
  :ensure t
  :commands bug-hunter-file)

(use-package debbugs ; Access the GNU bug tracker
  :ensure t
  :defer t)

(provide 'mu-utilities)

;;; mu-utilities.el ends here