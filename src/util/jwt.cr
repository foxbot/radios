require "jwt"

secret = ENV["jwtsecretkey"]
level = ARGV[0].to_i

puts "Generating a token for User (Discord ID -1) with Grant Level #{level}"
payload = { "level" => level, "id" => -1 }
token = JWT.encode(payload, secret, "HS256")

puts token
