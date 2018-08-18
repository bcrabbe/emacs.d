(load "./hl-tags-mode.el")
(require-package 'zenburn-theme)
(require-package 'emmet-mode)
(require-package 'rainbow-mode)
(require-package 'key-chord)
(require-package 'rjsx-mode)


(load "../themes/zenburn-theme.el")

;; (setq-default custom-enabled-themes '(zenburn-theme))

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

(defun error-logger-info-report ()
  "Insert error_logger call."
  (interactive)
  (insert "error_logger:info_report([{module,?MODULE},
                                     {line,?LINE},
                                     {}])"))
(key-chord-define-global "LL" 'error-logger-info-report)

(defun switch-to-previous-buffer ()
  "Switch to previously open buffer.
Repeated invocations toggle between the two most recently open buffers."
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer) 1)))

(key-chord-define-global "JJ" 'switch-to-previous-buffer)

(global-set-key "\C-x\C-m" 'execute-extended-command)
(global-set-key "\C-c\C-m" 'execute-extended-command)

(provide 'init-local)
