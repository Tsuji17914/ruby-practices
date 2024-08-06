#!/usr/bin/env ruby
# frozen_string_literal: true

def list_directories
  Dir.entries('.').sort
end

def slice_contents(current_directory, columns)
  contents = []
  current_directory.each_slice((current_directory.size / columns).ceil) { |slice| contents << slice }
  contents
end

def format_columns(contents)
  max_elements = contents.map(&:size).max
  contents.each do |col|
    col << ' ' while col.size < max_elements
  end
  contents
end

def display_contents(transposed_contents)
  transposed_contents.each { |line| puts line.join(' ') }
end

current_directory = list_directories
contents = slice_contents(current_directory, 3.0)
formatted_contents = format_columns(contents)
transposed_contents = formatted_contents.transpose

display_contents(transposed_contents)
