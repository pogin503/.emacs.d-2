;;; mu-buffers.el --- Part of my Emacs configuration  -*- lexical-binding: t; -*-

;; Copyright (C) 2016  Manuel Uberti

;; Author: Manuel Uberti manuel.uberti@inventati.org
;; Keywords: convenience

;;; Commentary:

;; This file stores my configuration for buffers.

;;; Code:

;; Don't let the cursor go into minibuffer prompt
(let ((default (eval (car (get 'minibuffer-prompt-properties 'standard-value))))
      (dont-touch-prompt-prop '(cursor-intangible t)))
  (setq minibuffer-prompt-properties
        (append default dont-touch-prompt-prop))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode))

;; Allow to read from minibuffer while in minibuffer.
(validate-setq enable-recursive-minibuffers t)

;; Show the minibuffer depth (when larger than 1)
(minibuffer-depth-indicate-mode 1)

(validate-setq use-dialog-box nil       ; Never use dialogs for minibuffer input
               history-length 1000      ; Store more history
               )

(use-package savehist                   ; Save minibuffer history
  :init (savehist-mode t)
  :config
  (validate-setq savehist-save-minibuffer-history t
                 savehist-autosave-interval 180))

;; Don't ask for confirmation
(validate-setq kill-buffer-query-functions
               (delq 'process-kill-buffer-query-function
                     kill-buffer-query-functions))

(validate-setq frame-resize-pixelwise t ; Resize by pixels
               frame-title-format
               '(:eval (if (buffer-file-name)
                           (abbreviate-file-name (buffer-file-name)) "%b")))

