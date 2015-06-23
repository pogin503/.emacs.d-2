;;; custom-vers-control.el --- Part of my Emacs setup -*- lexical-binding: t; -*-

;; Copyright (C) 2013-2015 Manuel Uberti

;; Author: Manuel Uberti <manuel@boccaperta.com>
;; Keywords:

;;; Commentary:

;; This file stores my versioning control configuration.

;;; Code:

(use-package magit
  :ensure t
  :bind ("<f3>" . magit-status)
  :init (setq magit-last-seen-setup-instructions "1.4.0")
  :config (progn
            ;; Shut up, Magit!
            (setq magit-save-some-buffers 'dontask
                  magit-stage-all-confirm nil
                  magit-unstage-all-confirm nil
                  ;; Except when you ask something useful
                  magit-set-upstream-on-push t
                  magit-auto-revert-mode-lighter "")

            (defadvice magit-status (around magit-fullscreen activate)
              "Turn fullscreen on for magit-status."
              (window-configuration-to-register :magit-fullscreen)
              ad-do-it
              (delete-other-windows))

            (defun magit-quit-session ()
              "Restore previous window configuration and cleanup buffers."
              (interactive)
              (custom/kill-buffers "^\\*magit")
              (jump-to-register :magit-fullscreen))

            (bind-key "q" #'magit-quit-session magit-status-mode-map)

            ;; Set Magit's repo dirs for `magit-status' from Projectile's known
            ;; projects. Initialize the `magit-repo-dirs' immediately after Projectile
            ;; was loaded, and update it every time we switched projects, because the
            ;; new project might have been unknown before
            (defun custom/magit-set-repo-dirs-from-projectile ()
              "Set `magit-repo-dirs' from known Projectile projects."
              (let ((project-dirs (bound-and-true-p projectile-known-projects)))
                ;; Remove trailing slashes from project directories, because Magit adds
                ;; trailing slashes again, which breaks the presentation in the Magit
                ;; prompt.
                (setq magit-repo-dirs (mapcar #'directory-file-name project-dirs))))

            (with-eval-after-load 'projectile
              (custom/magit-set-repo-dirs-from-projectile))

            (add-hook 'projectile-switch-project-hook
                      #'custom/magit-set-repo-dirs-from-projectile)

            ;; Automatically access Github PRs
            (defun custom/add-PR-fetch ()
              "If refs/pull is not defined on a GH repo, define it."
              (let ((fetch-address
                     "+refs/pull/*/head:refs/pull/origin/*")
                    (magit-remotes
                     (magit-get-all "remote" "origin" "fetch")))
                (unless (or (not magit-remotes)
                            (member fetch-address magit-remotes))
                  (when (string-match
                         "github" (magit-get "remote" "origin" "url"))
                    (magit-git-string
                     "config" "--add" "remote.origin.fetch"
                     fetch-address)))))

            (add-hook 'magit-mode-hook #'custom/add-PR-fetch))
  :diminish magit-auto-revert-mode)

(use-package git-commit-mode ; Git commit message mode
  :ensure t
  :defer t)

(use-package gitconfig-mode ; Git configuration mode
  :ensure t
  :defer t)

(use-package gitignore-mode ; .gitignore mode
  :ensure t
  :defer t)

(use-package gitattributes-mode ; Git attributes mode
  :ensure t
  :defer t)

(use-package git-rebase-mode ; Mode for git rebase -i
  :ensure t
  :defer t)

(provide 'custom-vers-control)

;;; custom-vers-control.el ends here
