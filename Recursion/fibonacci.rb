# https://yu8mada.com/2018/06/23/how-to-calculate-fibonacci-numbers-in-ruby/

def fibonacci1(n)
    return   if n < 0
    return n if n < 2
    fibonacci1(n - 1) + fibonacci1(n - 2)
end

def fibonacci2(n)
  cache = []
  l = lambda do |m|
    return   if m < 0
    return m if m < 2
    cache[m] ||= l[m - 1] + l[m - 2]
  end
  l.call(n)
end

def fibonacci3(n)
  return if n < 0
  Hash.new { |h, k| h[k] = k < 2 ? k : h[k - 1] + h[k - 2] }[n]
end

def fibonacci4(n)
  return   if n < 0
  return n if n < 2
  a, b = 0, 1
  n.times { a, b = b, a + b }
  a
end

def fibonacci_enumerator
  Enumerator.new do |y|
    a, b = 0, 1
    loop do
      y << a
      a, b = b, a + b
    end
  end
end

p fibonacci4(0)
p fibonacci4(1)

p fibonacci2(100)
