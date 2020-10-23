;;; Init-javascript.el --- Support for Javascript and derivatives -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(maybe-require-package 'json-mode)
(maybe-require-package 'js2-mode)
(maybe-require-package 'rjsx-mode)
(maybe-require-package 'coffee-mode)
(load "../site-lisp/typescript-mode.el")
(maybe-require-package 'ng2-mode)
(maybe-require-package 'web-mode)
;; (Maybe-require-package 'typescript-mode)


(after-load 'typescript-mode
  (maybe-require-package 'tide))

(add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))

(maybe-require-package 'prettier-js)

(defcustom preferred-javascript-mode
  (first (remove-if-not #'fboundp '(js2-mode js-mode rjsx-mode)))
  "Javascript mode to use for .js files."
  :type 'symbol
  :group 'programming
  :options '(js2-mode js-mode rjsx-mode))

(defconst preferred-javascript-indent-level 4)

;; Need to first remove from list if present, since elpa adds entries too, which
;; may be in an arbitrary order

(add-to-list 'auto-mode-alist '("\\.\\(js\\|es6\\)\\(\\.erb\\)?\\'" . js2-mode))
;; (add-to-list 'auto-mode-alist '("\\.\\(ts\\|es6\\)\\(\\.erb\\)?\\'" . ng2-mode))

;; js2-mode

;; Change some defaults: customize them to override
(setq-default js2-bounce-indent-p nil)
(with-eval-after-load 'js2-mode
  ;; Disable js2 mode's syntax error highlighting by default...
  (setq-default js2-mode-show-parse-errors nil
                js2-mode-show-strict-warnings nil)
  ;; ... but enable it if flycheck can't handle javascript
  ;; use local eslint from node_modules before global
  ;; http://emacs.stackexchange.com/questions/21205/flycheck-with-file-relative-eslint-executable

  (defun my/use-eslint-from-node-modules ()
    (let* ((root (locate-dominating-file
                  (or (buffer-file-name) default-directory)
                  "node_modules"))
           (eslint (and root
                        (expand-file-name "node_modules/.bin/eslint"
                                          root))))
      (when (and eslint (file-executable-p eslint))
        (setq-local flycheck-javascript-eslint-executable eslint))))

  (add-hook 'flycheck-mode-hook #'my/use-eslint-from-node-modules)
  (autoload 'flycheck-get-checker-for-buffer "flycheck")

  (defun sanityinc/enable-js2-checks-if-flycheck-inactive ()
    (unless (flycheck-get-checker-for-buffer)
      (setq-local js2-mode-show-parse-errors t)
      (setq-local js2-mode-show-strict-warnings t)
      (when (derived-mode-p 'js-mode)
        (js2-minor-mode 1))))
  (add-hook 'js-mode-hook 'sanityinc/enable-js2-checks-if-flycheck-inactive)
  (add-hook 'js2-mode-hook 'sanityinc/enable-js2-checks-if-flycheck-inactive)
  (add-hook 'js2-mode-hook #'my/use-eslint-from-node-modules)

  (js2-imenu-extras-setup))


(setq-default js-indent-level 4)
;; In Emacs >= 25, the following is an alias for js-indent-level anyway
(setq-default js2-basic-offset 4)

(add-to-list 'interpreter-mode-alist (cons "node" 'js2-mode))

(with-eval-after-load 'js2-mode
  (sanityinc/major-mode-lighter 'js2-mode "JS2")
  (sanityinc/major-mode-lighter 'js2-jsx-mode "JSX2"))



(when (and (or (executable-find "rg") (executable-find "ag"))
           (maybe-require-package 'xref-js2))
  (when (executable-find "rg")
    (setq-default xref-js2-search-program 'rg))
  (defun sanityinc/enable-xref-js2 ()
    (add-hook 'xref-backend-functions #'xref-js2-xref-backend nil t))
  (with-eval-after-load 'js
    (define-key js-mode-map (kbd "M-.") nil)
    (add-hook 'js-mode-hook 'sanityinc/enable-xref-js2))
  (with-eval-after-load 'js2-mode
    (define-key js2-mode-map (kbd "M-.") nil)
    (add-hook 'js2-mode-hook 'sanityinc/enable-xref-js2)))



;;; Coffeescript

(when (maybe-require-package 'coffee-mode)
  (with-eval-after-load 'coffee-mode
    (setq-default coffee-tab-width js-indent-level))

  (when (fboundp 'coffee-mode)
    (add-to-list 'auto-mode-alist '("\\.coffee\\.erb\\'" . coffee-mode))))

;; ---------------------------------------------------------------------------
;; Run and interact with an inferior JS via js-comint.el
;; ---------------------------------------------------------------------------

(when (maybe-require-package 'js-comint)
  (setq js-comint-program-command "node")

  (defvar inferior-js-minor-mode-map (make-sparse-keymap))
  (define-key inferior-js-minor-mode-map "\C-x\C-e" 'js-send-last-sexp)
  (define-key inferior-js-minor-mode-map "\C-cb" 'js-send-buffer)

  (define-minor-mode inferior-js-keys-mode
    "Bindings for communicating with an inferior js interpreter."
    nil " InfJS" inferior-js-minor-mode-map)

  (dolist (hook '(js2-mode-hook js-mode-hook))
    (add-hook hook 'inferior-js-keys-mode)))

;; ---------------------------------------------------------------------------
;; Alternatively, use skewer-mode
;; ---------------------------------------------------------------------------

(when (maybe-require-package 'skewer-mode)
  (with-eval-after-load 'skewer-mode
    (add-hook 'skewer-mode-hook
              (lambda () (inferior-js-keys-mode -1)))))



(when (maybe-require-package 'add-node-modules-path)
  (dolist (mode '(typescript-mode js-mode js2-mode coffee-mode))
    (add-hook (derived-mode-hook-name mode) 'add-node-modules-path)))

(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  ;; company is an optional dependency. You have to
  ;; install it separately via package-install
  ;; `M-x package-install [ret] company`
  (company-mode +1)
  (setq tide-format-options '(:tabSize 4 :indentSize 4)))
;; aligns annotation to the right hand side
(setq company-tooltip-align-annotations nil)

;; formats the buffer before saving
;; (add-hook 'before-save-hook 'tide-format-before-save)

(add-hook 'typescript-mode-hook #'setup-tide-mode)

(add-hook 'web-mode-hook
          (lambda ()
            (when (or (string-equal "tsx" (file-name-extension buffer-file-name))
                      (string-equal "ts" (file-name-extension buffer-file-name)))
              (setup-tide-mode))))


(provide 'init-javascript)
;;; init-javascript.el ends here
