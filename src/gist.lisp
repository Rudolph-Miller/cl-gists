(in-package :cl-user)
(defpackage cl-gists.gist
  (:use :cl
        :annot.doc
        :cl-gists.util
        :cl-gists.user
        :cl-gists.file
        :cl-gists.fork
        :cl-gists.history)
  (:import-from :local-time
                :timestamp
                :parse-timestring)
  (:export :cl-gists.gist
           :gist
           :gist-url
           :gist-forks-url
           :gist-commits-url
           :gist-id
           :gist-description
           :gist-public
           :gist-owner
           :gist-user
           :gist-files
           :gist-comments
           :gist-comments-url
           :gist-html-url
           :gist-git-pull-url
           :gist-git-push-url
           :gist-created-at
           :gist-updated-at
           :gist-forks
           :gist-history
           :make-gist
           :make-gist-from-json
           :make-gists-from-json))
(in-package :cl-gists.gist)

(syntax:use-syntax :annot)

@doc
"Structure of Gist"
(defstruct (gist (:constructor %make-gist))
  (url nil :type (or null string))
  (forks-url nil :type (or null string))
  (commits-url nil :type (or null string))
  (id nil :type (or null string))
  (description nil :type (or null string))
  (public nil :type boolean)
  (owner nil :type (or null user))
  (user nil) ;; Not sure what kind of object.
  (files nil :type list) ;; List of file.
  (comments nil :type (or null integer))
  (comments-url nil :type (or null string))
  (html-url nil :type (or null string))
  (git-pull-url nil :type (or null string))
  (git-push-url nil :type (or null string))
  (created-at nil :type (or null timestamp))
  (updated-at nil :type (or null timestamp))
  (forks nil :type list)
  (history nil :type list))

(defun make-gist (&key url forks-url commits-url id description public owner user files comments
                    comments-url html-url git-pull-url git-push-url created-at updated-at forks history)
  (%make-gist :url url
              :forks-url forks-url
              :commits-url commits-url
              :id id
              :description description
              :public public
              :owner (apply #'make-user owner)
              :user user
              :files (make-files files)
              :comments comments
              :comments-url comments-url
              :html-url html-url
              :git-pull-url git-pull-url
              :git-push-url git-push-url
              :created-at (and created-at (parse-timestring created-at))
              :updated-at (and updated-at (parse-timestring updated-at))
              :forks (make-forks forks)
              :history (make-histories history)))

(defun make-gist-from-json (json)
  (apply #'make-gist (parse-json json)))

(defun make-gists-from-json (json)
  (mapcar #'(lambda (plist) (apply #'make-gist plist)) (parse-json json)))
