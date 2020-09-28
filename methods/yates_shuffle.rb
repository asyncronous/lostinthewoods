def fy_shuffle(arr)
    a_copy = arr.dup  # don't mutate original array!
    a_copy.each_index do |i|
      j = i + rand(a_copy.length - i)
      a_copy[i], a_copy[j] = a_copy[j], a_copy[i] if i != j
    end
    return a_copy
end
  