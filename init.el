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

;; Initialize the monokai theme and set the background to an easy-on-the-eyes dark color
; I have planned to make my own Witchmacs theme based off the monokai one but for now, I use monokai because I like it
(unless (package-installed-p 'monokai-theme)
  (package-refresh-contents)
  (package-install 'monokai-theme))
(load-theme 'monokai t)
(setq monokai-background "#262626")
;;

;; QOL section

; Show in the modeline which line and column you are in 
; powerline enables both of these by default, but if you don't want to use powerline you can uncomment these
;(line-number-mode 1)
;(column-number-mode 1)

; Enable line numbers on the left
(global-linum-mode t)

; Disable the default startup screen
(setq inhibit-startup-message t)

; Disable most gui elements
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

; Ctrl + c outside Emacs lets you paste it on Emacs with p and vice versa
(setq x-select-enable-clipboard t)

; Disable automatic creation of backup files
(setq make-backup-files nil)
(setq auto-save-default nil)

; Make scrolling not so aggressive
(setq scroll-conservatively 100)

; Disable the heart-attack-inducing ringbell
(setq ring-bell-function 'ignore)

; Set the standard indent size to 4 spaces
(setq-default standard-indent 4)

; Set the default tab width to 4 spaces
(setq-default tab-width 4)

; Set C mode to use the default tab width
(setq c-basic-offset tab-width)

; Typing "lambda" makes the lambda letter to appear instead
(global-prettify-symbols-mode )

; Make brackets have matching pairs
(setq electric-pair-pairs '(
                           (?\{ . ?\})
                           (?\( . ?\))
                           (?\[ . ?\])
                           (?\" . ?\")
                          ))
(electric-pair-mode t)

; This makes the line in dashboard be complete instead of finish abruptly at half (you might not need this)
;(set-fontset-font "fontset-default"
;                  (cons page-break-lines-char page-break-lines-char)
;                  (face-attribute 'default :family))
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
  (setq dashboard-startup-banner "~/.emacs.d/marivector.png")
  (setq dashboard-center-content t)
  (setq dashboard-show-shortcuts nil))

; Initialize which-key
; Incredibly useful package; press tab to see possible command completions
(use-package which-key
  :ensure t
  :init
  (which-key-mode))

; Initialize evil mode
; Vim keybindings in Emacs. Please note that Witchmacs has NO other evil-mode compatibility packages because I like to KISS
(use-package evil
  :ensure t
  :init
  (evil-mode 1))

; Initialize beacon
; You might find beacon an unnecesary package but I find it very neat. It briefly highlights the cursor position when switching
; to a new window or buffer
(use-package beacon
  :ensure t
  :init
  (beacon-mode 1))

; Initialize avy
; Avy is a very useful package; instead of having to move your cursor to a line that is very far away, just do M - s and type
; the character that you want to move to
(use-package avy
  :ensure t
  :bind
  ("M-s" . avy-goto-char))

; Initialize switch-window
; Switch window is a neat package because instead of having to painstakingly do Cc - o until you're in the window you want to
; edit, you can just do Cc - o and pick the one you want to move to according to the letter it is assigned to
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
; Currently I have this set up for C and C++ mode only but this might change in the future if there is enough interest
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
;;
