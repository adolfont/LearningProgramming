;; Tests for an implementation of Smullyan's Signed Analytic Tableaux for Classical Proposistional Logic
;; Adolfo Neto, 2011
;; 03/02/2011, 29/07/2011

(use 'clojure.test)

(load-file "analyticTableaux.clj")

(def f-or-example-1 '[F [| A B]])
(def f-implies-example-1 '[F [-> A B]])
(def t-not-example '[T [! A]])
(def f-not-example '[F [! A]])
(def f-and-example '[F [& A B]])
(def t-or-example '[T [| A B]])
(def t-implies-example '[T [-> A B]])


;; one premise two conclusions rules

(def t-and-example-1 '[T [& A B]])
(def result-t-and-example-1 '([T A] [T B]) )

(def t-and-example-2 '[T [& C D]])
(def result-t-and-example-2 '([T C] [T D]) )

(deftest TAnd-test
  (is (= result-t-and-example-1 (TAnd t-and-example-1)))
  (is (= result-t-and-example-2 (TAnd t-and-example-2)))
  )

(deftest FOr-test
  (is (= '([F A] [F B]) (FOr f-or-example-1)))
  )


(deftest FImplies-test
  (is (= '([T A] [F B]) (FImplies f-implies-example-1)))
  )

;; one premise one conclusion rules
(deftest TNot-test
  (is (= '([F A]) (TNot t-not-example)))
  )

(deftest FNot-test
  (is (= '([T A]) (FNot f-not-example)))
  )

;; one premise two branches rules
(deftest FAnd-test
  (is (= '(([F A]) ([F B])) (FAnd f-and-example)))
  )

(deftest TOr-test
  (is (= '(([T A]) ([T B])) (TOr t-or-example)))
  )

(deftest TImplies-test
  (is (= '(([F A]) ([T B])) (TImplies t-implies-example)))
  )


;;(def sample-branch-1 (list t-and-example-1 t-and-example-2))
;;(def result-sample-branch-1 (list result-t-and-example-1 result-t-and-example-2))

;;applying the rules on a branch
;;(deftest applyRulesTest
  ;;(is (= result-sample-branch-1 (applyAllRules sample-branch-1))))



(deftest getsign-test
  (is (= 'T (getsign t-and-example-1)))
  )

(deftest getconnective-test
  (is (= '& (getconnective t-and-example-1)))
  )


(run-tests)
