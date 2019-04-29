(global-linum-mode 1)

(show-paren-mode 1)

(setq inhibit-startup-message t)

(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

(setq x-select-enable-clipboard t)

(setq make-backup-files nil)
(setq auto-save-default nil)

(setq scroll-conservatively 100)

(setq ring-bell-function 'ignore)

(setq-default standard-indent 4)
(setq-default tab-width 4)
(setq c-basic-offset tab-width)

(global-prettify-symbols-mode t)

(setq electric-pair-pairs '(
                           (?\{ . ?\})
                           (?\( . ?\))
                           (?\[ . ?\])
                           (?\" . ?\")
                          ))
(electric-pair-mode t)

(defun split-and-follow-horizontally ()
      (interactive)
      (split-window-below)
      (balance-windows)
      (other-window 1))
(global-set-key (kbd "C-x 2") 'split-and-follow-horizontally)

(defun split-and-follow-vertically ()
      (interactive)
      (split-window-right)
      (balance-windows)
      (other-window 1))
(global-set-key (kbd "C-x 3") 'split-and-follow-vertically)

(use-package diminish
  :ensure t
  :after (:all 
  beacon
  which-key
  page-break-lines
  undo-tree
  eldoc
  abbrev
  irony
  company)
  :config
  (diminish 'beacon-mode)
  (diminish 'which-key-mode)
  (diminish 'page-break-lines-mode)
  (diminish 'undo-tree-mode)
  (diminish 'eldoc-mode)
  (diminish 'abbrev-mode)
  (diminish 'irony-mode)
  (diminish 'company-mode))

;(defmacro diminish-built-in (&rest modes)
;  "Accepts a list MODES of built-in emacs modes and generates `with-eval-after-load` diminish forms based on the file implementing the mode functionality for each mode."
;  (declare (indent defun))
;  (let* ((get-file-names (lambda (pkg) (file-name-base (symbol-file pkg))))
;	 (diminish-files (mapcar get-file-names modes))
;	 (zip-diminish   (-zip modes diminish-files)))
;    `(progn
;       ,@(cl-loop for (mode . file) in zip-diminish
;		  collect `(with-eval-after-load ,file
;			     (diminish (quote ,mode)))))))
; This bit goes in init.el
;(diminish-built-in
;  beacon-mode
;  which-key-mode
;  page-break-lines-mode
;  undo-tree-mode
;  eldoc-mode
;  abbrev-mode
;  irony-mode
;  company-mode)

(use-package spaceline
  :ensure t)

(use-package powerline
  :ensure t
  :init
  (spaceline-spacemacs-theme))
(add-hook 'after-init-hook 'powerline-reset)

(use-package dashboard
      :ensure t
      :preface
      (defun update-config ()
	"Update Witchmacs to the latest version."
	(interactive)
	(let ((dir (expand-file-name user-emacs-directory)))
	      (if (file-exists-p dir)
		      (progn
			(message "Witchmacs is updating!")
			(cd dir)
			(shell-command "git pull")
			(message "Update finished. Switch to the messages buffer to see changes and then restart Emacs"))
		(message "\"%s\" doesn't exist." dir))))

      (defun create-scratch-buffer ()
	"Create a scratch buffer"
	(interactive)
	(switch-to-buffer (get-buffer-create "*scratch*"))
	(lisp-interaction-mode))

      (defun dashboard-center-line (&optional real-width)
	      "Center-align when point is at the end of a line"
	      (let* ((width (or real-width (current-column)))
			 (margin (max 0 (floor (/ (- dashboard-banner-length width) 2)))))
		(beginning-of-line)
		(insert (make-string margin ?\s))
		(end-of-line)))

      (defun dashboard-insert-buttons()
	"Insert custom buttons after banner"
	(interactive)
	(with-current-buffer (get-buffer dashboard-buffer-name)
	      (read-only-mode -1)
	      (goto-char (point-min))
	      (search-forward dashboard-banner-logo-title nil t)

	      (insert "\n\n\n")
	      (widget-create 'url-link
					 :tag "Witchmacs on github"
					 :help-echo "Open Witchmacs' github page on your browser"
					 :mouse-face 'highlight
					 "https://github.com/snackon/witchmacs")

	      (insert " ")
	      (widget-create 'file-link
					 :tag "Witchmacs Cheatsheet"
					 :help-echo "Open Witchmacs cheatsheet"
					 :mouse-face 'highlight
					 "~/.emacs.d/Witcheat.org")

	      (insert " ")
	      (widget-create 'push-button
				 :tag "Update Witchmacs"
				 :help-echo "Get the latest Witchmacs update. Check out the github commits for changes!"
				 :mouse-face 'highlight
				 :action (lambda (&rest _) (update-config)))

	      (dashboard-center-line)
	      (insert "\n")

	      (insert " ")
	      (widget-create 'push-button
					 :tag "Open scratch buffer"
					 :help-echo "Switch to the scratch buffer"
					 :mouse-face 'highlight
					 :action (lambda (&rest _) (create-scratch-buffer)))
	      (insert " ")
	      (widget-create 'file-link
					 :tag "Open config.org"
					 :help-echo "Open Witchmacs' configuration file for easy editing"
					 :mouse-face 'highlight
					 "~/.emacs.d/config.org")

	      (dashboard-center-line)
	      (insert "\n\n")

	      (insert (concat
			       (propertize (format "%d packages loaded in %s"
					      (length package-activated-list) (emacs-init-time))
			      'face 'font-lock-comment-face)))

	      (dashboard-center-line)
	      (read-only-mode 1)))
      :config
      (dashboard-setup-startup-hook)
      (setq dashboard-items '((recents . 5)))
      (setq dashboard-banner-logo-title "W I T C H M A C S - The cutest Emacs distribution!")
      (setq dashboard-startup-banner "~/.emacs.d/marivector.png")
      (setq dashboard-center-content t)
      (setq dashboard-show-shortcuts nil))
      (add-hook 'dashboard-mode-hook #'dashboard-insert-buttons)

(use-package which-key
  :ensure t
  :init
  (which-key-mode))

(use-package swiper
      :ensure t
      :bind ("C-s" . 'swiper))

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
      :defer t
      :config
      (setq switch-window-input-style 'minibuffer)
      (setq switch-window-increase 4)
      (setq switch-window-threshold 2)
      (setq switch-window-shortcut-style 'qwerty)
      (setq switch-window-qwerty-shortcuts
		'("a" "s" "d" "f" "j" "k" "l"))
      :bind
      ([remap other-window] . switch-window))

(setq ido-enable-flex-matching nil)
(setq ido-create-new-buffer 'always)
(setq ido-everywhere t)
(ido-mode 1)

(use-package ido-vertical-mode
      :ensure t
      :init
      (ido-vertical-mode 1))
; This enables arrow keys to select while in ido mode. If you want to
; instead use the default Emacs keybindings, change it to
; "'C-n-and-C-p-only"
(setq ido-vertical-define-keys 'C-n-C-p-up-and-down)

(use-package company
      :ensure t
      :defer t
      :config
      (setq company-idle-delay 0)
      (setq company-minimum-prefix-length 3)
      (define-key company-active-map (kbd "M-n") nil)
      (define-key company-active-map (kbd "M-p") nil)
      (define-key company-active-map (kbd "C-n") #'company-select-next)
      (define-key company-active-map (kbd "C-p") #'company-select-previous)
      (define-key company-active-map (kbd "SPC") #'company-abort)
      :hook ((python-mode c-mode c++-mode) . company-mode))

(use-package yasnippet
      :ensure t
      :config
	(use-package yasnippet-snippets
	      :ensure t)
	(yas-reload-all))
(add-hook 'c++-mode-hook 'yas-minor-mode)
(add-hook 'c-mode-hook 'yas-minor-mode)
(add-hook 'python-mode 'yas-minor-mode)

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
