require "net/http"
require 'json'

def main(argv)
  raise ArgumentError.new('引数の数が正しくありません') if argv.length != 2
  $seed, n = argv
  puts f(Integer(n))
rescue ArgumentError, TypeError => e
  puts e
  exit 1
rescue => e
  puts "原因不明のエラーです: #{e}"
  exit 1
end

def f(n)
  cache = []
  l = lambda do |m|
    return 1 if m == 0
    return 2 if m == 2
    if m % 2 == 0
      cache[m] ||= l(m-1) + l(m-2) + l(m-3) + l(m-4)
    else
      askServer(m)
    end
  end
  l.call(n)
end

def askServer(n)
  uri = URI.parse("http://challenge-your-limits.herokuapp.com/call/me")
  params = { name: $seed, email: n }
  uri.query = URI.encode_www_form(params)
  req = Net::HTTP::Get.new uri
  res = Net::HTTP.start(uri.host, uri.port) { |http| http.request req }
  JSON.parse(res.body)
end

params = ["seed", "4"]
main(params)
