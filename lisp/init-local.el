(load-theme 'zenburn t)
(load "./hl-tags-mode.el")
(setq Preferred-javascript-mode 'rjsx-mode)
(require 'key-chord)
(key-chord-mode +1)


(add-to-list 'auto-mode-alist '("\\.jsx\\'" . rjsx-mode))

(setq emmet-expand-jsx-className? t) ;; default nil
(add-hook 'rjsx-mode-hook 'emmet-mode)
(add-hook 'rjsx-mode-hook 'hl-tags-mode)

(global-set-key (kbd "M-g r") 'find-grep-dired)



(key-chord-define-global "qq" 'split-window-horizontally)
(global-set-key (kbd "C-x 4") 'split-window-horizontally)

(defun switch-to-previous-buffer ()
  "Switch to previously open buffer.
Repeated invocations toggle between the two most recently open buffers."
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer) 1)))

(key-chord-define-global "JJ" 'switch-to-previous-buffer)


(provide 'init-local)
