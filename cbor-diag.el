;;; cbor-diag.el --- convert CBOR to YAML for editing  -*- lexical-binding: t; -*-

;; Copyright (C) 2018  Carsten Bormann

;; Author: Carsten Bormann <cabo@tzi.org>
;; Keywords: cbor, yaml

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; Load this file to automatically convert CBOR to YAML on edit (and back on writing).
;; Requires the cbor-diag gem to be installed.

;;; Code:

(add-to-list 'jka-compr-compression-info-list
             ["\\.cbor$"
              "converting YAML to CBOR"
              "yaml2cbor.rb"
              ()
              "converting CBOR to YAML"
              "cbor2yaml.rb"
              ()
              nil nil ""])

(provide 'cbor-diag)
;;; cbor-diag.el ends here
