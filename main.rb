# gems and libraries
# require 'highline/import'
require 'json'
require 'tty-prompt'
require 'asciiart'
require 'rainbow'

# error classes and methods
require_relative 'classes/duplicate_name'
require_relative 'classes/empty_string'
require_relative 'classes/not_alpha'

# main game loop and its helper methods
require_relative 'methods/main_game_loop'
require_relative 'methods/choose_random'
require_relative 'methods/encounter_results'

system("clear")
title_prompt = TTY::Prompt.new(active_color: :red)

#main title screen loop
loop do
    system("clear")
    a = AsciiArt.new("./files/title.png")
    puts Rainbow("#{a.to_ascii_art(width: 120)}").red
                                                                                            
    # initialise save variables
    save = []
    save = JSON.parse(File.read("./files/save.json", symbolize_names: true))
    current_save = nil
    
    # title screen menu
    answer = title_prompt.select("\n", ["Start", "Save-Games", "Help", "Exit"])
    
    system("clear")
    puts Rainbow("#{a.to_ascii_art(width: 120)}").red
    # start
    if answer == "Start"
        if save == []
            # if there were no saves found
            puts "No Saves Found!\n\n"
            puts "Please input name for new save"
            final_input = ""
            # alphanumeric check loop
            loop do
                input = gets.chomp
                system("clear")
                puts Rainbow("#{a.to_ascii_art(width: 120)}").red
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
            File.write("./files/save.json", JSON.generate(save))

            current_save = save.find {|save_game| save_game["name"] == final_input}

            answer = title_prompt.select("Wake Up?", ["Yes", "Back to Title Screen"])
            system("clear")
            puts Rainbow("#{a.to_ascii_art(width: 120)}").red

            if answer == "Yes"
                puts "Currently playing as #{final_input}"
                sleep 0.75
                system("clear")
                
                won = main_game_loop(save, current_save)
                    
                if won == "victory!"
                    save.delete(current_save)
                    File.write("./files/save.json", JSON.generate(save))
                end
            end
        else
            # if there are save games available
            save_games = []
            save.each {|save| save_games << save["name"]}
            save_games << "Create New Save"
    
            answer = title_prompt.select("Choose a Save Game:\n", save_games)
            system("clear")
            puts Rainbow("#{a.to_ascii_art(width: 120)}").red
    
            if answer == save_games[save_games.length - 1]
                puts "Please input name for new save"
                final_input = ""
                # alphanumeric check loop
                loop do
                    input = gets.chomp
                    system("clear")
                    puts Rainbow("#{a.to_ascii_art(width: 120)}").red
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
                File.write("./files/save.json", JSON.generate(save))

                # set current save to save game
                current_save = save.find {|save_game| save_game["name"] == final_input}

                # wake up prompt
                answer = title_prompt.select("Wake Up?", ["Yes", "Back to Title Screen"])
                system("clear")
                puts Rainbow("#{a.to_ascii_art(width: 120)}").red

                if answer == "Yes"
                    puts "Currently playing as #{final_input}"
                    sleep 0.75
                    system("clear")

                    won = main_game_loop(save, current_save)
                    
                    if won == "victory!"
                        save.delete(current_save)
                        File.write("./files/save.json", JSON.generate(save))
                    end
                end
            else
                # set current save to save game
                current_save = save.find {|save_game| save_game["name"] == answer}

                # wake up prompt
                selection = title_prompt.select("Wake Up?", ["Yes", "Back to Title Screen"])
                system("clear")
                puts Rainbow("#{a.to_ascii_art(width: 120)}").red

                if selection == "Yes"
                    puts "Currently playing as #{answer}"
                    sleep 1
                    system("clear")

                    # begin main game loop
                    won = main_game_loop(save, current_save)

                    if won == "victory!"
                        save.delete(current_save)
                        File.write("./files/save.json", JSON.generate(save))
                    end
                end
            end
        end
    elsif answer == "Save-Games"
        loop do
            puts "Warning, this menu is for deleting save games, choose the last option to return to Title Screen.\n\n"
            save_games = []
            save.each {|save| save_games << save["name"]}
            save_games << "Back to Title Screen"

            answer = title_prompt.select("Delete a Save Game:\n", save_games)
            system("clear")
            puts Rainbow("#{a.to_ascii_art(width: 120)}").red

            if answer != save_games[save_games.length - 1]
                current_save = save.find {|save_game| save_game["name"] == answer}
    
                # double check!
                answer = title_prompt.select("Are you sure?\n", ["Yes", "No"])
                system("clear")
                puts Rainbow("#{a.to_ascii_art(width: 120)}").red

                if answer == "Yes"
                    save.delete(current_save)
                    File.write("./files/save.json", JSON.generate(save))
                    puts "Save Deleted!\n\n"
                end
            else
                system("clear")
                break
            end
        end

    # help
    elsif answer == "Help"
        puts "Help Screen\n\n"
        answer = title_prompt.select("This is place holder text for the help screen,\n which will detail to the user how to interact with the game,\n what the goal is, etc\n\n", "Back to Title Screen")
        system("clear")
    
    # exit
    elsif answer == "Exit"
        system("clear")
        exit
    end
end