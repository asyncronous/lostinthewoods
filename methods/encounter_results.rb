require "rainbow"
require_relative "sanity_methods"

def compute_result(hero, item, encounter)
  if item == encounter["success_condition"]["item"]
    condition = "success_condition"
    if_insane_slow(hero, encounter[condition]["description"])
    puts "\n"
    return condition
  elsif item == encounter["neutral_condition"]["item"]
    condition = "neutral_condition"
    if_insane_slow(hero, encounter[condition]["description"])
    puts "\n"
    return condition
  else
    condition = "failure_condition"
    Rainbow(if_insane_slow(hero, encounter[condition]["description"])).red
    puts "\n"
    return condition
  end
end

def health_change(enc, cond)
  return enc[cond]["benefit"]["health"] - enc[cond]["loss"]["health"]
end

def sanity_change(enc, cond)
  return enc[cond]["benefit"]["sanity"] - enc[cond]["loss"]["sanity"]
end
