def choose_random_area(random_area, area_desc)
  # choose random area from area descriptions list, make sure you dont get same in a row
  if random_area != ""
    last_area = random_area
    loop do
      random_area = area_desc[rand(0..(area_desc.length - 1))]
      if random_area != last_area
        return random_area
      end
    end
  else
    return area_desc[rand(0..(area_desc.length - 1))]
  end
end

def choose_random_encounter(random_encounter, enc)
  if random_encounter != ""
    last_enc = random_encounter
    loop do
      random_encounter = enc[rand(0..(enc.length - 1))]
      if random_encounter != last_enc
        return random_encounter
      end
    end
  else
    return enc[rand(0..(enc.length - 1))]
  end
end

def hero_died(hero, rand_area)
  sleep 1.5

  if hero.deaths.include?(rand_area["id"])
    return rand_area["died_description"]
    # else display normal description
  else
    return rand_area["base_description"]
  end
end

def hero_died_enc(hero, rand_enc)
  sleep 1.5

  if hero.deaths.include?(rand_enc["id"])
    return rand_enc["died_description"]
    # else display normal description
  else
    return rand_enc["base_description"]
  end
end
