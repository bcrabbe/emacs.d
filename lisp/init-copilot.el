;;; init-copilot.el --- Settings for https://github.com/zerolfx/copilot.el -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(require 'init-elpa)

(maybe-require-package 'dash)
(maybe-require-package 's)
(maybe-require-package 'editorconfig)

(add-to-list 'load-path "../site-lisp/copilot.el")
(require 'copilot)


(add-hook 'prog-mode-hook 'copilot-mode)

(define-key copilot-completion-map (kbd "<tab>") 'copilot-accept-completion)
(define-key copilot-completion-map (kbd "<backtab>") 'copilot-next-completion)

(provide 'init-copilot)
;;; init-copilot.el ends here
