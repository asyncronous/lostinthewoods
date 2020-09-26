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

def main_game_loop(curr_save)
    # generate hero from save data
    hero = Hero.new(curr_save["name"], curr_save["inventory"], curr_save["deaths"])


end

# main

# puts Lost In The Woods in big ascii letters to the screen
# also put trees and owls and stuff

# if help is chosen display help information, then display menu with single option, Exit, which returns to title screen
# if exit is chosen terminate the application

save = []

def generate_savegames
    save_games = JSON.parse(File.read("save.json", symbolize_names: true))
    return save_games
end

class NotAlphaNumeric < StandardError
    def initialize(msg = "Invalid Input: Name must only use standard alpha-numeric characters a-z, A-Z, 0-9")
        super(msg)
    end
end

def check_if_alnum(input)
    input =~ /[[:alnum:]]/
end

def alphaNum_err(result)
    raise NotAlphaNumeric if result == nil
end

save = generate_savegames
current_save = nil

puts "Lost in the Woods\n\n"

loop do
    item_action1 = "Start"
    item_action2 = "Help"
    item_action3 = "Exit"
    
    title_prompt = TTY::Prompt.new(active_color: :red)
    greeting = "Title Screen\n"
    choices = [item_action1, item_action2, item_action3]
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
                begin
                    input.each_char {|char| alphaNum_err(check_if_alnum(char))}
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
                inventory: ["revolver"],
                deaths: []
            }
    
            puts "New save added!"
            save << new_save
            File.write("save.json", JSON.generate(save))
    
        else
            # if there are save games available
            save_games = []
            save.each {|save| save_games << save["name"]}
            save_games << "Create New Save"
    
            title_prompt = TTY::Prompt.new(active_color: :red)
            greeting = "Choose a Save Game:\n"
            # choices = [item_action1, item_action2, item_action3]
            answer = title_prompt.select(greeting, save_games)
    
            if answer == save_games[save_games.length - 1]
                puts "Please input name for new save"
                final_input = ""
                # alphanumeric check loop
                loop do
                    input = gets.chomp
                    begin
                        input.each_char {|char| alphaNum_err(check_if_alnum(char))}
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
                    inventory: ["revolver"],
                    deaths: []
                }
    
                puts "New save added!"
                save << new_save
                File.write("save.json", JSON.generate(save))
    
                # set current save to save game
                current_save = save.find {|save_game| save_game["name"] == final_input}
                puts "Currently playing as #{final_input}"

                sleep 1
                system("clear")
                # begin main game loop
                main_game_loop(current_save)
            else
                # set current save to save game
                current_save = save.find {|save_game| save_game["name"] == answer}
                puts "Currently playing as #{answer}"

                sleep 1
                system("clear")
                # begin main game loop
                main_game_loop(current_save)
            end
        end
        
    # help
    elsif answer == choices[1]
        puts "Help Screen\n\n"
        item_action1 = "Back to Title Screen"
    
        title_prompt = TTY::Prompt.new(active_color: :red)
        help_display = "This is place holder text for the help screen,\n which will detail to the user how to interact with the game,\n what the goal is, etc\n\n"
        choices = item_action1
        answer = title_prompt.select(help_display, choices)
        system("clear")
    
    # exit
    elsif answer == choices[2]
        exit
    end
end


# save = [
#     {
#         name: "ben",
#         inventory: ["rock", "book", "wand"]
#     },
#     {
#         name: "george",
#         inventory: ["rock", "book", "wand"]
#     }
# ]

# File.write("save.json", JSON.generate(save))

# save = JSON.parse(File.read("save.json", symbolize_names: true))

# save.each do |save_game|
#     name = save_game["name"]
#     init_string = "#{name} has "
#     inv = save_game["inventory"]
#     inv.each do |value|
#         init_string += value + " "
#     end

#     puts init_string
# end