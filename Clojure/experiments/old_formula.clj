;; Adolfo Neto, 2011
;; A signed formula will be represented as
	;; (SIGN (CONECTIVE formula))
;; I am not representing atomic formulas yet...


(defn TAnd
  "Applies the T-AND rule to the formula.
   Example: T A&B ==> T A, T B
   "
  [[sign [connective left right]]]
  (if (and
       (= sign 'T)
       (= connective '&)
       )
    (vector
     (vector 'T left)
     (vector 'T right)
     )
    'nil)
  )
