#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

COLUMNS = 3
PADDING = 2

def list_directories(reverse)
  entries = Dir.entries('.').sort
  entries.reject! { |f| f.start_with?('.') }
  reverse ? entries.reverse : entries
end

def slice_contents(current_directory, columns)
  slice_size = if current_directory.empty?
                 1
               else
                 current_directory.size.ceildiv(columns)
               end
  current_directory.each_slice(slice_size).to_a
end

def format_columns(contents)
  max_elements = contents.map(&:size).max
  contents.each do |col|
    col << ' ' while col.size < max_elements
  end
  contents
end

def display_contents(transposed_contents)
  max_length = transposed_contents.flatten.map(&:length).max

  transposed_contents.each do |line|
    puts line.map { |item| item.ljust(max_length + PADDING) }.join
  end
end

opt = OptionParser.new
options = {}
opt.on('-r') { options[:reverse] = true }
opt.parse!(ARGV)

current_directory = list_directories(options[:reverse])
contents = slice_contents(current_directory, COLUMNS)
formatted_contents = format_columns(contents)
transposed_contents = formatted_contents.transpose

display_contents(transposed_contents)
