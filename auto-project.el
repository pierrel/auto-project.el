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

(defgroup auto-project ()
  "Customize group for git-project-list.el"
  :group 'lisp
  :prefix "auto-project")

(defun auto-project-config-file ()
  (with-project-root
      (concat default-directory ".emacs-config.el")))

(defun auto-project-has-config-p ()
  (file-regular-p (auto-project-config-file)))

(defun auto-project-load-config ()
  (ignore-errors
    (if (auto-project-has-config-p)
        (load-file (auto-project-config-file)))))

(add-to-list 'find-file-hook 'auto-project-load-config)
