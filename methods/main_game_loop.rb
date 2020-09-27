# gems and libraries
require 'highline/import'
require 'tty-prompt'
require 'json'

# player class
require_relative '../classes/hero'

# main game loop helper methods
require_relative 'choose_random'
require_relative 'encounter_results'

def main_game_loop(master_save, curr_save)
    # generate hero from save data
    hero = Hero.new(curr_save["name"], curr_save["inventory"], curr_save["deaths"])

    # generate array of descriptions from files
    area_descriptions = JSON.parse(File.read("./files/area_descriptions.json", symbolize_names: true))

    # generate array of encounters from files
    encounters = JSON.parse(File.read("./files/encounters.json", symbolize_names: true))

    # number of forest areas survived
    num_areas = 0

    # begin loop
    loop do
        puts "The howl of a wolf jolts you awake! You are... in a forest? You've never been here before... but it seems familiar all the same\n\n"
        
        sleep 2

        rand_area = ""
        rand_enc = ""
        loop do
            # choose random area from area descriptions list, make sure you dont get same in a row
            rand_area = choose_random_area(rand_area, area_descriptions)

            # choose random encounter from encounter list, make sure you dont get same in a row
            rand_enc = choose_random_encounter(rand_enc, encounters)
            
            # if hero died to this area, display alt description
            puts hero_died(hero, rand_area)
            
            sleep 1.5
            
            # if hero died to this enc, display alt description
            puts hero_died_enc(hero, rand_enc)
    
            sleep 2
            
            item_list = hero.inventory
            item_prompt = TTY::Prompt.new(active_color: :red)
            question = "You have the following items available, what do you choose?:\n"
            item = item_prompt.select(question, item_list)
            system("clear")
            
            puts "You try to use your #{item}!\n\n"
            
            # figure out which condition has been met, puts description to screen
            condition = compute_result(item, rand_enc)

            # change health and sanity
            hero.health = hero.health + health_change(rand_enc, condition)
            hero.sanity = hero.sanity + sanity_change(rand_enc, condition)
    
            #remove items
            item_to_remove = rand_enc[condition]["loss"]["items"]
            item_to_remove.each {|item| hero.inventory.delete(item)}
    
            #add items / check for duplicates and swap item if inv full
            item_to_add = rand_enc[condition]["benefit"]["items"]
            item_to_add.each do |item| 
                if hero.inventory.include?(item) == false
                    if hero.inventory.length >= 6
                        item_list = []
                        hero.inventory.each {|i| item_list << i}
                        item_list << "Leave item"
                    
                        item_prompt = TTY::Prompt.new(active_color: :red)
                        question = "Your inventory is full, choose an item to swap for #{item}:\n"
                        # choices = [item_action1, item_action2, item_action3]
                        item_to_swap = item_prompt.select(question, item_list)

                        if item_to_swap != "Leave item"
                            title_prompt = TTY::Prompt.new(active_color: :red)
                            greeting = "Are you sure?\n"
                            choices = ["Yes", "No"]
                            answer = title_prompt.select(greeting, choices)
                            system("clear")
    
                            if answer == "Yes"
                                hero.inventory.delete(item_to_swap)
                                hero.inventory << item
                            end
                        end
                    else
                        hero.inventory << item
                    end
                end
            end

            if hero.sanity > 0
                num_areas += 1
            end

            status = "health: #{hero.health} | sanity: #{hero.sanity} | inventory: #{hero.inventory}\n"
    
            #dead
            dead = false
            if(hero.health <= 0)
                # add death to deaths
                hero.deaths << rand_enc["id"]
                hero.deaths << rand_area["id"]
                dead = true
                #insane
                if(hero.sanity <= 0)
                    hero.inventory = ["revolver", "cross", "trinket"]
                end
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
                prompt = TTY::Prompt.new(active_color: :red)
                status = "You have escaped the forest!\n"
                choices = ["Back to Title Screen"]
                answer = prompt.select(status, choices)

                system("clear")
                return "victory!"

            # if dead
            elsif dead == true
                num_areas = 0
                prompt = TTY::Prompt.new(active_color: :red)
                status = "You are Dead"
                choices = ["Wake Up", "Back to Title Screen"]
                answer = prompt.select(status, choices)
                
                if answer == "Wake Up"
                    system("clear")
                    hero = Hero.new(curr_save["name"], curr_save["inventory"], curr_save["deaths"])
                    break
                
                elsif answer == "Back to Title Screen"
                    system("clear")
                    return
                end
            end

            prompt = TTY::Prompt.new(active_color: :red)
            choices = "Continue"
            answer = prompt.select(status, choices)
            system("clear")
            # gets
        end
    end
end