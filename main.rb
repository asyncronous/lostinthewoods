#argument handling
require_relative 'methods/title_loop'
require_relative 'methods/argument_handler'

args = ARGV

if args.include?("-h") || args.include?("-help")
    puts "Help\n"
    puts "The following commands can be used as arguments for this application:\n-h, --help, -v, --verbose, --vh\n"
    puts "-h, --help or -vh will display these help messages.\n\n"
    puts "-v, --verbose or -vh will display a description of the program\n\n"
    puts "To run the game proper do not pass any of the above arguments."

    puts "Finally: If you know what save game you want to play you can pass it through as an argument i.e. './litw.sh SaveGame'."
    puts "Only the first argument will be considered, and if the save game name does not match any preexisting save games the regular title screen will be shown.\n\n"

elsif args.include?("-v") || args.include?("--verbose")
    puts "Game Description\n"
    puts "Lost in the Woods is a ruby interpreted terminal app text adventure. I was inspired to make a game reminiscent of the Goosebumps choose your own adventure horror books where there were a million ways to die. So you've been warned, it's mostly a game of trial and error to figure out which item should be used in which encounter. Have fun!"

elsif args.include?("-vh") || args.include?("-hv") 
    puts "Help\n"
    puts "The following commands can be used as arguments for this application:\n-h, --help, -v, --verbose, --vh\n"
    puts "-h, --help or -vh will display these help messages.\n\n"
    puts "-v, --verbose or -vh will display an description of the program\n\n"
    puts "To run the game proper do not pass any of the above arguments."

    puts "Finally: If you know what save game you want to play you can pass it through as an argument i.e. './litw.sh SaveGame'."
    puts "Only the first argument will be considered, and if the save game name does not match any preexisting save games the regular title screen will be shown.\n\n"

    puts "Game Description\n"
    puts "Lost in the Woods is a ruby interpreted terminal app text adventure. I was inspired to make a game reminiscent of the Goosebumps choose your own adventure horror books where there were a million ways to die. So you've been warned, it's mostly a game of trial and error to figure out which item should be used in which encounter. Have fun!"
else
    # get first argument and run program
    args_new = []
    args.each {|element| args_new << element if not_special_arg(element)}
    ARGV.clear
    title_looper(args_new[0])
end