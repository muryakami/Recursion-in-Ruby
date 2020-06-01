module RequestSample
  require "net/http"
  require 'json'
  require 'securerandom'

  module_function

    # https://docs.ruby-lang.org/ja/latest/library/net=2fhttp.html
    # https://docs.ruby-lang.org/ja/latest/class/Net=3a=3aHTTP.html
    # https://qiita.com/takano-h/items/dd10818eb7e09161bc29
    def simple_get
      uri = URI.parse("http://challenge-your-limits.herokuapp.com/call/me")
      response = Net::HTTP.get_response(uri)

      p response.code
      p response.body
    end

    def simple_post
      params = {}
      uri = URI.parse("http://challenge-your-limits.herokuapp.com/call/me")
      response = Net::HTTP.post_form(uri, params)

      p response.code
      p response.body
    end

    # https://tech.unifa-e.com/entry/2017/06/14/185239
    def sample_post
      uri = URI('http://challenge-your-limits.herokuapp.com/challenge_users')
      name = SecureRandom.hex(8)
      params = { name: name, email: "#{name}@example.com" }
      request = Net::HTTP::Post.new(uri.path, {'Content-Type' => 'application/json'})
      request.body = params.to_json
      response = Net::HTTP.start(uri.host, uri.port) do |http|
        http.request(request)
      end
      p response.code
      p response.body
    end


    # https://blog.class-tech.me/how-to-send-http-methods-using-ruby-net-http-library/
    # GETリクエストを送る
    def get1
      # responseには文字列としてHTMLが入っているのでこれをもとにnokogiri等で解析することも出来る
      response = Net::HTTP.get(URI.parse('https://www.google.com'))
      # 以下の方法だと取得したデータをそのまま出力出来る
      Net::HTTP.get_print(URI.parse('https://www.google.com'))
    end

    # GETリクエストを送る
    def get2
      uri = URI.parse('https://www.google.com')
      # httpsを使う場合は use_sslオプションをtrueに設定する
      response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
        http.get('/')
      end

      # HTML等を取得する
      puts response.body
      # HTTPステータスコードを表示
      puts response.code
    end

    # POSTリクエストを送る
    def post1
      uri = URI.parse('https://example.com')
      # 第2引数にHashを指定することでPOSTする際のデータを指定出来る
      response = Net::HTTP.post_form(uri, { q: 'ruby' })
      puts res.body


      # ステータスコード等を取得したい場合
      response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
        http.post('/', 'q=ruby')
      end
      puts response.body
      puts response.code
    end

    # PATCH, PUT, DELETEリクエストを送る
    def patch1
      uri = URI.parse('https://example.com')
      # PATCHの場合
      response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
        http.patch('/', 'q=ruby&browser=1')
      end

      # PUTの場合
      response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
        http.put('/', 'q=ruby&browser=1')
      end

      # DELETEの場合
      response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
        http.delete('/')
      end
    end
end

RequestSample.sample_post
# RequestSample::sample_post
