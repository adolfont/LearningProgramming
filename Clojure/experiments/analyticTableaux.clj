;; Tests for an implementation of Smullyan's Signed Analytic Tableaux for Classical Proposistional Logic
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

(defn OnePremiseTwoConclusionsSignedRule
  [premiseSign premiseConnective leftConclusionSign rightConclusionSign]
  (fn [sign [connective left right]] 
    (def wholeFormula [sign [connective left right]])
    (if (and
       (= sign premiseSign)
       (= connective premiseConnective)
       )
    (list
     (vector leftConclusionSign left)
     (vector rightConclusionSign right)
     )
    wholeFormula)
 )
)

(defn OnePremiseOneConclusionSignedRule
  [premiseSign premiseConnective conclusionSign]
  (fn [sign [connective formula]] 
   (def wholeFormula [sign [connective formula]]) 
   (if (and
       (= sign premiseSign)
       (= connective premiseConnective)
       )
    (list
     (vector conclusionSign formula)
     )
    wholeFormula)
 )
)

(defn OnePremiseTwoBranchedConclusionsSignedRule
  [premiseSign premiseConnective leftConclusionSign rightConclusionSign]
  (fn [sign [connective left right]] 
    (def wholeFormula [sign [connective left right]])
    (if (and
       (= sign premiseSign)
       (= connective premiseConnective)
       )
    (list 
     (list (vector leftConclusionSign left))
     (list (vector rightConclusionSign right))
     )
    wholeFormula)
 )
)

(defn TAnd
  "Applies the T-AND rule to the formula.
   Example: T A&B ==> T A, T B"
   [signedFormula] 
   (apply (OnePremiseTwoConclusionsSignedRule 'T '& 'T 'T)  signedFormula))


(defn FOr 
  "Applies the F-OR rule to the formula.
   Example: F A|B ==> F A, F B"
  [signedFormula] 
  (apply (OnePremiseTwoConclusionsSignedRule 'F '| 'F 'F)  signedFormula))

(defn FImplies
  "Applies the F-Implies rule to the formula.
   Example: F A->B ==> T A, F B"
  [signedFormula] 
  (apply (OnePremiseTwoConclusionsSignedRule 'F '-> 'T 'F)  signedFormula))

(defn TNot
  "Applies the T-Not rule to the formula.
   Example: T !A ==> F A"
  [signedFormula] 
  (apply (OnePremiseOneConclusionSignedRule 'T '! 'F)  signedFormula))

(defn FNot
  "Applies the F-Not rule to the formula.
   Example: F !A ==> T A"
  [signedFormula] 
  (apply (OnePremiseOneConclusionSignedRule 'F '! 'T)  signedFormula))

(defn FAnd
  "Applies the F-And rule to the formula.
   Example: [F A&B] ==> ( [F A]  [F B] )"
  [signedFormula] 
  (apply (OnePremiseTwoBranchedConclusionsSignedRule 'F '& 'F 'F)  signedFormula))

(defn TOr
  "Applies the T-Or rule to the formula.
   Example: [T A|B] ==> ( [T A]  [T B] )"
  [signedFormula] 
  (apply (OnePremiseTwoBranchedConclusionsSignedRule 'T '| 'T 'T)  signedFormula))

(defn TImplies
  "Applies the T-Implies rule to the formula.
   Example: [T A->B] ==> ( [F A]  [T B] )"
  [signedFormula] 
  (apply (OnePremiseTwoBranchedConclusionsSignedRule 'T '-> 'F 'T)  signedFormula))


(defn applyAllRules 
   "Applies all rules to a branch and returns the resulting branch" 
   [branch]
   (apply concat (map TAnd branch)))
