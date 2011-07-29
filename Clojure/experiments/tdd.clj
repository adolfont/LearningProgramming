;; Adolfo Neto, 2011
;; 03/02/2011, 29/07/2011

(use 'clojure.test)

(load-file "formula.clj")

(def t-and-example-1 '[T [& A B]])
(def t-and-example-2 '[T [& C D]])
(def f-or-example-1 '[F [| A B]])

(deftest getsign-test
  (is (= 'T (getsign t-and-example-1)))
  )

(deftest getconnective-test
  (is (= '& (getconnective t-and-example-1)))
  )

(deftest TAnd-test
  (is (= '[[T A] [T B]] (TAnd t-and-example-1)))
  (is (= '[[T C] [T D]] (TAnd t-and-example-2)))
  )

(deftest FOr-test
  (is (= '[[F A] [F B]] (FOr f-or-example-1)))
  )

;;(deftest getformula-test
;;  (is (= '[& A B] (getformula t-and-example)))) 
    

;;(deftest getleft-test
;;  (is (= 'A  (getleft '[& A B]))))

;;(deftest getright-test
;;  (is (= 'B (getright '[& A B]))))

;; test inverse calling

(run-tests)
