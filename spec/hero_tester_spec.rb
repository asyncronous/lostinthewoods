require 'rspec'
require_relative '../classes/hero'

describe Hero do 
   context "adjust health and sanity" do 
      it "should not let health or sanity go below 0" do 
         hero = Hero.new("Ben", ["sword", "dagger"], [])
         health_change = -200
         sanity_change = -200
         hero.adjust_stats(health_change, sanity_change)
         expect(hero.health && hero.sanity).to be 0
      end

      it "should not let health or sanity go above 100" do 
         hero = Hero.new("Ben", ["sword", "dagger"], [])
         health_change = 200
         sanity_change = 200
         hero.adjust_stats(health_change, sanity_change)
         expect(hero.health && hero.sanity).to be 100 
      end
   end

   context "change deaths and inventory on death" do 
      it "should add enc and area to deaths array" do 
         hero = Hero.new("Ben", ["sword", "dagger"], [])
         health_change = -200
         hero.adjust_stats(health_change, 0)
         enc = "zombie"
         area = "grass"
         hero.dead_checker(enc, area)
         expect(hero.deaths).to eq(["zombie", "grass"])
      end 

      it "should change inventory to default if sanity 0" do 
         hero = Hero.new("Ben", ["sword", "dagger"], [])
         health_change = -200
         sanity_change = -200
         hero.adjust_stats(health_change, sanity_change)
         enc = "zombie"
         area = "grass"
         hero.dead_checker(enc, area)
         expect(hero.get_inventory).to eq(["revolver", "cross", "trinket", "lamp"])
      end
      it "should leave inventory if sanity more than 0" do 
         hero = Hero.new("Ben", ["sword", "dagger"], [])
         health_change = -200
         # sanity_change = -200
         hero.adjust_stats(health_change, 0)
         enc = "zombie"
         area = "grass"
         hero.dead_checker(enc, area)
         expect(hero.get_inventory).to eq(["sword", "dagger"])
      end 
   end 
end