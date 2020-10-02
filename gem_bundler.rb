require "bundler/inline"

bundler_installed = system("gem list bundler -i")

if bundler_installed == true
  puts "Bundler gem is installed!"
  # install gems on first load if Gemfile.lock is not installed and if user inputs Y
  if File.exist?("Gemfile.lock") == false
    puts "Install gems using bundler? (Y/N)"
  
    if (gets.chomp == "Y")
      puts "Installing dependencies using bundler"
      system("bundle install")
    end
  else
    puts "Gems already installed"
    puts "Run ./lostinthewoods.sh to play"
  end
else
  puts "Bundler gem is not installed! Install bunder gem? (Y/N)"
  if gets.chomp == "Y"
    system("gem install bundler")
    puts "Bundler is now installed."
    puts "Please rerun this installer to install gem dependencies using bundler."
  end
end