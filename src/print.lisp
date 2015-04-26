;;;; print-object methods for nodes
(in-package :docparser)

;;; Common Lisp classes

(defmethod print-object ((symbol symbol-node) stream)
  "Print a symbol node."
  (print-unreadable-object (symbol stream)
    (format stream "symbol ~A" (render-humanize symbol))))

(defmethod print-object ((operator operator-node) stream)
  "Print an operator node."
  (print-unreadable-object (operator stream)
    (format stream "~A ~A ~A"
            (typecase operator
              (function-node "function")
              (macro-node "macro")
              (generic-function-node "generic function")
              (method-node "method")
              (t "operator"))
            (let ((name (node-name operator)))
              (if (symbol-setf-p name)
                  (format nil "(setf ~A)" (render-humanize name))
                  (render-humanize name)))
            (operator-lambda-list operator))))

(defmethod print-object ((var variable-node) stream)
  "Print a variable node."
  (print-unreadable-object (var stream)
    (format stream "variable ~A" (render-humanize (node-name var)))))

(defmethod print-object ((struct struct-node) stream)
  "Print a struct definition node."
  (print-unreadable-object (struct stream)
    (format stream "struct ~A" (render-humanize (node-name struct)))))

(defmethod print-object ((class class-node) stream)
  "Print a class definition node."
  (print-unreadable-object (class stream)
    (format stream "class ~A" (render-humanize (node-name class)))))

(defmethod print-object ((type type-node) stream)
  "Print a type definition node."
  (print-unreadable-object (type stream)
    (format stream "type ~A" (render-humanize (node-name type)))))

;;; CFFI classes

(defmethod print-object ((function cffi-function) stream)
  "Print a CFFI function node.")

(defmethod print-object ((type cffi-type) stream)
  "Print a CFFI type definition node."
  (print-unreadable-object (type stream)
    (format stream "defctype ~A (~A)"
            (render-humanize (node-name type))
            (prin1-to-string (cffi-type-base-type type)))))

(defmethod print-object ((struct cffi-struct) stream)
  "Print a CFFI struct definition node.")

(defmethod print-object ((union cffi-union) stream)
  "Print a CFFI union definition node.")

(defmethod print-object ((enum cffi-enum) stream)
  "Print a CFFI enum definition node."
  (print-unreadable-object (enum stream)
    (format stream "defcenum ~A (~{~A~#[~:;, ~]~})"
            (render-humanize (node-name enum))
            (cffi-enum-variants enum))))