require 'highline/import'
require 'tty-prompt'
require 'json'

class Hero
    attr_accessor :name, :health, :sanity, :inventory, :deaths

    def initialize(name, inventory, deaths)
        @name = name
        @health = 100
        @sanity = 100
        @inventory = inventory
        @deaths = deaths
    end


end

def main_game_loop(master_save, curr_save)
    # generate hero from save data
    hero = Hero.new(curr_save["name"], curr_save["inventory"], curr_save["deaths"])

    # generate array of descriptions from files
    area_descriptions = JSON.parse(File.read("area_descriptions.json", symbolize_names: true))

    # generate array of encounters from files
    encounters = JSON.parse(File.read("encounters.json", symbolize_names: true))

    # number of forest areas survived
    num_areas = 0

    # begin loop
    loop do
        puts "The howl of a wolf jolts me awake! I am... in a forest? I've never been here before... but it seems familiar all the same\n\n"
        
        sleep 2

        rand_area = ""
        rand_enc = ""
        loop do
            # choose random area from area descriptions list, make sure you dont get same in a row
            if rand_area != ""
                last_area = rand_area
                loop do
                    rand_area = area_descriptions[rand(0..(area_descriptions.length - 1))]
                    if rand_area != last_area
                        break
                    end
                end
            else
                rand_area = area_descriptions[rand(0..(area_descriptions.length - 1))]
            end

            # choose random encounter from encounter list
            if rand_area != ""
                last_enc = rand_enc
                loop do
                    rand_enc = encounters[rand(0..(encounters.length - 1))]
                    if rand_enc != last_enc
                        break
                    end
                end
            else
                rand_enc = encounters[rand(0..(encounters.length - 1))]
            end
            
            # if hero died to this area, display alt description
            if hero.deaths.include?(rand_area["id"])
                puts rand_area["died_description"]
            # else display normal description
            else
                puts rand_area["base_description"]
            end
            
            sleep 2
    
            if hero.deaths.include?(rand_enc["id"])
                puts rand_enc["died_description"] + "\n\n"
            # else display normal description
            else
                puts rand_enc["base_description"] + "\n\n"
            end
    
            sleep 2
            
            item_list = []
            hero.inventory.each {|item| item_list << item}
            # item_list << "Create New Save"
        
            item_prompt = TTY::Prompt.new(active_color: :red)
            question = "You have the following items available, what do you choose?:\n"
            # choices = [item_action1, item_action2, item_action3]
            item = item_prompt.select(question, item_list)
            system("clear")
            
            puts "You use your #{item} against the #{rand_enc["id"]}!\n\n"
            
            condition = ""
            if item == rand_enc["success_condition"]["item"]
                condition = "success_condition"
            elsif item == rand_enc["neutral_condition"]["item"]
                condition = "neutral_condition"
            else
                condition = "failure_condition"
            end
            
            # encounter result
            puts rand_enc[condition]["description"] + "\n"

            #incr health
            hero.health += rand_enc[condition]["benefit"]["health"]
            #decr health
            hero.health -= rand_enc[condition]["loss"]["health"]
    
            #incr sanity
            hero.sanity += rand_enc[condition]["benefit"]["sanity"]
            #decr sanity
            hero.sanity -= rand_enc[condition]["loss"]["sanity"]
    
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
    
            num_areas += 1
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
                    hero.inventory = ["revolver"]
                end
            end
    
            #update save file 
            master_save.find do |save_game| save_game["name"] == hero
                if save_game["name"] == hero.name
                    save_game["inventory"] = hero.inventory
                    save_game["deaths"] = hero.deaths
                end
            end
    
            # save to file
            File.write("save.json", JSON.generate(master_save))
    
            
            # if won the game
            if dead == false && num_areas > 7
                prompt = TTY::Prompt.new(active_color: :red)
                status = "You have escaped the forest!\n"
                choices = ["Back to Title Screen"]
                answer = prompt.select(status, choices)

                system("clear")
                return

            # if dead
            elsif dead == true
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


def generate_savegames
    save_games = JSON.parse(File.read("save.json", symbolize_names: true))
    return save_games
end

class NotAlpha < StandardError
    def initialize(msg = "Invalid Input: Name must only use standard alpha characters a-z and A-Z")
        super(msg)
    end
end

class DuplicateName < StandardError
    def initialize(msg = "Invalid Name: Another save game already has this name, choose another")
        super(msg)
    end
end

def check_if_alpha(input)
    input =~ /[[:alpha:]]/
end

def alpha_err(result)
    raise NotAlpha if result == nil
end

def name_taken_err
    raise DuplicateName
end

system("clear")

# initialise save variables
save = []
save = generate_savegames
current_save = nil

