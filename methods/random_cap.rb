require "rainbow"

def random_cap(string)
  new_string = string.chars.map { |c| (rand 2) == 0 ? c : c.upcase }.join
  return new_string
end

def random_gsub(string)
  rand_chars = ["6", "DIE", "bLoOD", "dEaTH", "!"]
  new_string = string.chars.map { |c| (rand 10) != 0 ? c : c = Rainbow(rand_chars.sample).red}.join
  new_string = random_cap(new_string)
  return new_string
end

def if_insane(hero, string)
    if hero.sanity == 0
      return random_gsub(string)
    elsif hero.sanity < 50 
      return random_cap(string)
    end
    return string
end