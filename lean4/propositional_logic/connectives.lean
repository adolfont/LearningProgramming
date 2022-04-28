def implication (a b : Bool) :=
match b with
| true => true
| false => match a with 
            |  false => true
            |  true => false


#eval println! "true or false"
#eval or true false 
#eval println! "true and false"
#eval and true false 
#eval println! "not true"
#eval not true  
#eval println! "Implication Truth Table"
#eval println! "true -> true"
#eval implication true true
#eval println! "true -> false"
#eval implication true false
#eval println! "falase -> true"
#eval implication false true
#eval println! "false -> false"
#eval implication false false
