require 'tynt_client'

if ARGV.length < 1
  puts "\n\n"
  puts "*** No Tynt app ID was specified"
  puts "*** You can obtain an app ID from http://dev.tynt.com"
  puts "*** Once, you have a Tynt app ID, re-run this command with your app ID:"
  puts "    example.rb <appid>"
  puts "\n\n"
  exit(1)
end

tynt_client = TyntClient.new('demo-api.tynt.com', ARGV[0])
result = tynt_client.top_categories

puts "Tynt Top Categories:"
result.each { |category| puts "  " + category['display_name'] }
puts
category = result[result.length - 1]
name = category['display_name']

puts "Tynt Top Pages for #{name}:"
result = tynt_client.top_pages_for_category(category)
result['pages'].each { |p| puts "  " + p['url'] }
puts

puts "Tynt Top Images for #{name}:"
result = tynt_client.top_images_for_category(category)
result['images'].each { |i| puts "  " + i['url'] }
puts

puts "Tynt Top Search Terms for #{name}"
result = tynt_client.top_terms_for_category(category)
result['terms'].each { |term| puts "  " + term }
puts 
