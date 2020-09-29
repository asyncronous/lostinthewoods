# gems and libraries
require "json"
require "tty-prompt"
require "asciiart"
require "rainbow"

# error classes and methods
require_relative "../classes/duplicate_name"
require_relative "../classes/empty_string"
require_relative "../classes/not_alpha"

# main game loop and its helper methods
require_relative "main_game_loop"
require_relative "choose_random"
require_relative "encounter_results"

def title_looper(argument_save)
  system("clear")
  title_prompt = TTY::Prompt.new(active_color: :red)
  a = AsciiArt.new("files/title2.png")

  #main title screen loop
  loop do
    system("clear")
    puts a.to_ascii_art(color: true, width: 140)
    # puts Rainbow("#{a.to_ascii_art(color: true, width: 120)}").red

    # initialise save variables
    save = []
    save = JSON.parse(File.read("files/save.json", symbolize_names: true))
    current_save = nil

    # check if argument_save matches a save game, if it doesn't current_save will return nil and just go to title screen
    if argument_save != nil
      current_save = save.find { |save_game| save_game["name"] == argument_save }
    end

    #prompt
    answer = ""
    if current_save == nil
      answer = title_prompt.select("\n", ["Start", "Save-Games", "Help", "Exit"])
    else
      answer = "Fastload"
    end

    # title screen menu
    system("clear")
    puts a.to_ascii_art(color: true, width: 140)
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
          puts a.to_ascii_art(color: true, width: 140)
          begin
            input.each_char { |char| alpha_err(check_if_alpha(char)) }
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
          "inventory" => ["revolver", "cross", "trinket"],
          "deaths" => [],
        }

        puts "New save added!"
        save << new_save
        File.write("files/save.json", JSON.generate(save))

        current_save = save.find { |save_game| save_game["name"] == final_input }

        answer = title_prompt.select("Wake Up?", ["Yes", "Back to Title Screen"])
        system("clear")
        puts a.to_ascii_art(color: true, width: 140)

        if answer == "Yes"
          puts "Currently playing as #{final_input}"
          sleep 0.75
          system("clear")

          won = main_game_loop(save, current_save)

          if won == "victory!"
            save.delete(current_save)
            File.write("files/save.json", JSON.generate(save))
          end
        end
      else
        # if there are save games available
        save_games = []
        save.each { |save| save_games << save["name"] }
        save_games << "Create New Save"

        answer = title_prompt.select("Choose a Save Game:\n", save_games)
        system("clear")
        puts a.to_ascii_art(color: true, width: 140)

        if answer == save_games[save_games.length - 1]
          puts "Please input name for new save"
          final_input = ""
          # alphanumeric check loop
          loop do
            input = gets.chomp
            system("clear")
            puts a.to_ascii_art(color: true, width: 140)
            begin
              # check if name uses alpha char
              input.each_char { |char| alpha_err(check_if_alpha(char)) }

              # check if name already taken
              save.each { |save_game| name_taken_err if save_game["name"] == input }

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
            "inventory" => ["revolver", "cross", "trinket"],
            "deaths" => [],
          }

          puts "New save added!"
          save << new_save
          File.write("files/save.json", JSON.generate(save))

          # set current save to save game
          current_save = save.find { |save_game| save_game["name"] == final_input }

          # wake up prompt
          answer = title_prompt.select("Wake Up?", ["Yes", "Back to Title Screen"])
          system("clear")
          puts a.to_ascii_art(color: true, width: 140)

          if answer == "Yes"
            puts "Currently playing as #{final_input}"
            sleep 0.75
            system("clear")

            won = main_game_loop(save, current_save)

            if won == "victory!"
              save.delete(current_save)
              File.write("files/save.json", JSON.generate(save))
            end
          end
        else
          # set current save to save game
          current_save = save.find { |save_game| save_game["name"] == answer }

          # wake up prompt
          selection = title_prompt.select("Wake Up?", ["Yes", "Back to Title Screen"])
          system("clear")
          puts a.to_ascii_art(color: true, width: 140)

          if selection == "Yes"
            puts "Currently playing as #{answer}"
            sleep 1
            system("clear")

            # begin main game loop
            won = main_game_loop(save, current_save)

            if won == "victory!"
              save.delete(current_save)
              File.write("files/save.json", JSON.generate(save))
            end
          end
        end
      end
    # delete save screen
    elsif answer == "Save-Games"
      loop do
        puts "Warning, this menu is for deleting save games, choose the last option to return to Title Screen.\n\n"
        save_games = []
        save.each { |save| save_games << save["name"] }
        save_games << "Back to Title Screen"

        answer = title_prompt.select("Delete a Save Game:\n", save_games)
        system("clear")
        puts a.to_ascii_art(color: true, width: 140)

        if answer != save_games[save_games.length - 1]
          current_save = save.find { |save_game| save_game["name"] == answer }

          # double check!
          answer = title_prompt.select("Are you sure?\n", ["Yes", "No"])
          system("clear")
          puts a.to_ascii_art(color: true, width: 140)

          if answer == "Yes"
            save.delete(current_save)
            File.write("files/save.json", JSON.generate(save))
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

    # special condition when you enter save game as an argument in shell script launcher
    elsif answer == "Fastload"
      system("clear")
      puts a.to_ascii_art(color: true, width: 140)

      puts "Currently playing as #{argument_save}"
      sleep 0.75
      system("clear")

      won = main_game_loop(save, current_save)

      if won == "victory!"
        save.delete(current_save)
        File.write("files/save.json", JSON.generate(save))
      end
    end
  end
end
