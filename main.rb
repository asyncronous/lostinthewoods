#argument handling
require_relative 'methods/title_loop'
require_relative 'methods/argument_handler'

args = ARGV

if args.include?("-h") || args.include?("-help")
    puts "Help!\n"
    puts "The following commands can be used as arguments for this application:\n -h --help -v --verbose --vh\n\n"
    puts " -h, --help or -vh will display these help messages.\n\n"
    puts " -v, --verbose or -vh will display an description of the program\n\n"
    puts "Finally: If you know what save game you want to play on you can pass it through as an argument."
    puts "Only the first argument will be considered, and if the save game name does not match any preexisting save games the regular title screen will be shown.\n"

elsif args.include?("-v") || args.include?("--verbose")
    puts "Game Description\n"
    puts "Lost in the Woods is a ruby interpreted text adventure."

elsif args.include?("-vh")
    puts "Help\n"
    puts "The following commands can be used as arguments for this application:\n-h, --help, -v, --verbose, --vh\n"
    puts "-h, --help or -vh will display these help messages.\n\n"
    puts "-v, --verbose or -vh will display an description of the program\n\n"
    puts "Finally: If you know what save game you want to play on you can pass it through as an argument."
    puts "Only the first argument will be considered, and if the save game name does not match any preexisting save games the regular title screen will be shown.\n\n"

    puts "Game Description\n"
    puts "Lost in the Woods is a ruby interpreted text adventure."
else
    args_new = []
    args.each {|element| args_new << element if not_special_arg(element)}
    ARGV.clear
    title_looper(args_new[0])
end