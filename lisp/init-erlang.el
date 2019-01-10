;;; init-erlang.el --- Support for the Erlang language -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(when (maybe-require-package 'erlang)
  (require 'erlang-start)
  (setq flycheck-display-errors-function nil
        flycheck-erlang-include-path '("../include" "./" "../deps" "../../include")
        flycheck-erlang-library-path '()
        flycheck-check-syntax-automatically '(idle-change)))


(provide 'init-erlang)
;;; init-erlang.el ends here
