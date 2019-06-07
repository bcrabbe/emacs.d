(load "../site-lisp/hl-tags-mode.el")
(load "../site-lisp/zenburn-theme.el")
;;(setq-default custom-enabled-themes '(zenburn-theme))
(set-face-attribute 'region nil :background "#066")

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
(maybe-require-package 'rjsx-mode)
(maybe-require-package 'graphql-mode)
(maybe-require-package 'scala-mode)
;; (maybe-require-package 'ensime-mode)
;;; (maybe-require-package 'indium)

;; (add-to-list 'exec-path "/usr/local/Cellar/sbt/1.2.8/bin/sbt")
(setq
 ensime-sbt-command "/usr/local/Cellar/sbt/1.2.8/libexec/bin/sbt.bat"
 sbt:program-name "/usr/local/Cellar/sbt/1.2.8/libexec/bin/sbt.bat")

(setq erlang-root-dir "/usr/local/Cellar/erlang/21.1.1")

(maybe-require-package 'key-chord)
(key-chord-mode +1)

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

(setq-default js2-basic-offset 4)
(setq-default sgml-basic-offset 4)
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
(global-set-key (kbd "M-=") 'er/contract-region)
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

(defun fresh-mui-component ()
  "Insert error_logger call."
  (interactive)
  (insert "import React from 'react';
import {withStyles} from '@material-ui/core/styles';
import PropTypes from 'prop-types';
import * as R from 'ramda';
import classnames from 'classnames';

class Default extends React.PureComponent {

  static propTypes = {
    classes: PropTypes.object.isRequired,
    theme: PropTypes.object.isRequired,
  }

  static defaultProps = {
  }

  constructor(props) {
    super(props);
    this.state = {
    };
  }

  render() {
    const {classes} = this.props;
    return (
      <div
        style={this.props.style}
        className={classnames(
          this.props.className,
          classes.root,
        )}
      >
      </div>
    );
  }
}

const styles = theme => ({
  root: {
    width: '100%',
  }
});

export default withStyles(styles, {withTheme: true})(Default);
"))

(defun insert-component-did-update ()
  "Insert componentDidUpdate react lifecycle method."
  (interactive)
  (insert "componentDidUpdate(prevProps, prevState) {

  }"))

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

(provide 'init-local)
