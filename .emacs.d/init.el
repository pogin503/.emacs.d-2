;;; init.el --- Emacs configuration of Manuel Uberti -*- lexical-binding: t; -*-

;; Copyright (C) 2013-2015  Manuel Uberti

;; Author: Manuel Uberti <manuel@boccaperta.com>
;; URL: https://gihub.com/boccaperta-it/emacs
;; Keywords: convenience

;; This file is not part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify it under
;; the terms of the GNU General Public License as published by the Free Software
;; Foundation; either version 3 of the License, or (at your option) any later
;; version.

;; This program is distributed in the hope that it will be useful, but WITHOUT
;; ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
;; FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
;; details.

;; You should have received a copy of the GNU General Public License along with
;; GNU Emacs; see the file COPYING. If not, write to the Free Software
;; Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301,
;; USA.

;;; Commentary:

;; This file sets up packages, custom file, username and mail address. It also
;; loads the different configuration files I have in ~/.emacs.d/lisp.

;;; Code:

;;; Package setup
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)

(setq load-prefer-newer t) ; Always load newer compiled files

;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

;;; Initialization
(when (version< emacs-version "25")
  (warn "This configuration needs Emacs trunk, but this is %s!" emacs-version))

(setq inhibit-default-init t) ; Disable the site default settings

;; Warn if the current build is more than a week old
(run-with-idle-timer
 2 nil
 (lambda ()
   (let ((time-since-build (time-subtract (current-time) emacs-build-time)))
     (when (> (time-to-number-of-days time-since-build) 7)
       (lwarn 'emacs :warning "Your Emacs build is more than a week old!")))))

;; Set separate custom file for the customize interface
(defconst custom/custom-file (locate-user-emacs-file "custom.el")
  "File used to store settings from Customization UI.")

(use-package cus-edit
  :defer t
  :config
  (setq custom-file custom/custom-file
	custom-buffer-done-kill nil ; Kill when existing
	custom-buffer-verbose-help nil ; Remove redundant help text
	;; Show me the real variable name
	custom-unlispify-tag-names nil
	custom-unlispify-menu-entries nil)
  :init (load custom/custom-file 'no-error 'no-message))

;; Set the directory where all backup and autosave files will be saved
(defvar backup-dir "~/tmp/")
(setq backup-directory-alist
      `((".*" . ,backup-dir)))
(setq auto-save-file-name-transforms
      `((".*" ,backup-dir t)))

;; Personal informations
(setq user-full-name "Manuel Uberti")
(setq user-mail-address "manuel@boccaperta.com")

;; The server of `emacsclient'
(use-package server
  :defer t
  :init (server-start))

;; Require files under ~/.emacs.d/lisp
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
(require 'custom-functions)
(require 'custom-style)
(require 'custom-ibuffer)
(require 'custom-helm)
(require 'custom-editing)
(require 'custom-search)
(require 'custom-files)
(require 'custom-completion)
(require 'custom-formatting)
(require 'custom-languages)
(require 'custom-latex)
(require 'custom-vers-control)
(require 'custom-net)
(require 'custom-org)
(require 'custom-programming)
(require 'custom-project)
(require 'custom-shells)
(require 'custom-utilities)
(require 'custom-keybindings)

;;; init.el ends here
