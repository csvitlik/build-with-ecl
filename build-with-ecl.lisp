(require 'cmp)

(setq ext:*help-message* "
build-with-ecl [--help | -?] out-filename

    Build a standalone executable using Embeddable Common-Lisp.

    If the name of the program you want to build is \"ls.lisp\",
    you would build it like this:

    $ build-with-ecl ls
")

(defun build-program-wrapper (in-lisp in-o out)
  (compile-file in-lisp :system-p t)
  (c:build-program out :lisp-files in-o))

(defun main (args)
  (let ((in-file (first args)))
    (if (equalp in-file "-load")
	(setf in-file "build-with-ecl"))
    (let ((in-lisp (concatenate 'string in-file ".lisp"))
	  (in-o (concatenate 'string in-file ".o"))
	  (out in-file))
      (build-program-wrapper in-lisp (list in-o) out))))

(defun usage (rc)
  (progn
    (princ ext:*help-message* *standard-output*)
    (ext:quit rc)))

(defconstant +build-with-ecl-rules+
'(("--help" 0 (usage 0))
  ("-h" 0 (usage 0))
  ("-?" 0 (usage 0))
  ("*DEFAULT*" 1 (main 1) :stop)))

(let ((ext:*lisp-init-file-list* NIL)) ; No initialization files
  (handler-case (ext:process-command-args :rules +build-with-ecl-rules+)
    (error (c) (usage 1))))

(ext:quit 0)
