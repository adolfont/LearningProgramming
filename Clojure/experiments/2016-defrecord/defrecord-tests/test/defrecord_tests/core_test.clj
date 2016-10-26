(ns defrecord-tests.core-test
  (:require [clojure.test :refer :all]
            [defrecord-tests.core :refer (->Literal literal-value
                                      ->Clause clause-value)]))

(deftest literal-test
  (def aLiteral (->Literal -1))
  (is (= -1 (literal-value aLiteral)))
)

(deftest clause-test
  (def aLiteral1 (->Literal -1))
  (def aLiteral2 (->Literal +2))
  (def aClause (->Clause #{aLiteral1 aLiteral2}))
  (is (= #{aLiteral1 aLiteral2} (clause-value aClause)))
)
