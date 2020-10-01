require "rainbow"
require "tty-font"

def random_cap(string)
  new_string = string.chars.map { |c| (rand 2) == 0 ? c : c.upcase}.join
  return new_string
end

def random_gsub(string)
  rand_chars = ["     ", "   ", "", "", "","", "", "", "", "die", "DIE", "DEVIL", "RED", "blood", "6", "kill", "murder", "?", "!", "#"]
  new_string = string.chars.map { |c| (rand 5) != 0 ? c : c = rand_chars.sample}.join
  new_string = Rainbow(random_cap(new_string)).red.background("3a0101")
  return new_string
end

def if_insane_slow(hero, string)
    if hero.sanity < 25
      type_slow_b(random_gsub(string), 0.025)
    elsif hero.sanity < 75 
      type_slow(random_cap(string), 0.01)
    else
      type_slow(string, 0.005)
    end
end

def if_insane(hero, string)
  if hero.sanity < 25
    return string = random_gsub(string)
  elsif hero.sanity < 75 
    return string = random_cap(string)
  end
  return string
end

def type_slow(string, speed)  
  string.each_char do |a| 
    if rand(50) == 0 && speed == 0.01
      print Rainbow(a).red
    else
      print a 
    end
    
    sleep speed
  end
end

def type_slow_b(string, speed)
  string.each_char do |a| 
    print Rainbow(a).red.background("3a0101")
    add_random_font
    sleep speed
  end
end

def add_random_font
  pastel = Pastel.new
  font = TTY::Font.new(:straight)
  rand_chars = ["die", "dvil", "bl0d", "kil", "brn", "gor", " "]
  if rand(300) == 0
    print Rainbow(font.write(random_cap(rand_chars.sample))).red.background("3a0101")
  end
end

def woods_swapper(sanity, a, b)
  if sanity < 25
    return b
  else
    return a
  end
end

def marker_swapper(sanity, a, b)
  if sanity < 25
    return b
  else
    return a
  end
end

