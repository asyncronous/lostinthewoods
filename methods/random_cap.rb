require "rainbow"

def random_cap(string)
  new_string = string.chars.map { |c| (rand 2) == 0 ? c : c.upcase}.join
  return new_string
end

def random_gsub(string)
  rand_chars = ["     ", "   ", "", "", "", "die", "DIE", "DEVIL", "RED", "blood", "6", "kill", "murder", "?", "!", "#"]
  new_string = string.chars.map { |c| (rand 5) != 0 ? c : c = rand_chars.sample}.join
  new_string = Rainbow(random_cap(new_string)).red
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