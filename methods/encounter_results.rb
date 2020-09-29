require "rainbow"
require_relative "random_cap"

def compute_result(hero, item, encounter)
  if item == encounter["success_condition"]["item"]
    condition = "success_condition"
    puts if_insane(hero, encounter[condition]["description"]) + "\n"
    return condition
  elsif item == encounter["neutral_condition"]["item"]
    condition = "neutral_condition"
    puts if_insane(hero, encounter[condition]["description"]) + "\n"
    return condition
  else
    condition = "failure_condition"
    puts Rainbow(if_insane(hero, encounter[condition]["description"])).red + "\n"
    return condition
  end
end

def health_change(enc, cond)
  return enc[cond]["benefit"]["health"] - enc[cond]["loss"]["health"]
end

def sanity_change(enc, cond)
  return enc[cond]["benefit"]["sanity"] - enc[cond]["loss"]["sanity"]
end
