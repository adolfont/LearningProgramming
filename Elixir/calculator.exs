 IO.puts "Silly program that adds two integers"
 IO.puts "Adolfo Gustavo Serra-Seca-Neto, June 26th, 2015"
 IO.puts ""

 {x, _} = Integer.parse IO.gets "Type an integer value for x: "
 {y, _} = Integer.parse IO.gets "Type an integer value for y: "
 
 z = x + y
 
 IO.puts ""
 
 IO.puts (to_string(x)<>" + "<> to_string(y) <>" is " <> to_string(z))
