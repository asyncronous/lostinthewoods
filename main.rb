require 'highline/import'
require 'tty-prompt'

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
    loop do
        # check for previous save files
        # if there are no previous save files ask for input from user to create new file
        # add new entry to save files and enter game loop
        # else if there are previous save files, present each save file as an option, as well as "empty save file"
        # if chooses previous save files enter game loop
        # if chooses new save files ask user for input from user to create new save file
        # add new entry to save files and enter game loop
    end
# help
elsif answer == choices[1]
    puts "Helpme!"

# exit
elsif answer == choices[2]
    exit
end