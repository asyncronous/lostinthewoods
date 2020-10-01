# #argument handling
require 'optparse'
require_relative "methods/title_loop"
require_relative "methods/argument_handler"

args = ARGV.clone
@options = {}

# ARGV.each { |opt| process_argv(opt)}
op = OptionParser.new do |opts|
    opts.on("-v", "--verbose", "Show indepth description of game!") do
      @options[:verbose] = true
    end
end

op.parse!
if @options[:verbose] == true
  puts "Game Description\n"
  puts "Lost in the Woods is a ruby interpreted terminal app text adventure. I was inspired to make a game reminiscent of the Goosebumps choose your own adventure horror books where there were a million ways to die. So you've been warned, it's mostly a game of trial and error to figure out which item should be used in which encounter. Have fun!\n\n"
  
  puts "Additional note: If you know what save game you want to play you can pass it through as an argument when running the shell script i.e. './lostinthewoods.sh SaveGame'."
  puts "Only the first argument will be considered, and if the save game name does not match any preexisting save games the regular title screen will be shown.\n\n"
  puts "Press Enter to Continue"
  ARGV.clear
  gets
end

# get first argument and run program
args_new = []
args.each { |element| args_new << element if not_special_arg(element) }
ARGV.clear
title_looper(args_new[0])