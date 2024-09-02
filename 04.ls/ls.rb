#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

COLUMNS = 3
PADDING = 2

def permission_string(allow)
  allow.chars.map do |i|
    case i.to_i
    when 7
      'rwx'
    when 6
      'rw-'
    when 5
      'r-x'
    when 4
      'r--'
    when 3
      '-wx'
    when 2
      '-w-'
    when 1
      '--x'
    else
      '---'
    end
  end.join
end

def file_attributes(file_path)
  if `xattr #{file_path}`.empty?
    if `getfacl #{file_path}`.empty?
      ' '
    else
      '+'
    end
  else
    '@'
  end
end

def list_directories(permit)
  entries = Dir.entries('.').sort
  entries.reject! { |f| f.start_with?('.') }
  if permit
    entries.each do |filename|
      file_stat = File.stat(filename)
      file_type = file_stat.ftype.slice(0)
      permission = file_stat.mode.to_s(8).slice(-3, 3)
      permission_str = permission_string(permission)
      attributes = file_attributes(filename)
      hard_link = file_stat.nlink
      owner = Etc.getpwuid(file_stat.uid).name
      group_owner = Etc.getgrgid(file_stat.gid).name
      block_size = file_stat.size.to_s.rjust(4)
      last_update_time = file_stat.mtime.strftime('%_m %_d %H:%M')
      puts "#{file_type}#{permission_str}#{attributes} #{hard_link} #{owner} #{group_owner} #{block_size} #{last_update_time} #{filename}"
    end
  else
    entries
  end
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
opt.on('-l') { options[:permit] = true }
opt.parse!(ARGV)

current_directory = list_directories(options[:permit])
unless options[:permit]
  contents = slice_contents(current_directory, COLUMNS)
  formatted_contents = format_columns(contents)
  transposed_contents = formatted_contents.transpose

  display_contents(transposed_contents)
end
