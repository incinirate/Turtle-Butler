--[[

/*--------------------------*\
|                            |
| DataBase Controller System |
|   Written By Bryan Becar   |
|       Copyright 2016       |
|                            |
\*--------------------------*/

]]

--[[
reservered characters:
255-seperation character
254-entry END
]]

os.loadAPI("specialnumber")

function newDatabase(name,initialInfo)
    local handle = fs.open(name..".db","wb")
    if initialInfo then
        overwriteDatabase(handle, initialInfo)
    end
    handle.close()
end

function writeRawToDatabase(handle, ...)
    local info = {...}
    for k,v in ipairs(info) do
        if type(v)=="number" then handle.write(v) end
    end
end

function overwriteDatabase(handle, workingTable)
    for k,v in ipairs(workingTable) do
        for kk,vv in ipairs(v) do
            local numTab = specialnumber.splitNumberToBase(vv,253)
            for kkk,vvv in ipairs(numTab) do
                writeRawToDatabase(handle, vvv)
            end
            writeRawToDatabase(handle, 255)
        end
        writeRawToDatabase(handle, 254)
    end
end

function parseDatabaseToTable(name)
    local handle = fs.open(name..".db","rb")
    local workingTable = {}
    local cByte = handle.read()
    local function nextB()
        cByte = handle.read()
    end
    while (cByte) do
        workingTable[#workingTable+1] = {}
        while (cByte ~= 254) do
            local bytes = {}
            while (cByte ~= 255) do
                bytes[#bytes+1] = cByte
                nextB()
            end
            local value = 0
            for i=1,#bytes do
                value = value + (bytes[i] * (253^(#bytes-i)))
            end
            table.insert(workingTable[#workingTable],value)
            nextB()
        end
        nextB()
    end
    handle.close()
    return workingTable    
end

function appendEntry(name, entry)
    local handle = fs.open(name..".db","ab")
    for kk,vv in ipairs(handle) do
        local numTab = specialnumber.splitNumberToBase(vv,253)
        for kkk,vvv in ipairs(numTab) do
            writeRawToDatabase(handle, vvv)
        end
        writeRawToDatabase(handle, 255)
    end
    writeRawToDatabase(handle, 254)
    handle.close()
end
