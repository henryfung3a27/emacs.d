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
    (opam-user-setup use-package esup moe-theme neotree helm-swoop fish-mode helm magit multiple-cursors markdown-preview-mode markdown-mode+ flymd markdown-mode web-mode php-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(require 'org)
(org-babel-load-file
 (expand-file-name "my_init.org"
                   user-emacs-directory))
