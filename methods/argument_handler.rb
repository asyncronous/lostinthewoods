def not_special_arg(arg)
    case arg
    when "-h"
        return false
    when "--help"
        return false
    when "-v"
        return false
    when "--verbose"
        return false
    when "-vh"
        return false
    when "-b"
        return false
    when "--bundle"
        return false
    else
        return true
    end
end