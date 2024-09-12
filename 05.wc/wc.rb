#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

options = {}
opt = OptionParser.new
opt.on('-l') { options[:lines] = true }
opt.on('-w') { options[:words] = true }
opt.on('-c') { options[:bytes] = true }
opt.parse!(ARGV)

def number_of_lines(text)
  text.count("\n")
end

def number_of_words(text)
  text.split.size
end

def size_of_byte(text)
  text.bytesize
end

def process_text(text, options)
  result = []
  if options.empty?
    result << number_of_lines(text)
    result << number_of_words(text)
    result << size_of_byte(text)
  else
    result << number_of_lines(text) if options[:lines]
    result << number_of_words(text) if options[:words]
    result << size_of_byte(text) if options[:bytes]
  end
  result.join(' ')
end

if ARGV.empty?
  input_text = $stdin.read
  puts "#{number_of_lines(input_text)} #{number_of_words(input_text)} #{size_of_byte(input_text)}"
else
  ARGV.each do |file_name|
    if File.exist?(file_name)
      file_content = File.read(file_name)
      puts "#{process_text(file_content, options)} #{file_name}"
    else
      puts "ファイルが見つかりません：#{file_name}"
    end
  end
end
