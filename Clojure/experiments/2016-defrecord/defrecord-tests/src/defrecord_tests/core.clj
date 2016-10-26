(ns defrecord-tests.core
  (:gen-class))

(defn -main
  "I don't do a whole lot ... yet."
  [& args]
  (println "Hello, World!"))

(defrecord Literal [value])

(defn literal-value [aLiteral]
  (:value aLiteral))

(defrecord Clause [literal-set])

(defn clause-value [aClause]
  (:literal-set aClause))
