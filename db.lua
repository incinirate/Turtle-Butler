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
No reserved chars! :D
]]

os.loadAPI("specialnumber")

function newDatabase(name, numOfColumns, columnBytes, initialInfo)
    local handle = fs.open(name..".db","wb")
    local structure = {numOfColumns, columnBytes}
    if not initialInfo then initialInfo = {} end
    overwriteDatabase(handle, structure, initialInfo)
    handle.close()
end

function writeRawToDatabase(handle, ...)
    local info = {...}
    for k,v in ipairs(info) do
        if type(v)=="number" then handle.write(v) end
    end
end

function overwriteDatabase(handle, structure, workingTable)
    writeRawToDatabase(handle, structure[1], unpack(structure[2]))
    for k,v in ipairs(workingTable) do
        for kk,vv in ipairs(v) do
            local numTab = specialnumber.splitNumberToBase(vv,255)
            for i=1,structure[2][kk]-#numTab do
                table.insert(numTab, 1, 0)
            end
            for kkk,vvv in ipairs(numTab) do
                writeRawToDatabase(handle, vvv)
            end
            --writeRawToDatabase(handle, 255) <No longer needed
        end
        --writeRawToDatabase(handle, 255) <No longer needed
    end
end

function parseDatabaseToTable(name)
    local handle = fs.open(name..".db","rb")
    local workingTable = {}
    local numOfColumns = handle.read()
    local columnBytes = {}
    local totalColumnBytes = 0
    for i=1,numOfColumns do
        table.insert(columnBytes, handle.read())
        totalColumnBytes = totalColumnBytes + columnBytes[#columnBytes]
    end
    local cByte = handle.read()
    local function nextB()
        cByte = handle.read()
    end
    while (cByte) do
        workingTable[#workingTable+1] = {}
        local rowBytesRead = 0
        local columnOn = 1
        while rowBytesRead < totalColumnBytes do
            local bytes = {}
            for i=1,columnBytes[columnOn] do
                bytes[#bytes+1] = cByte
                nextB()
            end
            local value = 0
            for i=1,#bytes do
                value = value + (bytes[i] * (255^(#bytes-i)))
            end
            table.insert(workingTable[#workingTable],value)
            rowBytesRead = rowBytesRead + columnBytes[columnOn]
            columnOn = columnOn + 1
        end
    end
    handle.close()
    return workingTable    
end

function appendEntry(name, entry)
    local handle = fs.open(name..".db","ab")
    for kk,vv in ipairs(handle) do
        local numTab = specialnumber.splitNumberToBase(vv,255)
        for kkk,vvv in ipairs(numTab) do
            writeRawToDatabase(handle, vvv)
        end
    end
    --writeRawToDatabase(handle, 255) <No longer needed
    handle.close()
end
