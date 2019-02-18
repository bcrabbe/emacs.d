;;; init-flycheck.el --- Configure Flycheck global behaviour -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(when (maybe-require-package 'flycheck)
  (add-hook 'after-init-hook 'global-flycheck-mode)
  (setq flycheck-display-errors-function #'flycheck-display-error-messages-unless-error-list)
  (when (maybe-require-package 'flycheck-color-mode-line)
    (add-hook 'flycheck-mode-hook 'flycheck-color-mode-line-mode)))

(after-load 'flychceck
  (flycheck-define-checker erlang-otp
    "An Erlang syntax checker using the Erlang interpreter."
    :command ("erlc" "-o" temporary-directory "-Wall"
              "-I" "../include" "-I" "../../include"
              "-I" "../deps" "-I" "./"
              "-I" "../../../include" source)
    :error-patterns
    ((warning line-start (file-name) ":" line ": Warning:" (message) line-end)
     (error line-start (file-name) ":" line ": " (message) line-end))
    :modes (erlang-mode))
  (add-hook 'erlang-mode-hook
            (lambda ()
              (flycheck-select-checker 'erlang-otp)
              (flycheck-mode))))

(when (maybe-require-package 'flycheck)
  (with-eval-after-load 'flycheck
    (add-hook 'flycheck-mode-hook #'flycheck-inline-mode)))

(provide 'init-flycheck)
;;; init-flycheck.el ends here
