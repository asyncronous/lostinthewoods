def random_cap(string)
  new_string = string.chars.map { |c| (rand 2) == 0 ? c : c.upcase }.join
  return new_string
end

def if_insane(hero, string)
    if hero.sanity < 50 
      return random_cap(string)
    end
    return string
end