#!/usr/bin/env ruby

def help
  puts "Usage: #{$0} input_file"
  puts "Examples:"
  puts "#{$0} netcaruserdatabase.txt > netcar_sums.js"
  puts 
end

if ARGV.length != 1
  help
  exit
end

infile = File.expand_path( ARGV.first )
line_skip = 7

if not File.exists?( infile )
  puts "File not found: #{infile}"
  exit
end

require 'digest/sha1'
require 'rubygems'
require 'csv'
require 'randgen'
require 'json'

rand_salt = RandGen.new( 16 ).gen
output_arr = []
File.open( infile, 'r' ).read.each_with_index do |row,i|
  next if i < line_skip
  (user_passwd,email) = row.split('------')
  next unless user_passwd.include?('-')
  output_arr.push Digest::SHA1.hexdigest( user_passwd+rand_salt )
end

puts "var salt = #{rand_salt.to_json}, checksums = #{output_arr.to_json};"
