 IO.puts "Silly program that adds two integers"
 IO.puts "Adolfo Gustavo Serra-Seca-Neto, June 26th, 2015"
 IO.puts ""

 result = Integer.parse IO.gets "Type an integer value for x: "
 if result != :error do
     {x, _} = result  
   else 
     IO.puts "Error! x will be zero."
     x = 0
 end  
 IO.puts "x = " <> to_string(x)
  
 result = Integer.parse IO.gets "Type an integer value for y: "
 if result != :error do
     {y, _} = result  
   else 
     IO.puts "Error! y will be zero."
     y = 0
 end  
 IO.puts "y = " <> to_string(y)

 z = x + y
 
 IO.puts ""
 IO.puts "Calculating x + y"
 
 IO.puts (to_string(x)<>" + "<> to_string(y) <>" is " <> to_string(z))
