function splitNumberToBase(num, maxVal)
    if num <= maxVal then
        return {num}
    end
    local values = {}
    repeat
        values[#values+1] = math.floor(num/maxVal)
        num = num - (math.floor(num/maxVal)*maxVal)
    until num <= maxVal
    values[#values+1] = num
    return values
end
