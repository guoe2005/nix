(let (;; 加载的时候临时增大`gc-cons-threshold'以加速启动速度。
      (gc-cons-threshold most-positive-fixnum)
      ;; 清空避免加载远程文件的时候分析文件。
      (file-name-handler-alist nil))
  (add-to-list 'load-path (expand-file-name "site-lisp" user-emacs-directory))

  ;(require 'init-benchmarking)
  ;(require 'benchmark-init-modes)
  ;(require 'benchmark-init)
  ;(benchmark-init/activate)
    ;; Emacs配置文件内容写到下面.
  ;;(setq package-enable-at-startup nil)
 ;; (setq package-archives '(("melpa-cn" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")
 ;; 			   ("org-cn"   . "http://mirrors.tuna.tsinghua.edu.cn/elpa/org/")
 ;; 			   ("gnu-cn"   . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")))
  (setq package-archives '(("gnu"   . "http://elpa.emacs-china.org/gnu/")
                           ("melpa" . "http://elpa.emacs-china.org/melpa/")))
  (package-initialize)
  ;;custome-file
  (setq custom-file (expand-file-name "custom.el" user-emacs-directory))
  ;;(load custom-file 'noerror)

  (unless (package-installed-p 'use-package)
    (package-refresh-contents)
    (package-install 'use-package))
  (require 'use-package)
  (use-package diminish :ensure t)
  ;;启用server-start
  (require 'server)
  (unless (server-running-p) (server-start))
  ;(use-package server :ensure t
  ;  :config
  ;  (unless (server-running-p)
  ;  (server-start)))

  (use-package recentf
  ;; Loads after 1 second of idle time.
  :defer 1)
  (require 'setup-appearance)
  (require 'setup-core)
  (require 'setup-cnfonts)
  ;;(require 'setup-deft)
  (require 'setup-org)
  ;;(autoload 'helm-bibtex "helm-bibtex" "" t)
  (require 'setup-org-bibtex)
  (require 'setup-evil)
  (require 'setup-keys)
  (require 'setup-helm)
  (require 'setup-which-key)
  (require 'setup-window-numbering)
  ;;;;;(require 'setup-sr-speedbar)
  (require 'setup-yasnippet)
  (require 'setup-auto-save)
  (require 'setup-translate)
  ;;(require 'setup-company)
  ;(add-to-list 'load-path "~/.emacs.d/site-lisp/snails") ; add snails to your load-path
  ;(require 'snails)
  ;(add-to-list 'load-path (expand-file-name "~/.emacs.d/site-lisp/company-english-helper"))
  ;(require 'company-english-helper)

  ;(add-to-list 'load-path (expand-file-name "~/.emacs.d/site-lisp/insert-translated-name"))
  ;(require 'insert-translated-name)

  ;;(add-to-list 'load-path "~/.emacs.d/site-lisp/toc-org")
  ;;(if (require 'toc-org nil t)
  ;;    (add-hook 'org-mode-hook 'toc-org-mode)
  ;;  (warn "toc-org not found"))
  ;; Load custom settings
  ;(load custom-file 'noerror)
)
