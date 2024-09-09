#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

COLUMNS = 3
PADDING = 2

PERMISSION_MAP = {
  7 => 'rwx',
  6 => 'rw-',
  5 => 'r-x',
  4 => 'r--',
  3 => '-wx',
  2 => '-w-',
  1 => '--x'
}.freeze

FILE_TYPE_MAP = {
  'file' => '-',
  'directory' => 'd',
  'fifo' => 'p',
  'characterSpecial' => 'c',
  'blockSpecial' => 'b',
  'link' => 'l',
  'socket' => 's'
}.freeze

def permission_string(allow)
  allow.chars.map { |i| PERMISSION_MAP[i.to_i] || '---' }.join
end

def get_files(show_all, reverse)
  entries = Dir.entries('.').sort
  entries.reject! { |f| f.start_with?('.') } unless show_all
  entries.reverse! if reverse
  entries
end

def format_long(files)
  files.each do |filename|
    file_stat = File.stat(filename)
    file_type = FILE_TYPE_MAP[File.ftype(filename)] || '?'
    permission = file_stat.mode.to_s(8).slice(-3, 3)
    permission_str = permission_string(permission)
    hard_link = file_stat.nlink
    owner = Etc.getpwuid(file_stat.uid).name
    group_owner = Etc.getgrgid(file_stat.gid).name
    block_size = file_stat.size.to_s.rjust(4)
    last_update_time = file_stat.mtime.strftime('%_m %_d %H:%M')
    puts "#{file_type}#{permission_str} #{hard_link} #{owner} #{group_owner} #{block_size} #{last_update_time} #{filename}"
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
opt.on('-a') { options[:show_all] = true }
opt.on('-r') { options[:reverse] = true }
opt.on('-l') { options[:long_format] = true }
opt.parse!(ARGV)

current_directory = get_files(options[:show_all], options[:reverse])
if options[:long_format]
  format_long(current_directory)
else
  contents = slice_contents(current_directory, COLUMNS)
  formatted_contents = format_columns(contents)
  transposed_contents = formatted_contents.transpose

  display_contents(transposed_contents)
end
