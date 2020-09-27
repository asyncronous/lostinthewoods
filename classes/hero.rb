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
end