#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

options = {}
opt = OptionParser.new
opt.on('-l') { options[:lines] = true }
opt.on('-w') { options[:words] = true }
opt.on('-c') { options[:bytes] = true }
opt.parse!(ARGV)

options = { lines: true, words: true, bytes: true } if options.empty?

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
  result << number_of_lines(text) if options[:lines]
  result << number_of_words(text) if options[:words]
  result << byte_size(text) if options[:bytes]
  result
end

def format_output(result)
  result.map { |item| item.to_s.rjust(8) }.join(' ')
end

if ARGV.empty?
  input_text = $stdin.read
  result = output_process(input_text, options)
  puts format_output(result)
else
  ARGV.each do |file_name|
    if File.exist?(file_name)
      file_content = File.read(file_name)
      result = output_process(file_content, options)
      puts "#{format_output(result)} #{file_name}"
    else
      puts "ファイルが見つかりません：#{file_name}"
    end
  end

  if ARGV.size > 1
    total_lines = 0
    total_words = 0
    total_bytes = 0

    ARGV.each do |file_name|
      next unless File.exist?(file_name)

      file_content = File.read(file_name)
      result = output_process(file_content, options)

      total_lines += result[0] if options[:lines]
      total_words += result[1] if options[:words]
      total_bytes += result[2] if options[:bytes]
    end

    total_result = []
    total_result << total_lines if options[:lines]
    total_result << total_words if options[:words]
    total_result << total_bytes if options[:bytes]
    puts "#{format_output(total_result)} total"
  end
end
