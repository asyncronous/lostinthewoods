require "bundler/inline"

# install gems on first load if Gemfile.lock is not installed and if user inputs Y
if File.exist?("Gemfile.lock") == false
  puts "Install gems using bundler? (Y/N)"
  input = gets.chomp

  if (input == "Y")
    puts "Installing dependencies using bundler"
    system("bundle install")
  end
else
  puts "Gems already installed"
end
