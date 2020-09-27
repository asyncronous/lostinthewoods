class Hero
    attr_accessor :name, :health, :sanity, :inventory, :deaths

    def initialize(name, inventory, deaths)
        @name = name
        @health = 100
        @sanity = 100
        @inventory = inventory
        @deaths = deaths
    end
end