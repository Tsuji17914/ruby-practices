# frozen_string_literal: true

# !/usr/bin/env ruby

score = ARGV[0]
scores = score.split(',')
shots = []

scores.each do |s|
  shots << (s == 'X' ? 10 : s.to_i)
end

point = 0
i = 0

10.times.sum do
  if shots[i] == 10
    point += 10 + shots[(i + 1)..(i + 2)].sum
    i += 1
  elsif shots[i] + shots[i + 1] == 10
    point += 10 + shots[i + 2]
    i += 2
  else
    point += shots[(i)..(i + 1)].sum
    i += 2
  end
end

puts point
