# frozen_string_literal: true

# !/usr/bin/env ruby

score = ARGV[0]
scores = score.split(',')
shots = []

scores.each do |s|
  shots << if s == 'X'
             10
           else
             s.to_i
           end
end

frames = []
i = 0

while i < shots.size
  if frames.size < 9
    if shots[i] == 10
      frames << [shots[i]]
      i += 1
    else
      frames << [shots[i], shots[i + 1]]
      i += 2
    end
  else
    frames << shots[i..i + 2]
    break
  end
end

point = 0
i = 0

frames.each_with_index do |frame, index|
  if index < 9
    if frame[0] == 10
      next_shot1 = shots[i + 1]
      next_shot2 = shots[i + 2]
      point += 10 + next_shot1 + next_shot2
      i += 1
    elsif frame.sum == 10
      next_shot = shots[i + 2]
      point += 10 + next_shot
      i += 2
    else
      point += frame.sum
      i += 2
    end
  else
    point += frame.sum
  end
end

puts point
