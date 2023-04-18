;;; yewscion-0-theme.el --- Custom face theme for Emacs  -*- lexical-binding: t; -*-

;; Copyright (C) 2023  Christopher Rodriguez

;; Author: Christopher Rodriguez <>
;; Keywords: faces

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

;; 

;;; Code:

;;;###theme-autoload
(defgroup yewscion-themes-faces ()
  "Faces defined yewscion."
  :group 'faces
  :prefix "yewscion-"
  :tag "Yewscion Themes Faces")

(defconst yewscion-colors-blue "#346879")
(defconst yewscion-colors-cyan "#79d2d2")
(defconst yewscion-colors-orange "#ff8765")
(defconst yewscion-colors-green "#4ab581")
(defconst yewscion-colors-magenta "#a498b3")
(defconst yewscion-colors-red "#b44648")
(defconst yewscion-colors-yellow "#d7d693")
(defconst yewscion-colors-white "#ebe6e0")
(defconst yewscion-colors-black "#2e261f")
(defconst yewscion-colors-light-grey "#978c81")
(defconst yewscion-colors-dark-grey "#43382d")

;;;###theme-autoload
(deftheme yewscion-0
  "Yewscion's first GNU Emacs theme."
  :background-mode 'dark
  :kind 'color-scheme)
(let ((class '((class color) (min-colors 89))))
  (custom-theme-set-faces
   'yewscion-0
   ;; Ensure sufficient contrast on 256-color xterms.
   `(default ((((class color) (min-colors 4096))
	       (:background ,yewscion-colors-black :foreground ,yewscion-colors-white))
	      (,class
	       (:background ,yewscion-colors-black :foreground ,yewscion-colors-white))))
   `(cursor ((,class (:background ,yewscion-colors-light-grey))))
   ;; Highlighting faces
   `(fringe ((,class (:background ,yewscion-colors-dark-grey))))
   `(highlight ((,class (:background ,yewscion-colors-light-grey :foreground ,yewscion-colors-black))))
   `(region ((,class (:background ,yewscion-colors-light-grey :foreground ,yewscion-colors-white))))
   `(isearch ((,class (:background ,yewscion-colors-blue :foreground ,yewscion-colors-dark-grey))))
   `(lazy-highlight ((,class (:background ,yewscion-colors-dark-grey :foreground ,yewscion-colors-blue))))
   `(trailing-whitespace ((,class (:background ,yewscion-colors-orange)))) 
   ;; Mode line faces
   `(mode-line ((,class (:background ,yewscion-colors-light-grey :foreground ,yewscion-colors-dark-grey))))
   `(mode-line-inactive
     ((,class (:background ,yewscion-colors-dark-grey :foreground ,yewscion-colors-light-grey ))))
   `(header-line ((,class (:background ,yewscion-colors-light-grey :foreground ,yewscion-colors-dark-grey))))
   ;; Escape and prompt faces
   `(minibuffer-prompt ((,class (:foreground ,yewscion-colors-cyan :weight bold))))
   ;; Font lock faces
   `(font-lock-builtin-face ((,class (:foreground ,yewscion-colors-cyan))))
   `(font-lock-comment-face ((,class (:foreground ,yewscion-colors-green))))
   `(font-lock-constant-face ((,class (:foreground ,yewscion-colors-orange))))
   `(font-lock-function-name-face
     ((,class (:foreground ,yewscion-colors-yellow :weight bold))))
   `(font-lock-keyword-face ((,class (:foreground ,yewscion-colors-blue :weight bold))))
   `(font-lock-string-face ((,class (:foreground ,yewscion-colors-magenta))))
   `(font-lock-type-face ((,class (:foreground ,yewscion-colors-orange))))
   `(font-lock-variable-name-face ((,class (:foreground ,yewscion-colors-light-grey))))
   `(font-lock-warning-face ((,class (:foreground ,yewscion-colors-red :weight bold))))
   ;; Buttons and links
   `(button ((,class (:underline t))))
   `(link ((,class (:foreground ,yewscion-colors-blue :underline t))))
   `(link-visited ((,class (:foreground ,yewscion-colors-magenta :underline t))))
   ;; Message faces
   `(message-header-name ((,class (:foreground ,yewscion-colors-green :weight bold))))
   `(message-header-cc ((,class (:foreground ,yewscion-colors-light-grey))))
   `(message-header-other ((,class (:foreground ,yewscion-colors-light-grey))))
   `(message-header-subject ((,class (:foreground ,yewscion-colors-blue))))
   `(message-header-to ((,class (:foreground ,yewscion-colors-green))))
   `(message-cited-text ((,class (:foreground ,yewscion-colors-magenta))))
   `(message-separator ((,class (:foreground ,yewscion-colors-light-grey))))
   ;; Org
   `(org-level-1 ((,class (:foreground ,yewscion-colors-cyan))))
   `(org-level-2 ((,class (:foreground ,yewscion-colors-orange))))
   `(org-level-3 ((,class (:foreground ,yewscion-colors-green))))
   `(org-level-4 ((,class (:foreground ,yewscion-colors-yellow))))
   `(org-level-5 ((,class (:foreground ,yewscion-colors-blue))))
   `(org-level-6 ((,class (:foreground ,yewscion-colors-red))))
   ;; Magit
   `(magit-section-highlight ((,class (:background ,yewscion-colors-dark-grey))))
   `(magit-diff-file-heading ((,class (:weight bold))))
   `(magit-diff-file-heading-highlight ((,class (:background ,yewscion-colors-dark-grey :foreground ,yewscion-colors-light-grey))))
   `(magit-diff-file-heading-selection ((,class (:background ,yewscion-colors-dark-grey :foreground ,yewscion-colors-orange))))
   `(magit-diff-hunk-heading ((,class (:background ,yewscion-colors-dark-grey :foreground ,yewscion-colors-light-grey))))
   `(magit-diff-hunk-heading-highlight ((,class (:background ,yewscion-colors-light-grey :foreground ,yewscion-colors-dark-grey))))
   `(magit-diff-hunk-heading-selection ((,class (:background ,yewscion-colors-dark-grey :foreground ,yewscion-colors-orange))))
   `(magit-diff-hunk-region ((,class (:weight bold))))
   `(magit-diff-revision-summary ((,class (:inherit magit-diff-hunk-heading))))
   `(magit-diff-revision-summary-highlight ((,class (:inherit magit-diff-hunk-heading-highlight))))
   `(magit-diff-lines-heading ((,class (:background ,yewscion-colors-orange :foreground ,yewscion-colors-dark-grey))))
   `(magit-diff-lines-boundary ((,class (:inherit magit-diff-lines-heading))))
   `(magit-diff-conflict-heading ((,class (:inherit magit-diff-hunk-heading))))
   `(magit-diff-added ((,class (:foreground ,yewscion-colors-green))))
   `(magit-diff-removed ((,class (:foreground ,yewscion-colors-red))))
   `(magit-diff-our ((,class (:inherit magit-diff-removed))))
   `(magit-diff-base ((,class (:foreground ,yewscion-colors-yellow))))
   `(magit-diff-their ((,class (:inherit magit-diff-added))))
   `(magit-diff-context ((,class (:background ,yewscion-colors-black :foreground ,yewscion-colors-light-grey))))
   `(magit-diff-added-highlight ((,class (:background ,yewscion-colors-green :foreground ,yewscion-colors-dark-grey))))
   `(magit-diff-removed-highlight ((,class (:background ,yewscion-colors-red :foreground ,yewscion-colors-dark-grey))))
   `(magit-diff-our-highlight ((,class (:inherit magit-diff-removed-highlight))))
   `(magit-diff-base-highlight ((,class (:background ,yewscion-colors-yellow :foreground ,yewscion-colors-dark-grey))))
   `(magit-diff-their-highlight ((,class (:inherit magit-diff-added-highlight))))
   `(magit-diff-context-highlight ((,class (:background ,yewscion-colors-dark-grey :foreground ,yewscion-colors-light-grey))))
   `(magit-diff-whitespace-warning ((,class (:background ,yewscion-colors-orange))))
   `(magit-diffstat-added ((,class (:foreground ,yewscion-colors-green))))
   `(magit-diffstat-removed ((,class (:foreground ,yewscion-colors-red))))
   ;; Elfeed
   `(elfeed-log-date-face ((,class (:foreground ,yewscion-colors-yellow))))
   `(elfeed-log-error-level-face ((,class (:foreground ,yewscion-colors-red))))
   `(elfeed-log-warn-level-face ((,class (:foreground ,yewscion-colors-orange))))
   `(elfeed-log-info-level-face ((,class (:foreground ,yewscion-colors-cyan))))
   `(elfeed-log-debug-level-face ((,class (:foreground ,yewscion-colors-blue))))
   `(elfeed-search-date-face ((,class (:foreground ,yewscion-colors-yellow))))
   `(elfeed-search-title-face ((,class (:foreground ,yewscion-colors-light-grey))))
   `(elfeed-search-unread-title-face ((,class (:foreground ,yewscion-colors-green))))
   `(elfeed-search-feed-face ((,class (:foreground ,yewscion-colors-cyan))))
   `(elfeed-search-tag-face ((,class (:foreground ,yewscion-colors-blue))))
   `(elfeed-search-last-update-face ((,class (:foreground ,yewscion-colors-cyan))))
   `(elfeed-search-filter-face ((,class (:foreground ,yewscion-colors-cyan))))
   ;; Ebib
   `(ebib-highlight-extend-face ((,class (:inherit highlight
                                                   ,@(and (>= emacs-major-version 27) '(:extend t))))))
   `(ebib-highlight-face ((,class (:inherit highlight))))
   `(ebib-crossref-face ((,class (:foreground ,yewscion-colors-light-grey))))
   `(ebib-alias-face ((,class (:foreground ,yewscion-colors-orange))))
   `(ebib-abbrev-face ((,class (:foreground ,yewscion-colors-cyan))))
   `(ebib-marked-face ((,class (:background ,yewscion-colors-light-grey :foreground ,yewscion-colors-black))))
   `(ebib-modified-face ((,class (:foreground ,yewscion-colors-orange))))
   `(ebib-field-face ((,class (:foreground ,yewscion-colors-blue))))
   `(ebib-warning-face ((,class (:foreground ,yewscion-colors-red))))
   `(ebib-link-face ((,class (:foreground ,yewscion-colors-magenta))))
   `(ebib-display-author-face ((,class (:foreground ,yewscion-colors-cyan))))
   `(ebib-display-year-face ((,class (:foreground ,yewscion-colors-blue))))
   `(ebib-display-bibfile-face ((,class (:foreground ,yewscion-colors-green))))
   ;; Dired   
   `(dired-header ((,class (:foreground ,yewscion-colors-blue))))
   `(dired-mark ((,class (:foreground ,yewscion-colors-magenta))))
   `(dired-marked ((,class (:background ,yewscion-colors-light-grey :foreground ,yewscion-colors-black))))
   `(dired-flagged ((,class (:foreground ,yewscion-colors-dark-grey :background ,yewscion-colors-orange))))
   `(dired-warning ((,class (:foreground ,yewscion-colors-orange))))
   `(dired-perm-write ((,class (:foreground ,yewscion-colors-green))))
   `(dired-set-id ((,class (:foreground ,yewscion-colors-orange))))
   `(dired-directory ((,class (:foreground ,yewscion-colors-cyan))))
   `(dired-symlink ((,class (:foreground ,yewscion-colors-magenta))))
   `(dired-broken-symlink ((,class (:foreground ,yewscion-colors-red))))
   `(dired-special ((,class (:foreground ,yewscion-colors-blue))))
   `(dired-ignored ((,class (:foreground ,yewscion-colors-light-grey))))
   ))
(provide-theme 'yewscion-0)
;;; yewscion-0-theme.el  ends here
