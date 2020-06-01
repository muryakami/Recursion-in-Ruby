# https://qiita.com/pokotyan/items/53e92a21805f651173aa

module SampleModule
  # module_function
  #   def object_send(method, *args, &block)
  #     send(method, *args, &block)
  #   end

  #   def method_call(method, *args, &block)
  #     method(method).call(*args, &block)
  #   end

  private
    # 配列の和
    def sum(arr)
      return 0 if arr.empty? #配列が空のときは終了
      top = arr.shift
      top + sum(arr)
    end

    def sum2(arr)
      # a = 0
      # arr.each{ |b| a += b }
      # a
      arr.inject(0,:+)
    end

    # すべての要素がブロックの条件を満たすかどうか
    def all?(arr, &b)
      return true if arr.empty? #全要素走査し終わった時や要素がない時はtrueを返す。
      top = arr.shift
      b.call(top) && all?(arr, &b) #すべて満たすか判定したいので && を使う。
    end

    def all2?(arr, &b)
      # a = true
      # arr.each{ |b| a &= yield(b) }
      # a
      arr.inject(true){ |a, b| a &= yield(b) }
    end

    # 配列内に一つでもブロックの条件を満たすものがあるかどうか
    def any?(arr, &b)
      return false if arr.empty? #全要素走査し終わった時や要素がない時や要素がない時はfalseを返す。
      top = arr.shift
      b.call(top) || any?(arr,&b) #||なので、満たすものがあった時点でtrueが返る
    end

end

class SampleClass
  include SampleModule

  def object_send(method, *args, &block)
    send(method, *args, &block)
  end

  def method_call(method, *args, &block)
    method(method).call(*args, &block)
  end

  # private
  #   def sum(arr)
  #     return 0 if arr.empty? #配列が空のときは終了
  #     top = arr.shift
  #     top + sum(arr)
  #   end
end


# https://docs.ruby-lang.org/ja/latest/class/Array.html

p (1..5).inject(:+)
p [].inject(:+)
method_name = :sum
# p SampleModule.method_call(:sum, (1..5).to_a)
# p SampleModule::method_call(:sum, (1..5).to_a)
p SampleClass.new.method_call(method_name, (1..5).to_a)
p SampleClass.new.method_call("#{method_name}2", (1..5).to_a)
p (1..5).to_a.sum

method_name = :all
block = lambda{ |n| n % 2 == 0 }
p SampleClass.new.object_send("#{method_name}?", [2,4,6], &block)  #=> true
p SampleClass.new.object_send("#{method_name}?", [2,1,6], &block)  #=> false
p SampleClass.new.object_send("#{method_name}2?", [2,4,6], &block)  #=> true
p SampleClass.new.object_send("#{method_name}2?", [2,1,6], &block)  #=> false
p [2,4,6].all? &block
p [2,1,6].all? &block

block = lambda{ |n| n % 2 != 0 }
# p exists?([2,4,6], &block) #=> false
# p exists?([2,6,1], &block) #=> true
p [2,4,6].any? &block
p [2,1,6].any? &block

# all? 全てが真か？
# none? 全てが偽か？
# any? １つでも真か？
# one? １つだけ真か？

# 条件がtrueとなるはじめの要素を返す
string = lambda{ |n| n.kind_of?(String) }
p [1,2,"b",3,"c"].find &string #=> b

# 先頭から n 個捨てて、残った配列を返す
p (1..4).to_a.drop(2) #=> [3,4]
p (1..2).to_a.drop(3) #=> []
p [].drop(3) #=> []

# 先頭から n 個の要素を取り出す
p (1..7).take(3) #=> [1, 2, 3]

# 先頭から条件が偽になるまで要素を取り出す
five_over = lambda{|n| n > 5}
p [10,6,4,2,3,6,1].take_while(&five_over)

# map
double = lambda{|n| n * 2 }
p [1,2,3].map &double #=> [2, 4, 6]

# 条件を満たす要素のみを残した配列を返す
arr = [100,2,1,33,50,51]
fifty_over = lambda{|n| n > 50}
p arr.select &fifty_over #=> [100, 51]
p arr                     #=> [100,2,1,33,50,51]

# map と filter を一度に行う
func = lambda{|n|
    return n * 2 if n.even?
}
p (1..5).to_a.map(&func).compact #=> [4, 8]

# 条件を満たす要素の列と満たさない要素の列の両方を返す
# 10 を超える要素と超えない要素に分ける
ten_over = lambda{|n| n > 10}
arr = [100,2,1,33,50,51]
result = arr.partition &ten_over
p result[0] #=> [100, 33, 50, 51]
p result[1] #=> [2, 1]

# 階乗
def factorial(n)
  n = 0 if n.nil?
  # (1..n).inject(1) {|f, i| f*i}
  (1..n).inject(1,:*)
end

# class Integer
#   def factorial
#     (1..self).inject(1,:*)
#   end
# end

p factorial(3)

# 等差数列
num = 7 # 初項
diff = 2 # 公差
length = 3 # 数列の長さ
p num.step(by: diff).take(length) # => [7, 9, 11]

# 素数判定
require 'prime'
p Prime.prime?(47)   #=> true

# ソート
p [3,4,6,1,7,2].sort

# http://antimon2.hatenablog.jp/entry/2014/03/21/ruby_memoize
# https://mickey24.hatenablog.com/entry/20100906/1283769623

# require "meoizable"
# include Memoizable
# extend ActiveSupport::Memoizable

# def fib(n) (0..1).include?(n) ? n : fib(n-2) + fib(n-1); end

# # メモ化
# memoize :fib

# # 一瞬で計算できる
# p fib(1000)
