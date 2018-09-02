(load "../site-lisp/hl-tags-mode.el")
(load "../site-lisp/zenburn-theme.el")
(setq-default custom-enabled-themes '(zenburn-theme))

(maybe-require-package 'emmet-mode)
(maybe-require-package 'rainbow-mode)
(maybe-require-package 'key-chord)
(maybe-require-package 'rjsx-mode)
;;; (maybe-require-package 'indium)

(setq Preferred-javascript-mode 'rjsx-mode)
(require 'key-chord)
(key-chord-mode +1)


(add-to-list 'auto-mode-alist '("\\.jsx\\'" . rjsx-mode))

(setq emmet-expand-jsx-className? t) ;; default nil
(add-hook 'rjsx-mode-hook 'emmet-mode)
(add-hook 'rjsx-mode-hook 'hl-tags-mode)
(add-hook 'rjsx-mode-hook 'rainbow-mode)

(global-set-key (kbd "M-g r") 'rgrep)

(defun split-window-and-balance ()
  "Split and balance: \"split-window-horizontally\" and then \"balance-windows\"."
  (interactive)
  (split-window-horizontally)
  (balance-windows))

(key-chord-define-global "§§" 'split-window-and-balance)
(global-set-key (kbd "C-x 4") 'split-window-horizontally)
(global-set-key (kbd "M-`") 'other-frame)
(global-set-key (kbd "M-[") 'windmove-left)
(global-set-key (kbd "M-]") 'windmove-right)
(global-set-key (kbd "M-=") 'er/contract-region)

(defun error-logger-info-report ()
  "Insert error_logger call."
  (interactive)
  (insert "error_logger:info_report([{module,?MODULE},
                                     {line,?LINE},
                                     {}])"))
(key-chord-define-global "LL" 'error-logger-info-report)
(defun insert-console-log ()
  "Insert console.log()."
  (interactive)
  (insert "console.log()"))
(key-chord-define-global "CC" 'insert-console-log)
(defun insert-const ()
  "Insert const"
  (interactive)
  (insert "const "))
(key-chord-define-global "XX" 'insert-const)

(defun switch-to-previous-buffer ()
  "Switch to previously open buffer.
Repeated invocations toggle between the two most recently open buffers."
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer) 1)))
(key-chord-define-global "JJ" 'switch-to-previous-buffer)


(provide 'init-local)
