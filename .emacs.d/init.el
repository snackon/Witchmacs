
;;makes emacs startup faster
 
(setq gc-cons-threshold 402653184
      gc-cons-percentage 0.6)
 
(defvar startup/file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)
 
(defun startup/revert-file-name-handler-alist ()
  (setq file-name-handler-alist startup/file-name-handler-alist))
 
(defun startup/reset-gc ()
  (setq gc-cons-threshold 16777216
    gc-cons-percentage 0.1))
 
(add-hook 'emacs-startup-hook 'startup/revert-file-name-handler-alist)
(add-hook 'emacs-startup-hook 'startup/reset-gc)
 
;;

(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
         '("melpa" . "https://melpa.org/packages/"))
(package-initialize)
 
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
 
(unless (package-installed-p 'monokai-theme)
  (package-refresh-contents)
  (package-install 'monokai-theme))
 
(setq make-backup-file nil)
(setq auto-save-default nil)
(setq scroll-conservatively 100)
 
(setq ring-bell-function 'ignore)
 
(setq-default standard-indent 4)
(setq-default tab-width 4)
(setq c-basic-offset tab-width)

(setq monokai-background "#262626")

(global-prettify-symbols-mode )

(set-fontset-font "fontset-default"
                  (cons page-break-lines-char page-break-lines-char)
                  (face-attribute 'default :family))

(use-package spaceline
  :ensure t)

(use-package powerline
  :ensure t
  :init
  (spaceline-spacemacs-theme))
(add-hook 'after-init-hook 'powerline-reset)

(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-items '((recents . 5)))
  (setq dashboard-banner-logo-title "W I T C H M A C S")
  (setq dashboard-startup-banner "/path/to/marisa.png")
  (setq dashboard-center-content t)
  (setq dashboard-show-shortcuts nil))

(use-package which-key
  :ensure t
  :init
  (which-key-mode))
 
(use-package evil
  :ensure t
  :init
  (evil-mode 1))
 
(use-package beacon
  :ensure t
  :init
  (beacon-mode 1))
 
(use-package avy
  :ensure t
  :bind
  ("M-s" . avy-goto-char))
 
(use-package switch-window
  :ensure t
  :config
  (setq switch-window-input-style 'minibuffer)
  (setq switch-window-increase 4)
  (setq switch-window-threshold 2)
  (setq switch-window-shortcut-style 'qwerty)
  (setq switch-window-qwerty-shortcuts
        '("a" "s" "d" "f" "j" "k" "l"))
  :bind
  ([remap other-window] . switch-window))
 
(use-package yasnippet
  :ensure t
  :config
    (use-package yasnippet-snippets
      :ensure t)
    (yas-reload-all))
 
(use-package company
  :ensure t
  :config
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-length 3))
 
(with-eval-after-load 'company
  (define-key company-active-map (kbd "M-n") nil)
  (define-key company-active-map (kbd "M-p") nil)
  (define-key company-active-map (kbd "C-n") #'company-select-next)
  (define-key company-active-map (kbd "C-p") #'company-select-previous)
  (define-key company-active-map (kbd "SPC") #'company-abort))
 
(add-hook 'c++-mode-hook 'yas-minor-mode)
(add-hook 'c-mode-hook 'yas-minor-mode)
 
(with-eval-after-load 'company
  (add-hook 'c++-mode-hook 'company-mode)
  (add-hook 'c-mode-hook 'company-mode))
 
(use-package company-c-headers
  :ensure t)
 
(use-package company-irony
  :ensure t
  :config
  (setq company-backends '((company-c-headers
                            company-dabbrev-code
                            company-irony))))
 
(use-package irony
  :ensure t
  :config
  (add-hook 'c++-mode-hook 'irony-mode)
  (add-hook 'c-mode-hook 'irony-mode)
  (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options))
 
(setq electric-pair-pairs '(
                           (?\{ . ?\})
                           (?\( . ?\))
                           (?\[ . ?\])
                           (?\" . ?\")
                          ))
(electric-pair-mode t)
 
(setq x-select-enable-clipboard t)
 
(setq inhibit-startup-message t)
(global-linum-mode t)

(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

;;powerline enables both of these by default, but if you don't want to use powerline you can uncomment these
;;(line-number-mode 1)
;;(column-number-mode 1)
