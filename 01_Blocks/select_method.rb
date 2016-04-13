def select(array)
  counter = 0
  filtered_array = []

  while counter < array.length do
    yield(array[counter])
    filtered_array.push(array[counter]) if yield(array[counter])
    counter += 1
  end

  filtered_array
end

arr = select([1, 2, 3, 4, 5]) do |num|
  num == 1
end

puts arr
