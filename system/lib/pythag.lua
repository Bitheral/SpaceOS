function constrain(value, low, high)
    return math.max(math.min(value, high), low)
end

function map(value, currentStart, currentStop, targetStart, targetStop, withinBounds)
    new_value = (value - currentStart) / (currentStop - currentStart) * (targetStop - targetStart) + targetStart
    
    if not withinBounds then
        return new_value
    end

    if targetStart < targetStop then
        return constrain(new_value, targetStart, targetStop)
    else
        return constrain(new_value, targetStop, targetStart)
    end
end

function contains(arr, val)
    for index, value in ipairs(arr) do
        if value == val then
            return true
        end
    end

    return false
end