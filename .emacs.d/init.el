;; Make emacs startup faster
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

;; Initialize melpa repo
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
         '("melpa" . "https://melpa.org/packages/"))
(package-initialize)
;;

;; Initialize use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
;;

;; Initialize monokai theme
(unless (package-installed-p 'monokai-theme)
  (package-refresh-contents)
  (package-install 'monokai-theme))
;;

;; Disable automatic creation of backup files
(setq make-backup-files nil)
(setq auto-save-default nil)
;;

;; Make scrolling not so aggressive
(setq scroll-conservatively 100)
;;

;; Disable the heart-attack-inducing ringbell
(setq ring-bell-function 'ignore)
;;

;; Set the standard indent size to 4 spaces
(setq-default standard-indent 4)
; Set the default tab width to 4 spaces
(setq-default tab-width 4)
; Set C mode to use the default tab width
(setq c-basic-offset tab-width)
;;

;; Set the monokai background to a easy-on-the-eyes dark color
(setq monokai-background "#262626")
;;

;; Typing "lambda" makes the lambda letter to appear instead
(global-prettify-symbols-mode )
;;

;; This makes the line in dashboard be complete instead of finish abruptly at half (You might not need this
(set-fontset-font "fontset-default"
                  (cons page-break-lines-char page-break-lines-char)
                  (face-attribute 'default :family))
;;

;; Use-package section
; Initialize spaceline
(use-package spaceline
  :ensure t)
; Initialize powerline and utilize the spaceline theme

(use-package powerline
  :ensure t
  :init
  (spaceline-spacemacs-theme))
(add-hook 'after-init-hook 'powerline-reset)

; Initialize dashboard
(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-items '((recents . 5)))
  (setq dashboard-banner-logo-title "W I T C H M A C S")
  (setq dashboard-startup-banner "/path/to/marisa.png") ; Remember to switch this to the path to your Marisa picture
  (setq dashboard-center-content t)
  (setq dashboard-show-shortcuts nil))

; Initialize which-key
(use-package which-key
  :ensure t
  :init
  (which-key-mode))

; Initialize evil mode
(use-package evil
  :ensure t
  :init
  (evil-mode 1))

; Initialize bacon
(use-package beacon
  :ensure t
  :init
  (beacon-mode 1))

; Initialize avy 
(use-package avy
  :ensure t
  :bind
  ("M-s" . avy-goto-char))

; Initialize switch-window
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

; Initialize yasnippet and snippets for C and C++ mode
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
;
;;

;; Make brackets have matching pairs
(setq electric-pair-pairs '(
                           (?\{ . ?\})
                           (?\( . ?\))
                           (?\[ . ?\])
                           (?\" . ?\")
                          ))
(electric-pair-mode t)
 ;;

;; Ctrl + v outside Emacs lets you paste it on Emacs with p and vice versa
(setq x-select-enable-clipboard t)
;;

;; Disable the default startup screen
(setq inhibit-startup-message t)
;;

;; Enable line numbers on the left
(global-linum-mode t)
;;

;; Disable most gui elements
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
;;

;;powerline enables both of these by default, but if you don't want to use powerline you can uncomment these
;;(line-number-mode 1)
;;(column-number-mode 1)
