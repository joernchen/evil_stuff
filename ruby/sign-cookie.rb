#!/usr/bin/ruby
# Sign a cookie in RoR style
require 'base64' 
require 'openssl'
require 'optparse'

banner = "Usage: #{$0} -k KEY [-c COOKIE]\nCookie is a raw ruby expression like '{:user_id => 1}'"

hashtype = 'SHA1'
key = nil
cookie = {"user_id"=>1}

opts = OptionParser.new do |opts|
  opts.banner = banner
  opts.on("-k", "--key KEY") do |h|
    key = h
  end
  opts.on("-c", "--cookie COOKIE") do |w|
    cookie = w
  end  
end

begin
 opts.parse!(ARGV) 
rescue Exception => e
  puts e, "", opts
  exit
end 

if key.nil?
  puts banner 
  exit
end


cook = Base64.strict_encode64(Marshal.dump(eval("#{cookie}"))).chomp

digest = OpenSSL::HMAC.hexdigest(OpenSSL::Digest::Digest.new(hashtype), key, cook)

puts("#{cook}--#{digest}") 
