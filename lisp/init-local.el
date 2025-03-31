;;; package --- my personal configuration
;;; Commentary:
;;; Code:
(load "../site-lisp/hl-tags-mode.el")

(load "../site-lisp/zenburn-theme.el")
(setq-default custom-enabled-themes '(zenburn))
(reapply-themes)

(set-face-attribute 'region nil :background "#066")
(setq shell-file-name "/bin/zsh")
(maybe-require-package 'edit-server)
(edit-server-start +1)
;; (maybe-require-package 'winner-mode)
(winner-mode +1)

(maybe-require-package 'cmake-mode)
(add-to-list 'auto-mode-alist '("\\.cmake\\'" . cmake-mode))

(maybe-require-package 'flycheck-yamllint)
(eval-after-load 'flycheck
  '(add-hook 'flycheck-mode-hook 'flycheck-yamllint-setup))
(add-hook 'yaml-hook 'flycheck-mode)
(maybe-require-package 'smart-shift)
;;(key-chord-define-global "<<" 'smart-shift-left)
;;(key-chord-define-global ">>" 'smart-shift-right)

;;(maybe-require-package 'highlight-indentation)
(load "../site-lisp/highlight-indentation.el")
(add-hook 'yaml-hook 'hightlight-indentation-mode)
(set-face-background 'highlight-indentation-face "#5c5d60")
(set-face-background 'highlight-indentation-current-column-face "#c3b3b3")

(maybe-require-package 'thrift)
(maybe-require-package 'nginx-mode)
(maybe-require-package 'string-inflection)
(maybe-require-package 'emmet-mode)
(maybe-require-package 'rainbow-mode)
(maybe-require-package 'key-chord)
;; Add key-chord-mode to minor-mode-alist
(if (not (assq 'key-chord-mode minor-mode-alist))
    (setq minor-mode-alist
          (cons '(key-chord-mode " KeyC ")
                minor-mode-alist)))
(maybe-require-package 'rjsx-mode)
(maybe-require-package 'graphql-mode)
(maybe-require-package 'scala-mode)
(maybe-require-package 'sbt-mode)
(maybe-require-package 'bazel)
;; (maybe-require-package 'ensime)
;;; (maybe-require-package 'indium)

;; (add-to-list 'exec-path "/usr/local/Cellar/sbt/1.2.8/bin/sbt")
(setq
 ensime-sbt-command "/usr/local/.8/libexec/bin/sbt.bat"
 sbt:program-name "/usr/local/Cellar/sbt/1.2.8/libexec/bin/sbt.bat")

(setq sbt:prefer-nested-projects t)

(add-hook 'sbt-mode-hook
          (lambda ()
            (setq prettify-symbols-alist
                  `((,(expand-file-name (directory-file-name default-directory)) . ?⌂)
                    (,(expand-file-name "~") . ?~)))
            (prettify-symbols-mode t)))

(setq compilation-auto-jump-to-first-error t)
(global-set-key (kbd "C-c s") 'sbt-hydra)

(defun insert-random-uuid ()
  "Run uuidgen."
  (interactive)
  (shell-command "uuidgen | tr \"[:upper:]\" \"[:lower:]\"" t))

(defun insert-ts ()
  "Run uuidgen."
  (interactive)
  (shell-command "date  +%s" t))

(setq erlang-root-dir "/usr/local/Cellar/erlang/24.1.4")

(maybe-require-package 'key-chord)
(key-chord-mode +1)

(defun markdown-convert-buffer-to-org ()
  "Convert the current buffer's content from markdown to orgmode format and save it with the current buffer's file name but with .org extension."
  (interactive)
  (shell-command-on-region (point-min) (point-max)
                           (format "pandoc -f markdown -t org -o %s"
                                   (concat (file-name-sans-extension (buffer-file-name)) ".org"))))

;;make <return> insert a newline; multiple-cursors-mode can still be disabled with C-g.
(add-hook 'multiple-cursors-mode-hook
          (lambda ()
            "remove <RET> kbd"
            (define-key mc/keymap (kbd "<return>") nil)))

(add-to-list 'auto-mode-alist '("\\.jsx\\'" . rjsx-mode))

(setq emmet-expand-jsx-className? t) ;; default nil
(add-hook 'rjsx-mode-hook 'emmet-mode)
(add-hook 'rjsx-mode-hook 'hl-tags-mode)
(add-hook 'rjsx-mode-hook 'rainbow-mode)

(global-set-key (kbd "M-g r") 'rgrep)

;;;was always breaking my code by pressing this
(global-set-key (kbd "M-t") nil)
(global-set-key (kbd "M-f") 'forward-to-word)

(setq-default js2-basic-offset 2)
;; (setq-default sgml-basic-offset 4)
(setq-default js2-strict-trailing-comma-warning nil)

(maybe-require-package 'buffer-move)
(global-set-key (kbd "C-M-}") 'buf-move-right)
(global-set-key (kbd "C-M-{") 'buf-move-left)
(defun split-window-and-balance ()
  "Split and balance: \"split-window-horizontally\" and then \"balance-windows\"."
  (interactive)
  (split-window-horizontally)
  (balance-windows))

(key-chord-define-global "§§" 'split-window-and-balance)
(global-set-key (kbd "C-x 4") 'split-window-horizontally)
(global-set-key (kbd "C-x 2") 'split-window-vertically)
(global-set-key (kbd "M-`") 'other-frame)
(global-set-key (kbd "C-`") 'other-frame)
(global-set-key (kbd "M-]") 'next-multiframe-window)
(global-set-key (kbd "M-[") 'previous-multiframe-window)

;; (maybe-require-package 'contract-region)
(maybe-require-package 'expand-region)
(global-set-key (kbd "M-=") 'er/contract-region)
(global-set-key (kbd "C-=") 'er/expand-region)

(global-set-key (kbd "C-M-<backspace>") 'backward-kill-sexp)
(global-set-key (kbd "M-s s") 'paredit-splice-sexp)
(global-set-key (kbd "M-s p") 'paredit-split-sexp)
(global-set-key (kbd "M-s j") 'paredit-join-sexp)
(global-set-key (kbd "C-)") 'paredit-forward-slurp-sexp)
(global-set-key (kbd "C-(") 'paredit-backward-slurp-sexp)
(global-set-key (kbd "C-}") 'paredit-forward-barf-sexp)
(global-set-key (kbd "C-{") 'paredit-backward-barf-sexp)

(defun error-logger-info-report ()
  "Insert error_logger call."
  (interactive)
  (insert "error_logger:info_report(
   [{module, ?MODULE},
   {line, ?LINE},
   {function, ?FUNCTION_NAME},
   {}]
  ),"))
(key-chord-define-global "LL" 'error-logger-info-report)
(defun insert-console-log ()
  "Insert console.log()."
  (interactive)
  (insert "console.log()"))

(key-chord-define-global "CC" 'insert-console-log)
(defun insert-const ()
  "Insert const."
  (interactive)
  (insert "const "))
(key-chord-define-global "XX" 'insert-const)
(key-chord-define-global "^^" 'string-inflection-lower-camelcase)

(defun switch-to-previous-buffer ()
  "Switch to previously open buffer.
Repeated invocations toggle between the two most recently open buffers."
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer) 1)))
(key-chord-define-global "JJ" 'switch-to-previous-buffer)

(maybe-require-package 'multi-web-mode)
(setq mweb-default-major-mode 'html-mode)
(setq mweb-tags '((php-mode "<\\?php\\|<\\? \\|<\\?=" "\\?>")
                  (js-mode "<script +\\(type=\"text/javascript\"\\|language=\"javascript\"\\)[^>]*>" "</script>")
                  (css-mode "<style +type=\"text/css\"[^>]*>" "</style>")))
(setq mweb-filename-extensions '("php" "htm" "html" "ctp" "phtml" "php4" "php5"))
(multi-web-global-mode 1)

(defun stop-using-minibuffer ()
  "Kill the minibuffer."
  (when (and (>= (recursion-depth) 1) (active-minibuffer-window))
    (abort-recursive-edit)))

(add-hook 'mouse-leave-buffer-hook 'stop-using-minibuffer)

;; https://superuser.com/questions/1133436/way-too-fast-scrolling-in-emacs-on-osx
(setq mouse-wheel-scroll-amount '(3
                                  ((shift) . 1)
                                  ((control) . nil)))
(setq mouse-wheel-progressive-speed nil)
(setq mac-mouse-wheel-mode t)

(defun dlh-increment-string (string)
  "Increment the first integer found in STRING."
  (setq start (string-match "\\([0-9]+\\)" string))
  (setq end (match-end 0))
  (setq number (string-to-number (substring string start end)))
  (setq new-num-string (number-to-string (+ 1 number)))
  (concat
   (substring string 0 start)
   new-num-string
   (substring string end)))

(defun dlh-yank-increment ()
  "Yank text, incrementing the first integer found in it."
  (interactive "*")
  (setq new-text (dlh-increment-string (current-kill 0)))
  (insert-for-yank new-text)
  (kill-new new-text t))

(global-set-key (kbd "C-c C-y") 'dlh-yank-increment)

(maybe-require-package 'git-link)
(eval-after-load 'git-link
  '(progn
     (add-to-list 'git-link-remote-alist
                  '("code.corp.creditkarma.com" git-link-github))
     (add-to-list 'git-link-commit-remote-alist
                  '("code.corp.creditkarma.com" git-link-github))))
(setq git-link-use-commit t)

(defun bc/jira-link (jira-ticket-id)
  "Link to Jira JIRA-TICKET-ID."
  (interactive "*sJIRA-TICKET-ID: ")
  (insert (concat "https://gemini-spaceship.atlassian.net/browse/" jira-ticket-id)))

(defun gen-be-tags ()
  "Generate and visit tags for scala."
  (interactive)
  (setq repo-root (vc-call-backend (vc-responsible-backend ".") 'root "."))
  (shell-command (concat "pushd " repo-root " && /usr/local/Cellar/ctags/5.8_2/bin/ctags -R -e **/*.scala && popd"))
  (visit-tags-table repo-root))

(setq epa-pinentry-mode 'loopback)

(defun gen-scala-tags ()
  "Generate and visit tags for scala."
  (interactive)
  (setq repo-root (vc-call-backend (vc-responsible-backend ".") 'root "."))
  (shell-command (concat "pushd " repo-root " && /usr/local/Cellar/ctags/5.8_2/bin/ctags -R -e **/*.scala && popd"))
  (visit-tags-table repo-root))

(defun gen-thrift-tags ()
  "Generate and visit tags for thrift."
  (interactive)
  (setq repo-root (vc-call-backend (vc-responsible-backend ".") 'root "."))
  (shell-command (concat "pushd " repo-root " && /usr/local/Cellar/ctags/5.8_2/bin/ctags -R -e **/*.thrift && popd"))
  (visit-tags-table repo-root))

(defun gen-ts-tags ()
  "Generate and visit tags for thrift, scala and js."
  (interactive)
  (setq repo-root (vc-call-backend (vc-responsible-backend ".") 'root "."))
  (shell-command (concat "pushd " repo-root " && /usr/local/Cellar/ctags/5.8_2/bin/ctags -R -e **/*.ts && popd"))
  (visit-tags-table repo-root))

(defun gen-graphql-tags ()
  "Generate and visit tags for thrift, scala and js."
  (interactive)
  (setq repo-root (vc-call-backend (vc-responsible-backend ".") 'root "."))
  (shell-command (concat "pushd " repo-root " && /usr/local/Cellar/ctags/5.8_2/bin/ctags -R -e **/*.graphql && popd"))
  (visit-tags-table repo-root))

(key-chord-define-global ",." 'gen-scala-tags)
(defun visit-lib-tags ()
  "Visit tags tables for common libraries."
  (interactive)
  (setq tag-locations '("~/code/fwk_talon-scala/TAGS", "~/code/con_idl/TAGS", "~/code/ce_credit-ecosystem-libraries/TAGS", "~/software/finagle/TAGS"))
  (while tag-locations
    ((visit-tags-table (car tag-locations))
     (setq tag-locations (cdr tag-locations)))))
;;; A fancy grep style fallback for when M-. is not providing.
(maybe-require-package 'rg)
(maybe-require-package 'ag)
;; (maybe-require-package 'dumb-jump-mode)
;; (global-set-key (kbd "C-M-.") 'dumb-jump-go)

(global-set-key (kbd "C-x M-b") 'magit-blame)

(global-set-key [mouse-4] 'previous-buffer)
(global-set-key [mouse-5] 'next-buffer)


(defun bc/binary-quote-sexp (start end)
  "Will wrap the preceeding sexp with <<\"\">>, if mark-active, then wraps region."
  (interactive "r")
  (if mark-active
      (progn (goto-char start)
             (insert "\"")
             (goto-char (+ 1 end))
             (insert "\""))
    (progn (backward-sexp 1)
           (insert "\"")
           (forward-sexp 1)
           (insert "\""))))

(global-set-key (kbd "M-'") #'bc/binary-quote-sexp)

;;; Expand region

(require-package 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)

(key-chord-define-global "MM" 'toggle-frame-fullscreen)
(key-chord-define-global "@@" 'string-inflection-all-cycle)
(key-chord-define-global "UU" 'upcase-char)

(toggle-frame-fullscreen)
(provide 'init-local)

(defun org-insert-src ()
  "Add a #+BEGIN_SRC #+END_SRC."
  (interactive)
  (insert "#+BEGIN_SRC" "\n"  "#+END_SRC"))

(defun emacs-FAITH (&rest ignore)
  "Post faith in the current channel."
  (interactive)
  (require 'faith)
  (insert (faith-quote)))

(maybe-require-package 'protobuf-mode)


(use-package dired-sidebar
  :bind (("C-x C-n" . dired-sidebar-toggle-sidebar))
  :ensure nil
  :commands (dired-sidebar-toggle-sidebar))

(defun my/find-imports-with-rg ()
  "Find all import statements containing the identifier at point in the current Git repo using ripgrep."
  (interactive)
  (let* ((identifier (thing-at-point 'symbol t))
         (rg-command (format "rg --no-heading --line-number --color never 'import .*%s' $(git rev-parse --show-toplevel)"
                             identifier)))
    (if (not identifier)
        (message "No identifier at point.")
      (let ((results (shell-command-to-string rg-command)))
        (if (string-empty-p results)
            (message "No import statements found for: %s" identifier)
          (message "Imports found:\n%s" results))))))

(defun my/find-imports-and-yank ()
  "Find all import statements containing the identifier at point in the current Git repo using ripgrep.
Displays results in the minibuffer and yanks the first found import statement."
  (interactive)
  (let* ((identifier (thing-at-point 'symbol t))
         (rg-command (format "rg --no-heading --line-number --color never 'import .*%s' $(git rev-parse --show-toplevel)"
                             identifier)))
    (if (not identifier)
        (message "No identifier at point.")
      (let ((results (shell-command-to-string rg-command)))
        (if (string-empty-p results)
            (message "No import statements found for: %s" identifier)
          (let* ((lines (split-string results "\n" t))
                 (first-import (when lines (car lines)))
                 (import-statement (when first-import
                                     (string-match "\\(import .*\\)" first-import)
                                     (match-string 1 first-import))))
            (when import-statement
              (kill-new import-statement)
              (message "Yanked: %s\n\nResults:\n%s" import-statement results))))))))

(defun convert-newlines-to-commas ()
  "Convert highlighted newline-separated list to a comma-separated list."
  (interactive)
  (when (use-region-p)
    (let ((beg (region-beginning))
          (end (region-end)))
      (save-restriction
        (narrow-to-region beg end) ;; Work only within the region
        (goto-char (point-min))
        (while (search-forward "\n" nil t)
          (replace-match ", " nil t))))))

;;; init-local.el ends here
