#!/usr/bin/env ruby

def help
  puts "Usage: #{$0} [-j] input_file"
  puts "Examples:"
  puts "#{$0} hetudump.txt > checksums.txt"
  puts "#{$0} -j hetudump.txt > checksums.json"
  puts 
end

if ARGV.length != 1 and ARGV.length != 2
  help
  exit
end
json_mode = false
if ARGV.length == 2
  if ARGV.first == '-j'
    json_mode = true
    infile = File.expand_path( ARGV[1] )
  else
    help
    exit
  end
else
  infile = File.expand_path( ARGV.first )
end
if not File.exists?( infile )
  puts "File not found: #{infile}"
  exit
end

require 'digest/sha1'
require 'rubygems'
require 'csv'
if json_mode
  require 'json'
end

output_arr = []
CSV.foreach( infile, :quote_char => '"', :col_sep =>',', :row_sep =>:auto) do |row|
  hetu = row.first.downcase
  nimi = row[2]
  nimi = '' if nimi.nil?
  sum = Digest::SHA1.hexdigest( hetu+nimi.downcase )
  if json_mode
    output_arr.push sum
  else
    puts sum
  end
end

if json_mode
  puts output_arr.to_json
end
puts
