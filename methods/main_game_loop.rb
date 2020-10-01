# gems and libraries
require "asciiart"
require "rainbow"
require "tty-prompt"
require "json"

# player class
require_relative "../classes/hero"

# main game loop helper methods
require_relative "choose_random"
require_relative "encounter_results"
require_relative "yates_shuffle"
require_relative "sanity_methods"

def main_game_loop(master_save, curr_save)
  # generate hero from save data
  hero = Hero.new(curr_save["name"], curr_save["inventory"], curr_save["deaths"])
  # generate array of descriptions from files
  area_descriptions = JSON.parse(File.read("./files/area_descriptions.json", symbolize_names: true))
  # generate array of encounters from files
  encounters = JSON.parse(File.read("./files/encounters.json", symbolize_names: true))
  # number of forest areas survived
  num_areas = 0
  prompt = TTY::Prompt.new(active_color: :red)

  # its shufflin time
  max_count = encounters.length
  count = 0
  areas_dupe = fy_shuffle(area_descriptions)
  encounters_dupe = fy_shuffle(encounters)

  # wake up loop
  loop do
    system("clear")
    a = AsciiArt.new("./files/scary_woods3.jpg")
    b = AsciiArt.new("./files/scary_woods_low_sanity.jpg")
    c = ">"
    d = "DIE"

    puts a.to_ascii_art(color: true, width: 100)

    if_insane_slow(hero, "The howl of a wolf jolts you awake! You are... in a forest? You've never been here before... but it seems familiar all the same\n\n")
    marker = ">"
    answer = prompt.select("health: #{hero.health} | sanity: #{hero.sanity} | inventory: #{hero.inventory.join(", ")}\n", ["Continue"], symbols: { marker: marker })

    rand_area = ""
    rand_enc = ""

    # random area/encounter loop
    loop do
      system("clear")
      # asciiart swapper
      woods = woods_swapper(hero.sanity, a, b)
      # menu marker swapper
      marker = marker_swapper(hero.sanity, c, d)
      puts woods.to_ascii_art(color: true, width: 100)

      # choose next enc/area in randomised array, reshuffle decks when you run out
      if count < max_count - 1
        rand_area = areas_dupe[count]
        rand_enc = encounters_dupe[count]
        count += 1
      else
        count = 0
        areas_dupe = fy_shuffle(area_descriptions)
        encounters_dupe = fy_shuffle(encounters)
        rand_area = areas_dupe[count]
        rand_enc = encounters_dupe[count]
        count += 1
      end

      # if hero died to this area, display alt description
      if_insane_slow(hero, hero_died(hero, rand_area))
      # if hero died to this enc, display alt description
      if_insane_slow(hero, hero_died_enc(hero, rand_enc))

      # list all items in menu
      item_list = []
      hero.inventory.each { |i| item_list << i }

      item = prompt.select(if_insane(hero, "You have the following items available, what do you choose?:\n"), item_list, symbols: { marker: marker })
      system("clear")

      puts woods.to_ascii_art(color: true, width: 100)
      if_insane_slow(hero, "You try to use the #{item}!\n\n")

      # figure out which condition has been met, puts description to screen
      condition = compute_result(hero, item, rand_enc)
      # change health and sanity
      hero.adjust_stats(health_change(rand_enc, condition), sanity_change(rand_enc, condition))

      #remove items
      rand_enc[condition]["loss"]["items"].each { |item| hero.inventory.delete(item) }
      #add items / check for duplicates and swap item if inv full
      hero.item_add_swap(rand_enc[condition]["benefit"]["items"])

      #if dead, add encounter that killed player, and area they died in
      dead = hero.dead_checker(rand_area["id"], rand_enc["id"])

      #incr if sane
      if hero.sanity > 0
        num_areas += 1
      end

      #update save file
      master_save.find do |save_game| save_game["name"] == hero
        if save_game["name"] == hero.name
          save_game["inventory"] = hero.inventory
          save_game["deaths"] = hero.deaths
          curr_save = save_game
        end       
      end

      # save to file
      File.write("./files/save.json", JSON.generate(master_save))

      # if won the game
      if dead == false && num_areas > 7
        answer = prompt.select("You have escaped the forest!\n", ["Back to Title Screen"], symbols: { marker: marker })
        system("clear")
        return "victory!"

        # if dead
      elsif dead == true
        num_areas = 0
        answer = prompt.select("You are Dead", ["Wake Up", "Back to Title Screen"], symbols: { marker: marker })

        if answer == "Wake Up"
          system("clear")
          hero = Hero.new(curr_save["name"], curr_save["inventory"], curr_save["deaths"])
          break
        elsif answer == "Back to Title Screen"
          system("clear")
          return
        end
      end

      # display stats before continuing or leaving game
      answer = prompt.select(if_insane(hero, "health: #{hero.health} | sanity: #{hero.sanity} | inventory: #{hero.inventory.join(", ")}\n"), ["Continue", "Back to Title Screen"], symbols: { marker: marker })
      system("clear")
      if answer == "Back to Title Screen"
        return
      end
    end
  end
end
