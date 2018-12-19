(load "../site-lisp/hl-tags-mode.el")
(load "../site-lisp/zenburn-theme.el")
;;(setq-default custom-enabled-themes '(zenburn-theme))
(set-face-attribute 'region nil :background "#066")

(maybe-require-package 'edit-server)
(edit-server-start +1)
(maybe-require-package 'winner-mode)
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


(maybe-require-package 'nginx-mode)
(maybe-require-package 'string-inflection)
(key-chord-define-global "^^" 'string-inflection-lower-camelcase)
(maybe-require-package 'emmet-mode)
(maybe-require-package 'rainbow-mode)
(maybe-require-package 'key-chord)
(maybe-require-package 'rjsx-mode)
;;; (maybe-require-package 'indium)


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

(defun split-window-and-balance ()
  "Split and balance: \"split-window-horizontally\" and then \"balance-windows\"."
  (interactive)
  (split-window-horizontally)
  (balance-windows))

(key-chord-define-global "§§" 'split-window-and-balance)
(global-set-key (kbd "C-x 4") 'split-window-horizontally)
(global-set-key (kbd "M-`") 'other-frame)
(global-set-key (kbd "C-`") 'other-frame)
(global-set-key (kbd "M-]") 'next-multiframe-window)
(global-set-key (kbd "M-[") 'previous-multiframe-window)
(global-set-key (kbd "M-=") 'er/contract-region)
(global-set-key (kbd "C-M-<backspace>") 'backward-kill-sexp)
(global-set-key (kbd "M-s s") 'paredit-splice-sexp)

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
import { withStyles } from '@material-ui/core/styles';
import PropTypes from 'prop-types';
import * as R from 'ramda';
import classNames from 'classnames';

class Default extends React.PureComponent {

  static propTypes = {
    classes: PropTypes.object.isRequired,
    theme: PropTypes.object.isRequired,
  };

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
        className={classNames(
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

export default withStyles(styles, { withTheme: true })(Default);
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
  "kill the minibuffer"
  (when (and (>= (recursion-depth) 1) (active-minibuffer-window))
    (abort-recursive-edit)))

(add-hook 'mouse-leave-buffer-hook 'stop-using-minibuffer)

(when (maybe-require-package 'flycheck)
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
                (flycheck-mode)))))

(provide 'init-local)
