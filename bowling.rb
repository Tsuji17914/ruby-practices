# frozen_string_literal: true

# !/usr/bin/env ruby

score = ARGV[0]
scores = score.split(',')
shots = []

scores.each do |s|
  shots << (s == 'X' ? 10 : s.to_i)
end

i = 0

point = 10.times.sum do
  if shots[i] == 10
    frame_score = 10 + shots[i + 1] + shots[i + 2]
    i += 1
  elsif shots[i] + shots[i + 1] == 10
    frame_score = 10 + shots[i + 2]
    i += 2
  else
    frame_score = shots[i] + shots[i + 1]
    i += 2
  end
  frame_score
end

puts point
