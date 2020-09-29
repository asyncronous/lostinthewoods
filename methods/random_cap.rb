require "rainbow"

def random_cap(string)
  new_string = string.chars.map { |c| (rand 2) == 0 ? c : c.upcase}.join
  return new_string
end

def random_gsub(string)
  rand_chars = ["     ", "   ", "", "", "","", "", "", "", "die", "DIE", "DEVIL", "RED", "blood", "6", "kill", "murder", "?", "!", "#"]
  new_string = string.chars.map { |c| (rand 5) != 0 ? c : c = rand_chars.sample}.join
  new_string = Rainbow(random_cap(new_string)).red
  return new_string
end

def if_insane_slow(hero, string)
    if hero.sanity < 25
      type_slow(random_gsub(string), 0.025)
    elsif hero.sanity < 75 
      type_slow(random_cap(string), 0.01)
    else
      puts string
    end
end

def if_insane(hero, string)
  if hero.sanity < 25
    string = random_gsub(string)
  elsif hero.sanity < 75 
    string = random_cap(string)
  end
  
  return string
end

def type_slow(string, speed)
  string.each_char do |a| 
    print a 
    sleep speed
  end
end

