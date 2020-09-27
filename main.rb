# gems and libraries
require 'highline/import'
require 'tty-prompt'
require 'json'

# error classes and methods
require_relative 'classes/duplicate_name'
require_relative 'classes/empty_string'
require_relative 'classes/not_alpha'

# main game loop and its helper methods
require_relative 'methods/main_game_loop'
require_relative 'methods/choose_random'
require_relative 'methods/encounter_results'

system("clear")

#main title screen loop
loop do
    puts "Lost in the Woods"
    # puts Lost In The Woods in big ascii letters to the screen
    # also put trees and owls and stuff
    
    # initialise save variables
    save = []
    save = JSON.parse(File.read("save.json", symbolize_names: true))
    current_save = nil
    
    # title screen menu
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
                    empty_err(input)
                    final_input = input
                    break
                rescue => e 
                    puts e.message
                    puts "Please input name for new save"
                end
            end
    
            # initialise new save
            new_save = {
                "name" => final_input,
                "health" => 100,
                "sanity" => 100,
                "inventory" => ["revolver", "cross", "trinket"],
                "deaths" => []
            }
    
            puts "New save added!"
            save << new_save
            File.write("save.json", JSON.generate(save))

            current_save = save.find {|save_game| save_game["name"] == final_input}

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
                        
                        # check empty input
                        empty_err(input)
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
                    "name" => final_input,
                    "health" => 100,
                    "sanity" => 100,
                    "inventory" => ["revolver", "cross", "trinket"],
                    "deaths" => []
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