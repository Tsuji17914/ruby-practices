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

def byte_size(text)
  text.bytesize
end

def output_process(text, options)
  result = []
  if options.empty?
    result << number_of_lines(text)
    result << number_of_words(text)
    result << byte_size(text)
  else
    result << number_of_lines(text) if options[:lines]
    result << number_of_words(text) if options[:words]
    result << byte_size(text) if options[:bytes]
  end
  result.map { |item| item.to_s.rjust(8) }.join(' ')
end

if ARGV.empty?
  input_text = $stdin.read
  puts output_process(input_text, options)
else
  ARGV.each do |file_name|
    if File.exist?(file_name)
      file_content = File.read(file_name)
      puts "#{output_process(file_content, options)} #{file_name}"
    else
      puts "ファイルが見つかりません：#{file_name}"
    end
  end
end
