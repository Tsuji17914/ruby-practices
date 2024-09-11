#!/usr/bin/env ruby
# frozen_string_literal: true

def number_of_lines(text)
    text.count("\n")
  end
  
  def number_of_words(text)
    text.split.size
  end
  
  def size_of_byte(text)
    text.bytesize
  end
  
  if ARGV.empty?
    input_text = $stdin.read
    puts "#{number_of_lines(input_text)} #{number_of_words(input_text)} #{size_of_byte(input_text)}"
  else
    ARGV.each do |file_name|
      if File.exist?(file_name)
        file_content = File.read(file_name)
        puts "#{number_of_lines(file_content)} #{number_of_words(file_content)} #{size_of_byte(file_content)} #{file_name}"
      else
        puts "ファイルが見つかりません：#{file_name}"
      end
    end
  end
  