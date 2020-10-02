require "tty-prompt"
require "rainbow"

require_relative "../methods/sanity_methods"

class Hero
  attr_reader :health, :sanity, :deaths

  def initialize(name, inventory, deaths)
    @name = name
    @health = 100
    @sanity = 100
    @inventory = inventory
    @deaths = deaths
  end

  def save_returner(save_game)
    if save_game["name"] == @name
      save_game["inventory"] = @inventory
      save_game["deaths"] = @deaths
      return save_game
    else
      return nil
    end    
  end

  def display_stats
    return "health: #{@health} | sanity: #{@sanity} | inventory: #{@inventory.join(", ")}\n"
  end

  def get_inventory
    return @inventory
  end

  def remove_items(items)
    items.each { |item| @inventory.delete(item) }
  end

  def hero_died(encounter_area)
    sleep 1.5
    if @deaths.include?(encounter_area["id"])
      if_insane_slow(@sanity, encounter_area["died_description"])
    else # else display normal description
      if_insane_slow(@sanity, encounter_area["base_description"])
    end
  end

  def compute_result(item, encounter)
    case item
    when encounter["success_condition"]["item"]
      condition = "success_condition"
      if_insane_slow(@sanity, encounter[condition]["description"])
      return condition
    when encounter["neutral_condition"]["item"]
      condition = "neutral_condition"
      if_insane_slow(@sanity, encounter[condition]["description"])
      return condition
    else
      condition = "failure_condition"
      Rainbow(if_insane_slow(@sanity, encounter[condition]["description"])).red
      return condition
    end
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
    a = AsciiArt.new("./files/scary_woods3.jpg")
    b = AsciiArt.new("./files/scary_woods_low_sanity.jpg")
    woods = woods_swapper(@sanity, a, b)

    items_add.each do |item|
      if @inventory.include?(item) == false
        if @inventory.length >= 8
          item_list = []
          @inventory.each { |i| item_list << i }
          item_list << "Leave item"

          item_to_swap = prompt.select("Your inventory is full, choose an item to swap for #{item}:\n", item_list, per_page: 9, symbols: { marker: ">" })
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
