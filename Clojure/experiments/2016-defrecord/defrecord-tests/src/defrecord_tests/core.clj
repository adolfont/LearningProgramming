(ns defrecord-tests.core
  (:gen-class))

(defn -main
  "I don't do a whole lot ... yet."
  [& args]
  (println "Hello, World!"))

(defrecord Literal [value])

(def literal-1 (Literal. -1))
(def literal-2 (Literal. +2))

(defn literal-value [aLiteral]
  (:value aLiteral))

(defrecord Clause [literal-list])

(def aClause (Clause. [literal-1 literal-2]))
