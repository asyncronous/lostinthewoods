class EmptyString < StandardError
    def initialize(msg = "Invalid Name: You didn't type anything!")
        super(msg)
    end
end

def empty_err(input)
    raise EmptyString if input == ""
end