#main title screen loop
loop do
    puts "Lost in the Woods"
    # puts Lost In The Woods in big ascii letters to the screen
    # also put trees and owls and stuff
    
    title_prompt = TTY::Prompt.new(active_color: :red)
    greeting = "\n"
    choices = ["Start", "Save-Games", "Help", "Exit"]
    answer = title_prompt.select(greeting, choices)
    
    system("clear")
    # start
    if answer == choices[0]
        if save == []
            # if there were no saves found
            puts "No Saves Found!\n\n"
            puts "Please input name for new save"
            final_input = ""
            # alphanumeric check loop
            loop do
                input = gets.chomp
                system("clear")
                begin
                    input.each_char {|char| alpha_err(check_if_alpha(char))}
                    final_input = input
                    break
                rescue => e 
                    puts e.message
                end
            end
    
            # initialise new save
            new_save = {
                name: final_input,
                health: 100,
                sanity: 100,
                inventory: ["revolver", "cross", "trinket"],
                deaths: []
            }
    
            puts "New save added!"
            save << new_save
            File.write("save.json", JSON.generate(save))

            title_prompt = TTY::Prompt.new(active_color: :red)
            wake_up = "Wake Up?"
            choices = ["Yes", "Back to Title Screen"]
            answer = title_prompt.select(wake_up, choices)
            system("clear")

            if answer == choices[0]
                puts "Currently playing as #{final_input}"
                sleep 1
                system("clear")

                # begin main game loop
                main_game_loop(save, current_save)
            end
        else
            # if there are save games available
            save_games = []
            save.each {|save| save_games << save["name"]}
            save_games << "Create New Save"
    
            title_prompt = TTY::Prompt.new(active_color: :red)
            greeting = "Choose a Save Game:\n"
            # choices = [item_action1, item_action2, item_action3]
            answer = title_prompt.select(greeting, save_games)
            system("clear")
    
            if answer == save_games[save_games.length - 1]
                puts "Please input name for new save"
                final_input = ""
                # alphanumeric check loop
                loop do
                    input = gets.chomp
                    system("clear")
                    begin
                        # check if name uses alpha char
                        input.each_char {|char| alpha_err(check_if_alpha(char))}

                        # check if name already taken
                        save.each {|save_game| name_taken_err if save_game["name"] == input}
                        # else
                        final_input = input
                        break
                    rescue => e 
                        puts e.message
                        puts "Please input name for new save"
                    end
                end
    
                # initialise new save
                new_save = {
                    name: final_input,
                    health: 100,
                    sanity: 100,
                    inventory: ["revolver"],
                    deaths: []
                }
    
                puts "New save added!"
                save << new_save
                File.write("save.json", JSON.generate(save))
    
                # set current save to save game
                current_save = save.find {|save_game| save_game["name"] == final_input}

                # wake up prompt
                title_prompt = TTY::Prompt.new(active_color: :red)
                wake_up = "Wake Up?"
                choices = ["Yes", "Back to Title Screen"]
                answer = title_prompt.select(wake_up, choices)
                system("clear")

                if answer == choices[0]
                    puts "Currently playing as #{final_input}"
                    sleep 1
                    system("clear")

                    # begin main game loop
                    main_game_loop(save, current_save)
                end
            else
                # set current save to save game
                current_save = save.find {|save_game| save_game["name"] == answer}
                
                # wake up prompt
                title_prompt = TTY::Prompt.new(active_color: :red)
                wake_up = "Wake Up?"
                choices = ["Yes", "Back to Title Screen"]
                selection = title_prompt.select(wake_up, choices)
                system("clear")

                if selection == choices[0]
                    puts "Currently playing as #{answer}"
                    sleep 1
                    system("clear")

                    # begin main game loop
                    main_game_loop(save, current_save)
                end
            end
        end
    elsif answer == choices[1]
        loop do
            puts "Warning, this menu is for deleting save games, choose the last option to return to Title Screen.\n\n"
            save = generate_savegames
            save_games = []
            save.each {|save| save_games << save["name"]}
            save_games << "Back to Title Screen"

            title_prompt = TTY::Prompt.new(active_color: :red)
            greeting = "Delete a Save Game:\n"
            answer = title_prompt.select(greeting, save_games)
            system("clear")

            if answer != save_games[save_games.length - 1]
                current_save = save.find {|save_game| save_game["name"] == answer}
    
                # double check!
                title_prompt = TTY::Prompt.new(active_color: :red)
                greeting = "Are you sure?\n"
                choices = ["Yes", "No"]
                answer = title_prompt.select(greeting, choices)
                system("clear")

                if answer == "Yes"
                    save.delete(current_save)
                    File.write("save.json", JSON.generate(save))
                    puts "Save Deleted!\n\n"
                end
            else
                system("clear")
                break
            end
        end

    # help
    elsif answer == choices[2]
        puts "Help Screen\n\n"
        item_action1 = "Back to Title Screen"
    
        title_prompt = TTY::Prompt.new(active_color: :red)
        help_display = "This is place holder text for the help screen,\n which will detail to the user how to interact with the game,\n what the goal is, etc\n\n"
        choices = item_action1
        answer = title_prompt.select(help_display, choices)
        system("clear")
    
    # exit
    elsif answer == choices[3]
        exit
    end
end