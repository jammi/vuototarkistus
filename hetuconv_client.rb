#!/usr/bin/env ruby

def help
  puts "Usage: #{$0} input_file"
  puts "Examples:"
  puts "#{$0} hetudump.txt > checksums.js"
  puts 
end

if ARGV.length != 1
  help
  exit
end

infile = File.expand_path( ARGV.first )

if not File.exists?( infile )
  puts "File not found: #{infile}"
  exit
end

require 'digest/sha1'
require 'rubygems'
require 'csv'
require 'json'

output_arr = []
CSV.foreach( infile, :quote_char => '"', :col_sep =>',', :row_sep =>:auto) do |row|
  output_arr.push Digest::SHA1.hexdigest( row.first.downcase )
end

puts "var hetusums = #{output_arr.to_json};"
