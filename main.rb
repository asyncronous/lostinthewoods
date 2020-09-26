require 'highline/import'
require 'tty-prompt'
require 'json'

# main

# puts Lost In The Woods in big ascii letters to the screen
# also put trees and owls and stuff

# if start is chosen enter loop
# check for previous save files
# if there are no previous save files ask for input from user to create new file
# add new entry to save files and enter game loop
# else if there are previous save files, present each save file as an option, as well as "empty save file"
# if chooses previous save files enter game loop
# if chooses new save files ask user for input from user to create new save file
# add new entry to save files and enter game loop

# if help is chosen display help information, then display menu with single option, Exit, which returns to title screen
# if exit is chosen terminate the application

save = []

def generate_savegames
    begin
        save = JSON.parse(File.read("save.json", symbolize_names: true))
    rescue

    end
    # save.each do |save_game|
    #     name = save_game["name"]
    #     init_string = "#{name} has "
    #     inv = save_game["inventory"]
    #     inv.each do |value|
    #         init_string += value + " "
    #     end

    #     puts init_string
    # end
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

generate_savegames

puts "Lost in the Woods\n\n"

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
        puts "Save games\n"
        puts "No Saves Found!\n\n"

        puts "Please input name for new save"

        # alphanumeric check loop
        loop do
            input = gets.chomp
            begin
                input.each_char {|char| alphaNum_err(check_if_alnum(char))}
                break
            rescue => e 
                puts e.message
            end

        end


    else
        puts "has save"
    end
    
    # loop do
    #     # check for previous save files
    #     # if there are no previous save files ask for input from user to create new file
    #     # add new entry to save files and enter game loop
    #     # else if there are previous save files, present each save file as an option, as well as "empty save file"
    #     # if chooses previous save files enter game loop
    #     # if chooses new save files ask user for input from user to create new save file
    #     # add new entry to save files and enter game loop
    # end
# help
elsif answer == choices[1]
    puts "Helpme!"

# exit
elsif answer == choices[2]
    exit
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