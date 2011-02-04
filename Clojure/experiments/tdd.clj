;; Adolfo Neto, 2011
;; 03/02/2011

(use 'clojure.test)

(load-file "formula.clj")

(def t-and-example '[T [& A B]])
(def t-and-example-2 '[T [& C D]])

;;(deftest getsign-test
;;  (is (= 'T (getsign t-and-example)))
;;  )

;;(deftest getconnective-test
;;  (is (= '& (getconnective t-and-example)))
;;  )

(deftest tand-test
  (is (= '[[T A] [T B]] (TAnd t-and-example)))
  (is (= '[[T C] [T D]] (TAnd t-and-example-2)))
  )

;;(deftest getformula-test
;;  (is (= '[& A B] (getformula t-and-example)))) 
    

;;(deftest getleft-test
;;  (is (= 'A  (getleft '[& A B]))))

;;(deftest getright-test
;;  (is (= 'B (getright '[& A B]))))

;; test inverse calling

(run-tests)
