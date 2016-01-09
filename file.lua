function read(path)
  local file = fs.open(path,"r")
  contents = file.readAll()
  file.close()
  return contents
end

function write(path,value)
  local file = fs.open(path,"w")
  file.write(value)
  file.close()
end

function append(path,value)
  local file = fs.open(path,"a")
  file.write(value)
  file.close()
end