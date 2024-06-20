(1..20).each do |x|
  case 
  when x % 3 == 0
    puts "Fizz"
  when x % 5 == 0
    puts "Buzz"
  when x % 15 == 0
    puts "FizzBuzz"
  else
    puts x
  end
end
