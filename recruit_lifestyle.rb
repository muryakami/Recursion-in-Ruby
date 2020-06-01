 require "net/http"
 require 'json'

uri = URI.parse("http://challenge-your-limits.herokuapp.com/call/me")
json = Net::HTTP.get(uri)
result = JSON.parse(json)

p result["message"]
result.each{ |k, v| p v }
