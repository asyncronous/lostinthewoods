README

Before continuing ensure you are running either Windows Subsystem for Linux (WSL) or Mac OS with a ruby interpreter such as rbenv installed. 

1. Please enter 'gem install bundler' in the terminal if you do not have the ruby bundler gem installed
2. Please run './installer.sh' from the terminal in this folder to install gem dependencies
    2a. If this fails please refer to the ruby Gemfile in this folder and install the prerequisite gems
3. Please run ./lostinthewoods.sh to run the program. Run ./lostinthewoods.sh --help for help information.

Features: 
Lost in the Woods is a ruby interpreted terminal app text adventure. 
The game includes persistent save games, a randomly generated (each element pre-written) series of encounters and areas in a dark, foreboding forest!
During the game loop the player will use items, gain or lose sanity and/or health, and gain or lose items from their inventory.
Finally, every time you die (for each save file) the game will remember and change the descriptions of enemy encounters and areas that you died to/in.