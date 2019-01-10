(when (maybe-require-package 'erlang)
  (require 'erlang-start)
  (setq flycheck-display-errors-function nil
        flycheck-erlang-include-path '("../include" "./" "../deps" "../../include")
        flycheck-erlang-library-path '()
        flycheck-check-syntax-automatically '(idle-change)))


(provide 'init-erlang)
