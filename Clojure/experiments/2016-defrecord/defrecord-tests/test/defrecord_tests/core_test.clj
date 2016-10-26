(ns defrecord-tests.core-test
  (:require [clojure.test :refer :all]
            [defrecord-tests.core :refer (->Literal literal-value)]))

(deftest aTest
  (def aLiteral (->Literal -1))
  (is (= -1 (literal-value aLiteral)))
)
