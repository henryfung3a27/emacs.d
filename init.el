;; +============================+
;; |        EMACS GLOBAL        |
;; +============================+
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(custom-enabled-themes (quote (moe-dark)))
 '(custom-safe-themes
   (quote
    ("ae65ccecdcc9eb29ec29172e1bfb6cadbe68108e1c0334f3ae52414097c501d2" default)))
 '(fish-indent-offset 2)
 '(inhibit-startup-screen t)
 '(ivy-mode t)
 '(package-selected-packages
   (quote
    (use-package esup moe-theme neotree helm-swoop fish-mode helm magit multiple-cursors markdown-preview-mode markdown-mode+ flymd markdown-mode web-mode php-mode))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; ===Package configuration===
(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (when no-ssl
    (warn "\
Your version of Emacs does not support SSL connections,
which is unsafe because it allows man-in-the-middle attacks.
There are two things you can do about this warning:
1. Install an Emacs version that does support SSL and be safe.
2. Remove this warning from your init file so you won't see it again."))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives (cons "gnu" (concat proto "://elpa.gnu.org/packages/")))))

(package-initialize)

(eval-when-compile
  (require 'use-package))
;; Ensure all packages are installed globally
(require 'use-package-ensure)
(setq use-package-always-ensure t)

(add-to-list 'load-path (expand-file-name "elisp" user-emacs-directory))

;; +=================================+
;; |        EDITOR PREFERENCE        |
;; +=================================+
;; ===Scroll one line at a time (less "jumpy" than defaults)===
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1) ;; keyboard scroll one line at a time

;; ===Scroll window up/down by one line===
(global-set-key (kbd "C-<down>") (kbd "C-u 1 C-v"))
(global-set-key (kbd "C-<up>") (kbd "C-u 1 M-v"))

;; ===Set tab properties===
(setq-default tab-width 4)           ;; tab-width = 4 
(setq-default indent-tabs-mode nil)  ;; tab to space

;; ===set backup directory===
(setq backup-directory-alist
      `(("." . ,(concat user-emacs-directory "backups"))))

;; ===set home key to begginning of indentation or line===
(defun back-to-indentation-or-beginning () (interactive)
  (if (= (point) (progn (back-to-indentation) (point)))
      (beginning-of-line)))
(global-set-key (kbd "<home>") 'back-to-indentation-or-beginning)

;; ===set ring bell to flash mode line instead===
(defun my-terminal-visible-bell ()
  "A friendlier visual bell effect."
  (invert-face 'mode-line)
  (run-with-timer 0.1 nil 'invert-face 'mode-line)) 
(setq visible-bell nil
      ring-bell-function 'my-terminal-visible-bell)

;; Go to previous window (inverse of goto other window with "C-x o")
(global-set-key (kbd "C-x O") (lambda ()
                                (interactive)
                                (other-window -1)))

;; go to "arrow pointed" window by "c-x C-<arrow>"
(global-set-key (kbd "C-x <C-left>") 'windmove-left)
(global-set-key (kbd "C-x <C-right>") 'windmove-right)
(global-set-key (kbd "C-x <C-up>") 'windmove-up)
(global-set-key (kbd "C-x <C-down>") 'windmove-down)

;; Turn "auto-revert-mode" on by default for git checkout
(global-auto-revert-mode t)

;; Show line number
(global-display-line-numbers-mode t)

;; Answer y/n instead of yes/no
(defalias 'yes-or-no-p 'y-or-n-p)

;; Go down 5 lines at a time by M-<up> and M-<down>
(global-set-key (kbd "M-<up>") (kbd "C-u 5 C-p"))
(global-set-key (kbd "M-<down>") (kbd "C-u 5 C-n"))

;; Go down 5 lines with window
(global-set-key (kbd "C-M-<up>") (kbd "C-u 5 C-<up>"))
(global-set-key (kbd "C-M-<down>") (kbd "C-u 5 C-<down>"))

;; Uniquify buffer name
(setq uniquify-buffer-name-style 'forward)

;; ===show matching parenthesis===
(show-paren-mode t)
(setq show-paren-style 'expression)

;; +=======================+
;; |        PACKAGE        |
;; +=======================+
;; ===helm===
(use-package helm
  :bind (("C-x C-f" . helm-find-files)
         ("C-x b" . helm-mini)
         ("C-s" . helm-swoop)
         ("M-x" . helm-M-x))
  :config (progn
            (setq helm-buffers-fuzzy-matching t)
            (helm-mode 1)))

;; ===moe-theme===
(use-package moe-theme
  :config
  (setq moe-theme-highlight-buffer-id t)
  (moe-dark))

;; ===magit===
(use-package magit
  :bind (("C-c C-g" . magit-status)))

;; +====================+
;; |        MODE        |
;; +====================+
;; ===Load prolog mode===
(autoload 'run-prolog "prolog" "Start a Prolog sub-process." t)
(autoload 'prolog-mode "prolog" "Major mode for editing Prolog programs." t)
(autoload 'mercury-mode "prolog" "Major mode for editing Mercury programs." t)
(setq prolog-system 'swi)
(setq auto-mode-alist (append '(("\\.pl$" . prolog-mode)
                                ("\\.m$" . mercury-mode))
                               auto-mode-alist))

;; ===web-mode===
(use-package web-mode
  :mode ("\\.phtml\\'"
         "\\.tpl\\.php\\'"
         "\\.[agj]sp\\'"
         "\\.as[cp]x\\'"
         "\\.erb\\'"
         "\\.mustache\\'"
         "\\.djhtml\\'")
  :config
  (setq
   web-mode-markup-indent-offset 2
   web-mode-css-indent-offset 2
   web-mode-code-indent-offset 2
   web-mode-enable-auto-closing t
   web-mode-enable-auto-opening t
   web-mode-enable-auto-pairing t
   web-mode-enable-auto-indentation t))

;; ===ocaml tuareg & merlin===
(let ((opam-share (ignore-errors (car (process-lines "opam" "config" "var"
   "share")))))
      (when (and opam-share (file-directory-p opam-share))
       ;; Register Merlin
       (add-to-list 'load-path (expand-file-name "emacs/site-lisp" opam-share))
       (autoload 'merlin-mode "merlin" nil t nil)
       ;; Automatically start it in OCaml buffers
       (add-hook 'tuareg-mode-hook 'merlin-mode t)
       (add-hook 'caml-mode-hook 'merlin-mode t)
       ;; Use opam switch to lookup ocamlmerlin binary
       (setq merlin-command 'opam)))
;; ## added by OPAM user-setup for emacs / base ## 56ab50dc8996d2bb95e7856a6eddb17b ## you can edit, but keep this line
(use-package opam-user-setup
  :hook (tuareg-mode tuareg-opam-mode caml-mode))
;; ## end of OPAM user-setup addition for emacs / base ## keep this line

;; ===multiple cursor===
(use-package multiple-cursors
  :bind
  (("C-S-c C-S-c" . mc/edit-lines)
   ("C->" . mc/mark-next-like-this)
   ("C-<" . mc/mark-previous-like-this)
   ("M-<mouse-1>" . mc/add-cursor-on-click))
  :init
  (global-unset-key (kbd "M-<down-mouse-1>"))
  :config
   ;; <return> now insert newline instead of quit mc mode
  (define-key mc/keymap (kbd "<return>") nil))

;; ===fish-mode===
;; indentation size in CUSTOM section, at the beginning of this file (~/.emacs)

;; +=================================+
;; |        LANGUAGE SPECIFIC        |
;; +=================================+
;; +---------------+
;; |       C       |
;; +---------------+
;; ===Switch case indentation===
;;   - '+ means indent one more
;;   - '- means indent one less
;;   - 0 means no indent at all
(c-set-offset 'case-label '+)

;; ===Indentation style===
;; - gnu (default)
;; - linux
(setq c-default-style "linux"
      c-basic-offset 4)

;; +----------------------+
;; |        PYTHON        |
;; +----------------------+
;; # +---------------------------------------+
;; # | insert a python comment block (light) |
;; # +---------------------------------------+
(defun python-block-light (name)
  "Insert a light python comment block"
  (interactive "sBlock name: ")
  (let ((len (+ 2 (length name))))
    (insert "# +" (make-string len ?-) "+")
    (insert "\n")
    (insert "# | " name " |")
    (insert "\n")
    (insert "# +" (make-string len ?-) "+")))

;; ###########################################
;; #  insert a python comment block (heavy)  #
;; ###########################################
(defun python-block-heavy (name)
  "Insert a heavy python comment block"
  (interactive "sBlock name: ")
  (let ((len (+ 6 (length name))))
    (insert (make-string len ?#))
    (insert "\n")
    (insert "#  " (upcase name) "  #")
    (insert "\n")
    (insert (make-string len ?#))))
