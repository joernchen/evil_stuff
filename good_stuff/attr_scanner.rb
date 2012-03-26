#!/usr/bin/env ruby
#
# Mass assignment scanner for Ruby on Rails
# should be run from rails console in production
# environment.

#make sure all models are loaded
Dir[Rails.root + 'app/models/**/*.rb'].each { |path| require path }

models = ActiveRecord::Base.subclasses
## for mongoid:
# ObjectSpace.each(Class).select { |c| c < Mongoid::Document }
## (does not work in all rubies)

models.each do |m| 
  mod = m.new
  puts "All attributes for model #{m}:"
  mod.attributes.each_key do |k|
    puts "\t#{k}"
  end
  puts "Protected attributes for model {#m}:"
  m.protected_attributes.each do |p|
    puts "\t#{p}"
  end
  puts "Accessible attributes for model {#m}:"
  m.accessible_attributes do |a|
    puts "\t#{a}"
  end
end
