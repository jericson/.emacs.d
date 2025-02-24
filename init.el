;;; .emacs --- Jon Ericson's .emacs

;; Because c is too close to x.
(global-set-key "\C-x\C-c" nil)

;;; Commentary:

;; Stolen from:
;; https://sites.google.com/site/steveyegge2/effective-emacs 

;; Item 1: http://www.manicai.net/comp/swap-caps-ctrl.html

;;; Code:

;; Item 2
(global-set-key "\C-x\C-m" 'execute-extended-command)
(global-set-key "\C-c\C-m" 'execute-extended-command)


;; Item 3
(global-set-key "\C-w" 'backward-kill-word)
(global-set-key "\C-x\C-k" 'kill-region)
(global-set-key "\C-c\C-k" 'kill-region)


;; Item 4: Use C-r and C-s for navigation

;; Item 5: Use C-x b to create a temp buffer.
;;         Kill it with C-x k
;;         Write it with C-x C-w

;; Item 6: C-x 2   (split window)
;;         C-x 3   (horizontal split)
;;         C-x +   (balance windows)
;;         C-x o   (other window)
;;         C-x 1   (1 window)
;;         C-x C-b (buffer list)

;; Item 7
;;; I can't bring myself to lose the scroll bar.
;;; (if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))

;; Item 8: M-x describe-bindings
;;         M-x describe-key
;;         M-x apropos-command 
;;         M-x info.

;; Item 9
(global-set-key "\M-s" 'isearch-forward-regexp)
(global-set-key "\M-r" 'isearch-backward-regexp)

(defalias 'qrr 'query-replace-regexp)

;; Item 10: Ctrl-x (  (Start recording)
;;          Ctrl-x )  (Stop recording)
;;          Ctrl-x e  (call-last-kbd-macro)
(global-set-key [f5] 'call-last-kbd-macro)

;;          Alt-t     (transpose-words)
;;          Ctrl-t    (transpose-chars)
;;          C-x C-t   (transpose-lines)
;;          C-M-t     (transpose-sexps)

;; Thanks Steve Yegge!


;;; Libraries

(add-to-list 'load-path "~/elisp")


(setq-default indent-tabs-mode nil)


;;;

; http://emacs.stackexchange.com/a/642/2
(desktop-save-mode 1)
(savehist-mode 1)
(add-to-list 'savehist-additional-variables 'kill-ring) 

; http://www.emacswiki.org/emacs/AlignCommands
(defun align-repeat (start end regexp)
    "Repeat alignment with respect to 
     the given regular expression."
    (interactive "r\nsAlign regexp: ")
    (align-regexp start end 
        (concat "\\(\\s-*\\)" regexp) 1 1 t))

(defun align-right (start end)
    "Repeat alignment with respect to 
     the given regular expression."
    (interactive "r")
    (align-regexp start end 
        (concat "\\(\\s-*\\)\\([^ ]+\\)") -2 0 t))

(defun align-decimal (start end)
    "Align a table of numbers on (optional) decimal points."
    (interactive "r")
    (align-regexp start end "\\(\\s-*\\)\\$?\\(\\s-+[0-9]+\\)\\.?"
                  -2 0 t))


;;; H/T: https://stackoverflow.com/questions/31079204/emacs-package-install-script-in-init-file/31080940#31080940
(load "~/.emacs.d/init-packages")



;;; http://jblevins.org/projects/markdown-mode/
(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))


;; https://www.gnu.org/software/emacs/manual/html_node/emacs/Spelling.html
(add-hook 'text-mode-hook 'flyspell-mode)

;; https://www.emacswiki.org/emacs/CuaMode
(cua-mode t)

(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))

;; https://github.com/editorconfig/editorconfig-emacs#readme
(use-package editorconfig
  :ensure t
  :config
  (editorconfig-mode 1))

;;; Custom replacement functions

;; https://emacs.stackexchange.com/questions/249/how-to-search-and-replace-in-the-entire-buffer/253#253

(defun my/query-replace-regexp (regexp to-string &optional delimited start end)
  "Replace some things after point matching REGEXP with TO-STRING.  As each
match is found, the user must type a character saying what to do with
it. This is a modified version of the standard `query-replace-regexp'
function in `replace.el', This modified version defaults to operating on the
entire buffer instead of working only from POINT to the end of the
buffer. For more information, see the documentation of `query-replace-regexp'"
  (interactive
   (let ((common
          (query-replace-read-args
           (concat "Query replace"
                   (if current-prefix-arg " word" "")
                   " regexp"
                   (if (and transient-mark-mode mark-active) " in region" ""))
           t)))
     (list (nth 0 common) (nth 1 common) (nth 2 common)
           (if (and transient-mark-mode mark-active)
               (region-beginning)
             (buffer-end -1))
       (if (and transient-mark-mode mark-active)
           (region-end)
         (buffer-end 1)))))
  (perform-replace regexp to-string t t delimited nil nil start end))
;; Replace the default key mapping
;; But I don't actually want this.
; (define-key esc-map [?\C-%] 'my/query-replace-regexp)

(defun my/scrub-html ()
  "Replace things in HTML documents with the Markdown equivelent and kill annoying things I don't want."
  (interactive)
  (defun replace-all (regex to-string)
    (perform-replace regex to-string t t nil nil nil (point-min) (point-max)))
                                   
  (replace-all "<span [^>]*>" "")
  (replace-all "</span>" "" )
  (replace-all "</p>" "\n\n" )
  (replace-all "<p [^>]*>" "")
  (replace-all "<p>" "" )
  (replace-all "<br>" "\n\n" )
  (replace-all "</br>" "" )
  (replace-all "<br/>" "\n\n" )
  (replace-all "</h2>" "\n\n" )
  (replace-all "<h2>" "\n## " )
  (replace-all "</strong>" "**" )
  (replace-all "<strong>" "**" )
  (replace-all "</b>" "**" )
  (replace-all "<b>" "**" )
  (replace-all "</blockquote>" "\n\n" )
  (replace-all "<blockquote>" "> " )
  (replace-all "</em>" "_" )
  (replace-all "<em>" "_" )
  (replace-all "</i>" "_" )
  (replace-all "<i>" "_" )
  (replace-all "<!---->" "")

  (replace-all "<table [^>]*>" "")
  (replace-all "</table>" "")
  (replace-all "<tr [^>]*>" "")
  (replace-all "</tr>" "|")
  (replace-all "<th [^>]*>" "|")
  (replace-all "</th>" "|")
  (replace-all "<td [^>]*>" "|")
  (replace-all "</td>" "")
  (replace-all "<thead>" "")
  (replace-all "</thead>" "|---:|")
    (replace-all "<tbody [^>]*>" "")
  (replace-all "</tbody>" "")
  
  
  (replace-all "<a [^>]**href=\"\\([^\"]*\\)\"[^>]*>\\([^<]*\\)</a>" "[\\2](\\1)")
  
  (replace-all "…" "...")
  (replace-all "’" "'")
  (replace-all "[“”]" "\"")
  (replace-all " - " "&mdash;"))

;; https://www.emacswiki.org/emacs/UnwrapLine
(defun unwrap-line ()
      "Remove all newlines until we get to two consecutive ones.
    Or until we reach the end of the buffer.
    Great for unwrapping quotes before sending them on IRC."
      (interactive)
      (let ((start (point))
            (end (copy-marker (or (search-forward "\n\n" nil t)
                                  (point-max))))
            (fill-column (point-max)))
        (fill-region start end)
        (goto-char end)
        (newline)
        (goto-char start)))
  

(provide '.emacs)

;;; .emacs ends here

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(align-indent-before-aligning t)
 '(align-to-tab-stop nil)
 '(calendar-latitude 34.1808)
 '(calendar-longitude -118.309)
 '(ispell-program-name "/usr/local/bin/aspell")
 '(metar-units
   '((length . ft)
     (pressure . hPa)
     (speed . mph)
     (temperature . degF)))
 '(newsticker-url-list
   '(("Nate Silver" "http://fivethirtyeight.com/contributors/nate-silver/feed/" nil nil nil)))
 '(package-selected-packages
   '(yang-mode yaml-mode lua-mode editorconfig use-package metar markdown-mode)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
