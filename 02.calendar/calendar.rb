#!/usr/bin/env ruby

require 'date'
require 'optparse'

options = {}

opt_parser = OptionParser.new do |opts|
  opts.on('-y', '--year=YEAR') do |y|
    options[:year] = y.to_i
  end

  opts.on('-m', '--month=MONTH') do |m|
    options[:month] = m.to_i
  end
end

opt_parser.parse!

year = options[:year] || Date.today.year
month = options[:month] || Date.today.month

puts "#{year}年#{month}月"
puts '日 月 火 水 木 金 土'

start_date = Date.new(year, month, 1)
end_date = Date.new(year, month, -1)

start_date.wday.times do
  print '   '
end

(start_date..end_date).each do |date|
  print date.day.to_s.rjust(2) + ' '
  puts '  ' if date.saturday?
end

puts '  '
