(1..20).each do |x|
  if x % 3 == 0
    puts 'Fizz'
  elsif x % 5 == 0
    puts 'Buzz'
  elsif x % 15 == 0
    puts 'FizzBuzz'
  else
    puts x
  end
end
