;; Tests for an implementation of Smullyan's Signed Analytic Tableaux for Classical Proposistional Logic
;; Adolfo Neto, 2011
;; 03/02/2011, 29/07/2011

(use 'clojure.test)

(load-file "analyticTableaux.clj")

(def t-and-example-1 '[T [& A B]])
(def t-and-example-2 '[T [& C D]])
(def f-or-example-1 '[F [| A B]])
(def f-implies-example-1 '[F [-> A B]])
(def t-not-example '[T [! A]])
(def f-not-example '[F [! A]])
(def f-and-example '[F [& A B]])
(def t-or-example '[T [| A B]])
(def t-implies-example '[T [-> A B]])

(deftest getsign-test
  (is (= 'T (getsign t-and-example-1)))
  )

(deftest getconnective-test
  (is (= '& (getconnective t-and-example-1)))
  )

;; one premise two conclusions rules
(deftest TAnd-test
  (is (= '[[T A] [T B]] (TAnd t-and-example-1)))
  (is (= '[[T C] [T D]] (TAnd t-and-example-2)))
  )

(deftest FOr-test
  (is (= '[[F A] [F B]] (FOr f-or-example-1)))
  )


(deftest FImplies-test
  (is (= '[[T A] [F B]] (FImplies f-implies-example-1)))
  )

;; one premise one conclusion rules
(deftest TNot-test
  (is (= '[[F A]] (TNot t-not-example)))
  )

(deftest FNot-test
  (is (= '[[T A]] (FNot f-not-example)))
  )

;; one premise two branches rules
(deftest FAnd-test
  (is (= '([[F A]] [[F B]]) (FAnd f-and-example)))
  )

(deftest TOr-test
  (is (= '([[T A]] [[T B]]) (TOr t-or-example)))
  )

(deftest TImplies-test
  (is (= '([[F A]] [[T B]]) (TImplies t-implies-example)))
  )




;;(deftest getformula-test
;;  (is (= '[& A B] (getformula t-and-example)))) 
    

;;(deftest getleft-test
;;  (is (= 'A  (getleft '[& A B]))))

;;(deftest getright-test
;;  (is (= 'B (getright '[& A B]))))

;; test inverse calling

(run-tests)
