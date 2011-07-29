;; Adolfo Neto, 2011
;; A signed formula will be represented as
	;; [SIGN [CONECTIVE subformulas]]
;; I am not representing atomic formulas yet...


(defn getsign [formula]
  "gets the sign of a signed formula"
  (first formula)
)

(defn getconnective [formula]
  "gets the main connective of the signed formula"
  (first (second formula))
)

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

(comment
(defn FOr
  "Applies the F-OR rule to the formula.
   Example: F A|B ==> F A, F B
   "
  [[sign [connective left right]]]
  (if (and
       (= sign 'F)
       (= connective '|)
       )
    (vector
     (vector 'F left)
     (vector 'F right)
     )
    'nil)
  )
)

(defn OnePremiseTwoConclusionsSignedRule
  [premiseSign premiseConnective leftConclusionSign rightConclusionSign]
  (fn [sign [connective left right]] (if (and
       (= sign premiseSign)
       (= connective premiseConnective)
       )
    (vector
     (vector leftConclusionSign left)
     (vector rightConclusionSign right)
     )
    'nil)
 )
)

(defn FOr [signedFormula] (apply (OnePremiseTwoConclusionsSignedRule 'F '| 'F 'F)  signedFormula))

