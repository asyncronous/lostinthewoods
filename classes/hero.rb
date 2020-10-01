require "tty-prompt"

class Hero
  attr_accessor :name, :health, :sanity, :inventory, :deaths

  def initialize(name, inventory, deaths)
    @name = name
    @health = 100
    @sanity = 100
    @inventory = inventory
    @deaths = deaths
  end

  def adjust_stats(h_change, s_change)
    @health += h_change
    @sanity += s_change

    if @health > 100
      @health = 100
    elsif @health < 0
      @health = 0
    end

    if @sanity > 100
      @sanity = 100
    elsif @sanity < 0
      @sanity = 0
    end
  end

  def item_add_swap(items_add)
    prompt = TTY::Prompt.new(active_color: :red)
    a = AsciiArt.new("./files/scary_woods2.jpg")
    b = AsciiArt.new("./files/scary_woods_low_sanity.jpg")
    woods = woods_swapper(@sanity, a, b)

    items_add.each do |item|
      if @inventory.include?(item) == false
        if @inventory.length >= 6
          item_list = []
          @inventory.each { |i| item_list << i }
          item_list << "Leave item"

          item_to_swap = prompt.select("Your inventory is full, choose an item to swap for #{item}:\n", item_list, per_page: 8, symbols: { marker: ">" })
          system("clear")
          puts woods.to_ascii_art(color: true, width: 100)

          if item_to_swap != "Leave item"
            answer = prompt.select("Are you sure?\n", ["Yes", "No"], symbols: { marker: ">" })
            system("clear")
            puts woods.to_ascii_art(color: true, width: 100)

            if answer == "Yes"
              @inventory.delete(item_to_swap)
              @inventory << item
            end
          end
        else
          @inventory << item
        end
      end
    end
  end

  def dead_checker(enc, area)
    dead = false
    if @health == 0
      # add death to deaths
      @deaths << enc
      @deaths << area
      dead = true
      #insane
      if @sanity == 0
        @inventory = ["revolver", "cross", "trinket", "lamp"]
      end
      return dead
    end
    return dead
  end
end
