;;; custom-languages.el --- Part of my Emacs setup -*- lexical-binding: t; -*-

;; Copyright (C) 2013-2015  Manuel Uberti

;; Author: Manuel Uberti <manuel@boccaperta.com>
;; Keywords: convenience

;;; Commentary:

;; This file stores the configuration for languages and translations.

;;; Code:

;;; Translation
(use-package po-mode ; Manage .po files
  :load-path "various"
  :mode "\\.po\\'"
  :no-require t
  :init (setq auto-mode-alist
              (cons '("\\.po\\'\\|\\.po\\." . po-mode) auto-mode-alist))
  :config (setq po-keep-mo-file t))

;;; Spell checking and dictionaries
(use-package ispell
  :defer t
  :config (progn
            (setq ispell-program-name (executable-find "aspell")
                  ispell-dictionary "italiano"
                  ispell-choices-win-default-height 5)

            (unless ispell-program-name
              (warn "No spell checker available. Install aspell."))))

(use-package flyspell
  :defer t
  :bind (("C-c s b" . flyspell-buffer)
         ("C-c s r" . flyspell-region))
  :config (progn
            (setq flyspell-use-meta-tab nil
                  ;; Make Flyspell less chatty
                  flyspell-issue-welcome-flag nil
                  flyspell-issue-message-flag nil)

            (global-set-key (kbd "C-c I")
                            (lambda()(interactive)
                              (ispell-change-dictionary "italiano")
                              (flyspell-buffer)))

            (global-set-key (kbd "C-c E")
                            (lambda()(interactive)
                              (ispell-change-dictionary "british")
                              (flyspell-buffer)))

            ;; Free C-M-i for completion
            (define-key flyspell-mode-map "\M-\t" nil))
  :diminish flyspell-mode)

(use-package synosaurus ; An extensible thesaurus
  :ensure t
  :defer t
  :bind (("C-c s l" . synosaurus-lookup)
         ("C-c s r" . synosaurus-choose-and-replace)))

(use-package langtool ; Interact with LanguageTool
  :ensure t
  :defer t
  :config (progn
            (setq langtool-language-tool-jar ; Set language tool jar
                  "~/emacs/languagetool-2.8/languagetool-commandline.jar"
                  langtool-java-bin "/usr/bin/java"
                  langtool-mother-tongue "en")))

(use-package voca-builder ; Popup dictionary entries
  :ensure t
  :defer t
  :bind (("C-c s p" . voca-builder/search-popup)
         ("C-c s s" . voca-builder/search))
  :config (setq voca-builder/voca-file "~/org/voca_entries.org"
                ;; Don't record the vocabulary
                voca-builder/record-new-vocabulary nil))

(provide 'custom-languages)

;;; custom-languages.el ends here
