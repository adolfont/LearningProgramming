(defrecord Literal [value])

(def literal-1 (Literal. -1))
(def literal-2 (Literal. +2))

(defrecord Clause [literal-list])

(def aClause (Clause. [literal-1 literal-2]))

(println aClause)
