#!/usr/bin/env ruby
# frozen_string_literal: true

def list_directories
  Dir.entries('.').sort
end

COLUMNS = 3
def slice_contents(current_directory, columns)
  current_directory.each_slice(current_directory.size.ceildiv(columns)).to_a
end

def format_columns(contents)
  max_elements = contents.map(&:size).max
  contents.each do |col|
    col << ' ' while col.size < max_elements
  end
  contents
end

def display_contents(transposed_contents)
  max_length = transposed_contents.flatten.map {|item| item.length }.max

  transposed_contents.each do |line|
    puts line.map { |item| item.ljust(max_length + 2) }.join
  end
end

current_directory = list_directories
contents = slice_contents(current_directory, COLUMNS)
formatted_contents = format_columns(contents)
transposed_contents = formatted_contents.transpose

display_contents(transposed_contents)
