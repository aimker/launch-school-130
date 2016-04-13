def reduce(array, acc=0)
  result = acc
  counter = 0

  while counter < array.size
    result = yield(result, num=array[counter])
    counter += 1
  end

  result
end

test = reduce([1,2,3], 10) { |acc, num| acc + num }
puts test
