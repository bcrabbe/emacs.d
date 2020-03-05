;;; init-github.el --- Github integration -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(require 'init-git)

(maybe-require-package 'yagist)
(require-package 'bug-reference-github)
(add-hook 'prog-mode-hook 'bug-reference-prog-mode)

(maybe-require-package 'github-clone)
(maybe-require-package 'forge)
(maybe-require-package 'github-review)


(with-eval-after-load 'forge
  (push '("code.corp.creditkarma.com" "code.corp.creditkarma.com/api/v3" "code.corp.creditkarma.com" forge-github-repository) forge-alist))
;; to allow auto decoding gpg files:
;; (setq epa-pinentry-mode 'loopback)
(provide 'init-github)
;;; init-github.el ends here
