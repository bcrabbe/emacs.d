;;; init-erlang.el --- Support for the Erlang language -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(when (maybe-require-package 'erlang)
  (require 'erlang-start)
  (setq flycheck-display-errors-function nil
        flycheck-erlang-include-path '("../include" "./" "../deps" "../../include")
        flycheck-erlang-library-path '()
        flycheck-check-syntax-automatically '(idle-change)))

(defun bc-insert-erlang-binary (start end)
  "Will wrap the preceeding sexp with <<\"\">>,
if mark-active, then wraps region."
  (interactive "r")
  (if mark-active
      (progn (goto-char start)
             (insert "<<\"")
             (goto-char (+ 3 end))
             (insert "\">>"))
    (progn (backward-sexp 1)
           (insert "<<\"")
           (forward-sexp 1)
           (insert "\">>"))))

(global-set-key (kbd "C-M-'") 'bc-insert-erlang-binary)

(defun gen-erl-tags ()
  "Generate and visit tags for scala."
  (interactive)
  (setq repo-root (vc-call-backend (vc-responsible-backend ".") 'root "."))
  (shell-command (concat "pushd " repo-root " && find . -name \"*.[he]rl\" -print | etags - && popd"))
  (visit-tags-table repo-root)
  (visit-tags-table "~/software/otp/"))
(key-chord-define-global "<>" 'gen-erl-tags)

(provide 'init-erlang)
;;; init-erlang.el ends here
