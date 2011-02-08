(defprotocol Bussola
  (direcao [c])
  (esquerda [c])
  (direita [c]))

(def direcoes [:norte :leste :sul :oeste])

(defn vira
  [base quantidade]
  (rem (+ base quantidade) (count direcoes)))

;; testes no REPL

;;(vira 1 1)
;;2
;;(vira 3 1)
;;0
;;(vira 2 3)
;;1

(defrecord BussolaSimples [rolamento]
  Bussola
  (direcao [_] (direcoes rolamento))
  (esquerda [_] (BussolaSimples. (vira rolamento 3)))
  (direita [_] (BussolaSimples. (vira rolamento 1)))
  Object (toString [this] (str "[" (direcao this) "]")))


;; testes no REPL
;; (def b (BussolaSimples. 0))
;;user> (esquerda b)
;;#:user.BussolaSimples{:rolamento 3}
;;user> b
;;#:user.BussolaSimples{:rolamento 0}
;;(:rolamento b)
;;0

;;;;; macros

(defmacro unless [test body]
  (list 'if (list 'not test) body))