(defun mu-display-buffer-fullframe (buffer alist)
  "Display BUFFER in fullscreen.

ALIST is a `display-buffer' ALIST.  Return the new window for BUFFER."
  (let ((window (display-buffer-pop-up-window buffer alist)))
    (when window
      (delete-other-windows window))
    window))

;; Configure `display-buffer' behaviour for some special buffers
(validate-setq
 display-buffer-alist
 `(
   ;; Messages, errors, Calendar and REPLs in the bottom side window
   (,(rx bos (or "*Help"             ; Help buffers
                 "*Warnings*"        ; Emacs warnings
                 "*Compile-Log*"     ; Emacs byte compiler log
                 "*compilation"      ; Compilation buffers
                 "*Flycheck errors*" ; Flycheck error list
                 "*shell"            ; Shell window
                 "*Calendar"         ; Calendar window
                 "*cider-repl"       ; CIDER REPL
                 "*sly-mrepl"        ; Sly REPL
                 "*scheme"           ; Inferior Scheme REPL
                 "*ielm"             ; IELM REPL
                 "*sbt"              ; SBT REPL and compilation buffer
                 "*Scala"            ; Scala REPL
                 "*ensime-update*"   ; Server update from Ensime
                 "*SQL"              ; SQL REPL
                 "*Cargo"            ; Cargo process buffers
                 ;; AUCTeX command output
                 (and (1+ nonl) " output*")
                 ))
    (display-buffer-reuse-window display-buffer-in-side-window)
    (side . bottom)
    (reusable-frames . visible)
    (window-height . 0.4))
   ("\\.pdf$*"
    (display-buffer-reuse-window display-buffer-in-side-window)
    (side . right)
    (reusable-frames . visible)
    (window-width . 0.5))
   ;; Let `display-buffer' reuse visible frames for all buffers.  This must
   ;; be the last entry in `display-buffer-alist', because it overrides any
   ;; later entry with more specific actions.
   ("." nil (reusable-frames . visible))))

(use-package uniquify                   ; Unique buffer names
  :config
  (validate-setq uniquify-buffer-name-style 'post-forward
                 uniquify-separator ":"
                 ;; Ignore special buffers
                 uniquify-ignore-buffers-re "^\\*"))

(use-package ibuffer                    ; Buffer management
  :bind (([remap list-buffers] . ibuffer)
         ("C-c b i"            . ibuffer)
         :map ibuffer-mode-map
         ("." . mu-ibuffer/body))
  :config
  (validate-setq ibuffer-formats
                 '((mark modified read-only " "
                         (name 18 18 :left :elide)
                         " "
                         (size 9 -1 :right)
                         " "
                         (mode 16 16 :left :elide)
                         " "
                         filename-and-process)
                   (mark modified read-only " "
                         (name 18 18 :left :elide)
                         " "
                         (size 9 -1 :right)
                         " "
                         (mode 16 16 :left :elide)
                         " " filename-and-process)
                   (mark " "
                         (name 16 -1)
                         " " filename)))

  (defhydra mu-ibuffer (:hint nil)
    "
 ^Navigation^ | ^Mark^        | ^Actions^        | ^View^
-^----------^-+-^----^--------+-^-------^--------+-^----^-------
  _k_:    ʌ   | _m_: mark     | _D_: delete      | _g_: refresh
 _RET_: visit | _u_: unmark   | _S_: save        | _s_: sort
  _j_:    v   | _*_: specific | _a_: all actions | _/_: filter
-^----------^-+-^----^--------+-^-------^--------+-^----^-------
"
    ("j" ibuffer-forward-line)
    ("RET" ibuffer-visit-buffer :color blue)
    ("k" ibuffer-backward-line)

    ("m" ibuffer-mark-forward)
    ("u" ibuffer-unmark-forward)
    ("*" hydra-ibuffer-mark/body :color blue)

    ("D" ibuffer-do-delete)
    ("S" ibuffer-do-save)
    ("a" hydra-ibuffer-action/body :color blue)

    ("g" ibuffer-update)
    ("s" hydra-ibuffer-sort/body :color blue)
    ("/" hydra-ibuffer-filter/body :color blue)

    ("o" ibuffer-visit-buffer-other-window "other window" :color blue)
    ("q" ibuffer-quit "quit ibuffer" :color blue)
    ("." nil "toggle hydra" :color blue))

  (defhydra hydra-ibuffer-mark (:color teal :columns 5
                                       :after-exit (hydra-ibuffer-main/body))
    "Mark"
    ("*" ibuffer-unmark-all "unmark all")
    ("M" ibuffer-mark-by-mode "mode")
    ("m" ibuffer-mark-modified-buffers "modified")
    ("u" ibuffer-mark-unsaved-buffers "unsaved")
    ("s" ibuffer-mark-special-buffers "special")
    ("r" ibuffer-mark-read-only-buffers "read-only")
    ("/" ibuffer-mark-dired-buffers "dired")
    ("e" ibuffer-mark-dissociated-buffers "dissociated")
    ("h" ibuffer-mark-help-buffers "help")
    ("z" ibuffer-mark-compressed-file-buffers "compressed")
    ("b" hydra-ibuffer-main/body "back" :color blue))

  (defhydra hydra-ibuffer-action (:color teal :columns 4
                                         :after-exit
                                         (if (eq major-mode 'ibuffer-mode)
                                             (hydra-ibuffer-main/body)))
    "Action"
    ("A" ibuffer-do-view "view")
    ("E" ibuffer-do-eval "eval")
    ("F" ibuffer-do-shell-command-file "shell-command-file")
    ("I" ibuffer-do-query-replace-regexp "query-replace-regexp")
    ("H" ibuffer-do-view-other-frame "view-other-frame")
    ("N" ibuffer-do-shell-command-pipe-replace "shell-cmd-pipe-replace")
    ("M" ibuffer-do-toggle-modified "toggle-modified")
    ("O" ibuffer-do-occur "occur")
    ("P" ibuffer-do-print "print")
    ("Q" ibuffer-do-query-replace "query-replace")
    ("R" ibuffer-do-rename-uniquely "rename-uniquely")
    ("T" ibuffer-do-toggle-read-only "toggle-read-only")
    ("U" ibuffer-do-replace-regexp "replace-regexp")
    ("V" ibuffer-do-revert "revert")
    ("W" ibuffer-do-view-and-eval "view-and-eval")
    ("X" ibuffer-do-shell-command-pipe "shell-command-pipe")
    ("b" nil "back"))

  (defhydra hydra-ibuffer-sort (:color amaranth :columns 3)
    "Sort"
    ("i" ibuffer-invert-sorting "invert")
    ("a" ibuffer-do-sort-by-alphabetic "alphabetic")
    ("v" ibuffer-do-sort-by-recency "recently used")
    ("s" ibuffer-do-sort-by-size "size")
    ("f" ibuffer-do-sort-by-filename/process "filename")
    ("m" ibuffer-do-sort-by-major-mode "mode")
    ("b" hydra-ibuffer-main/body "back" :color blue))

  (defhydra hydra-ibuffer-filter (:color amaranth :columns 4)
    "Filter"
    ("m" ibuffer-filter-by-used-mode "mode")
    ("M" ibuffer-filter-by-derived-mode "derived mode")
    ("n" ibuffer-filter-by-name "name")
    ("c" ibuffer-filter-by-content "content")
    ("e" ibuffer-filter-by-predicate "predicate")
    ("f" ibuffer-filter-by-filename "filename")
    (">" ibuffer-filter-by-size-gt "size")
    ("<" ibuffer-filter-by-size-lt "size")
    ("/" ibuffer-filter-disable "disable")
    ("b" hydra-ibuffer-main/body "back" :color blue)))

(use-package ibuf-ext
  :ensure ibuffer
  ;; Hide empty groups
  :config (validate-setq ibuffer-show-empty-filter-groups nil))

(use-package ibuffer-vc                 ; Group buffers by VC project and status
  :ensure t
  :defer t
  :init (add-hook 'ibuffer-hook
                  (lambda ()
                    (ibuffer-vc-set-filter-groups-by-vc-root)
                    (unless (eq ibuffer-sorting-mode 'alphabetic)
                      (ibuffer-do-sort-by-alphabetic)))))

(use-package scratch                    ; Mode-specific scratch buffers
  :ensure t
  :bind ("C-c b s" . scratch))

;; Use `emacs-lisp-mode' instead of `lisp-interaction-mode' for scratch buffer
(validate-setq initial-major-mode 'emacs-lisp-mode)

;;; Utilities and keybindings
;;;###autoload
(defun mu-kill-buffers (regexp)
  "Kill buffers matching REGEXP without asking for confirmation."
  (interactive "sKill buffers matching this regular expression: ")
  (cl-letf (((symbol-function 'kill-buffer-ask)
             (lambda (buffer) (kill-buffer buffer))))
    (kill-matching-buffers regexp)))

;; Don't kill the important buffers
(defconst mu-do-not-kill-buffer-names '("*scratch*" "*Messages*")
  "Names of buffers that should not be killed.")

;;;###autoload
(defun mu-do-not-kill-important-buffers ()
  "Inhibit killing of important buffers.

Add this to `kill-buffer-query-functions'."
  (if (not (member (buffer-name) mu-do-not-kill-buffer-names))
      t
    (message "Not allowed to kill %s, burying instead" (buffer-name))
    (bury-buffer)
    nil))

;; Don't kill important buffers
(add-hook 'kill-buffer-query-functions
          #'mu-do-not-kill-important-buffers)

(bind-key "C-x C-k" #'kill-this-buffer)  ; Kill only the current buffer

;;;###autoload
(defun mu-reopen-last-killed-buffer ()
  "Quickly reopen last killed buffer."
  (interactive)
  (find-file (car recentf-list)))

(bind-key "C-c f o" #'mu-reopen-last-killed-buffer)

(provide 'mu-buffers)

;; Local Variables:
;; coding: utf-8
;; indent-tabs-mode: nil
;; End:

;;; mu-buffers.el ends here
