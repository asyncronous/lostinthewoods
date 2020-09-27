class DuplicateName < StandardError
    def initialize(msg = "Invalid Name: Another save game already has this name, choose another")
        super(msg)
    end
end

def name_taken_err
    raise DuplicateName
end