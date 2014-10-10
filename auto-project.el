;;; auto-project.el --- Loads modes based on git project

;; Copyright (C) 2014 Pierre Larochelle

;; Author: Pierre Larochelle <pierre@larochelle.io>
;; Version: 2.9.0
;; Keywords: lists

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; A way to load modes based on git project
;;
;; See documentation on https://github.com/pierrel/git-project-list

;;; Code:

(require 'project-root)
(require 'dash)

(defgroup auto-project ()
  "Customize group for git-project-list.el"
  :group 'lisp
  :prefix "auto-project")

(require 'dash)

(defvar auto-project-mode-alist '())

(defun auto-project-root-config-path ()
  (with-project-root
      (concat default-directory ".git/config")))

(defun auto-project-config-file ()
  (let ((config-path (auto-project-root-config-path)))
    (if (file-regular-p (or config-path ""))
        config-path)))

(defun auto-project-file-has-string-p (file s)
  (with-temp-buffer
    (insert-file-contents file)
    (search-forward s nil t)))

(defun auto-project-matching-modes ()
  (let ((current-config (auto-project-config-file)))
    (if current-config
        (-map 'cdr 
              (--filter (auto-project-file-has-string-p current-config (car it))
                        auto-project-mode-alist))
      '())))

(defun auto-project-enable-modes (modes)
  (-each (lambda (new-mode)
           (new-mode))
    modes))

(defun auto-project-add-hooks ()
  (auto-project-enable-modes (auto-project-matching-modes)))

(add-to-list 'find-file-hook 'auto-project-add-hooks)

;; for testing
(add-to-list 'auto-project-mode-alist '("blurb/blurby.git" . blurb-mode))

