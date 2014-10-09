;;; git-project-list.el --- Loads modes based on git project

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

(defgroup git-project-list ()
  "Customize group for git-project-list.el"
  :group 'lisp
  :prefix "gitlist")

(require 'dash)

(defvar gitlist-auto-mode-alist '())

(defun gitlist-root-config-path ()
  (ignore-errors (with-project-root
                     (concat default-directory ".git/config"))))

(defun gitlist-config-file ()
  (let ((config-path (gitlist-root-config-path)))
    (if (file-regular-p (or config-path ""))
        config-path)))

(defun gitlist-file-has-string-p (file s)
  (with-temp-buffer
    (insert-file-contents file)
    (search-forward s nil t)))

(defun gitlist-matching-modes ()
  (let ((current-config (gitlist-config-file)))
    (if current-config
        (--filter (gitlist-file-has-string-p current-config (car it))
                                   gitlist-auto-mode-alist)
      '())))

(defun gitlist-add-hooks ()
  ;; only prints matching alists
  (message (format "%s" (gitlist-matching-modes))))

;; for testing
(add-to-list 'gitlist-auto-mode-alist '("blurb/blurby.git" . blurb))





