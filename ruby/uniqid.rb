#!/usr/bin/env ruby
# generate all PHP uniqids for a given second

from = Time.new(ARGV[0].to_i,ARGV[1].to_i,ARGV[2].to_i,ARGV[3].to_i,ARGV[4].to_i,ARGV[5].to_i)


0.upto 0xfffff do |i|
	uniqid = sprintf("%08x%05x",from.tv_sec,i);
	puts uniqid 
end