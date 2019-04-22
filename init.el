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

;; By default, Witchmacs comes with my own theme I made based off monokai. If you want to use other theme and don't know how, please look at earlier versions of Witchmacs for an example on how to do so
(load-theme 'Witchmacs t)
;;

;; QOL section

; Show in the modeline which line and column you are in 
; powerline enables both of these by default, but if you don't want to use powerline you can uncomment these
;(line-number-mode 1)
;(column-number-mode 1)

; Enable line numbers on the left
(global-linum-mode t)

; Show which parenthesis belongs to which one
(show-paren-mode 1)

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
;(cons page-break-lines-char page-break-lines-char)
;(face-attribute 'default :family))
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
  (setq dashboard-banner-logo-title "W I T C H M A C S - The cutest Emacs distribution!")
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
  (setq company-minimum-prefix-length 3)
  (define-key company-active-map (kbd "M-n") nil)
  (define-key company-active-map (kbd "M-p") nil)
  (define-key company-active-map (kbd "C-n") #'company-select-next)
  (define-key company-active-map (kbd "C-p") #'company-select-previous)
  (define-key company-active-map (kbd "SPC") #'company-abort)
  :hook ((c-mode c++-mode) . company-mode))

(add-hook 'c++-mode-hook 'yas-minor-mode)
(add-hook 'c-mode-hook 'yas-minor-mode)

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

; Initialize diminish
; Diminish is at the bottom here because it needs to load after ALL other packages have loaded, otherwise it doesn't work (or does it? if you know how to make it work when not at the very bottom, please let me know!)
(use-package diminish
  :ensure t
  :init
  (diminish 'beacon-mode)
  (diminish 'which-key-mode)
  (diminish 'page-break-lines-mode)
  (diminish 'undo-tree-mode)
  (diminish 'eldoc-mode)
  (diminish 'abbrev-mode)
  (diminish 'irony-mode)
  (diminish 'company-mode))
;;

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#262626" "#FF6666" "#A6E22E" "#FFFF66" "#6666FF" "#FD5FF0" "#99CCFF" "#F1EFEE"])
 '(custom-safe-themes
   (quote
	("394afdd6db1af4d1700818169f86eb30371d2e1b1c0a50d3a43aacebbf51d8d1" "3bc2d63cb722b2d77253bd53fbcc7a623e8b0bc520360ed96c9f15601970e0eb" "c04e36d05947668d8fdbe8b70519a2ba16ba5f602b7c33e2310e73d6db7bba4d" "c848ec9e9fb046a705929184c659d4b543ffa1e65da6940c79d3543857b637be" "ad289d381653bbba376bd00be0dbb75b30eb0481a9ddd70b9e914a6e2f84c59a" "d8fb259adc030f414653ff1cec02f362c0894cb0a2688d34567af4b1c35d3095" "bd7b7c5df1174796deefce5debc2d976b264585d51852c962362be83932873d9" "aa7a18c1dfb8a1c71b32e1a8b1ab05c6010037adf96f4b865143df03fe8f24a5" "2bfe756008dd09f5ba994db79d52796d3c3a322b96afa216e4a2456950397d08" "328bc39b8cd28c0712e22e3bf175b032d880e6897ab825b946e3493111976e71" "7465975d8e22260a4203476211f7b77b372a007c17118cf515df87cab4406b27" "20b63c6e0340a4665fff5e15c3d4d12263b7c80f6af6bbc80f3872e5c6db053b" "d91c3b2d66a53a8d0cce0ed5a8ab44c987e2619d4419199f5c995a536f0fc2d8" "c79c9fc2223555d4f80da015609961ec08c605e56a7a32ac40728b5e064bfc88" "0698b2709dd4e990f62d67355999d4aa97e997fe2a0df6c14d6fd80b0ddab09f" default)))
 '(package-selected-packages
   (quote
	(monokai-theme company-irony company-c-headers company yasnippet-snippets yasnippet switch-window avy beacon evil which-key dashboard spaceline use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#262626" :foreground "#F8F8F2" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 97 :width normal :foundry "unknown" :family "Iosevka")))))
