-- http://lua-users.org/wiki/FileInputOutput

-- see if the file exists
function file_exists(file)
  local f = io.open(file, "rb")
  if f then f:close() end
  return f ~= nil
end

function split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

-- returns an iterator over a table that iterates over the keys in alphabetic order
function pairsByKeysAlphabetic (t, f)
      local a = {}
      for n in pairs(t) do table.insert(a, n) end
      table.sort(a, f)
      local i = 0      -- iterator variable
      local iter = function ()   -- iterator function
        i = i + 1
        if a[i] == nil then return nil
        else return a[i], t[a[i]]
        end
      end
      return iter
    end

-- get all lines from a file, returns an empty 
-- list/table if the file does not exist
function splitContextFromLines(file)
  if not file_exists(file) then return {} end
  lines = {}
  --table.insert(groups, {key = "Ungrouped", value = 10000})
  contexts = {}
  counterContexts = 0
  for line in io.lines(file) do
  	if string.match(line, "@") then
		lineSplitted = split(line, "@")
		--lineSplitted[2] = lineSplitted[2]:sub(1,-2) -- last character is always a space, remove it
		if contexts[lineSplitted[2]] == nil then
			counterContexts = counterContexts + 1
			contexts[lineSplitted[2]] = counterContexts
			lines[counterContexts] = {}
		end

		table.insert(lines[contexts[lineSplitted[2]]], lineSplitted[1])
  	else
  		if contexts["Other"] == nil then
  			contexts["Other"] = 10000
  			lines[10000] = {}
  		end
		table.insert(lines[10000], line)
  	end


	
  end

  return lines, contexts--groups
end

function splitGroupsFromLines(input)
	lines = {}
	--table.insert(groups, {key = "Ungrouped", value = 10000})
	groups = {}  
	counterGroups = 0
	for key, line in pairs(input) do
		if string.match(line, "+") then	
			lineSplitted = split(line, "+")
			--print(lineSplitted[1])
			lineSplitted[2] = lineSplitted[2]:sub(1,-2) -- last character is always a space, remove it
			if groups[lineSplitted[2]] == nil then
				counterGroups = counterGroups + 1
				groups[lineSplitted[2]] = counterGroups
				lines[counterGroups] = {}		
			end
			table.insert(lines[groups[lineSplitted[2]]], lineSplitted[1])
		else
			if groups["Ungrouped"] == nil then
				groups["Ungrouped"] = 10000
				lines[10000] = {}		
			end
			table.insert(lines[10000], line)
		end
	end
	return lines, groups
end

function conky_getTodos()
	tmp = ""
	local file = '/home/michiel/todo.txt'
	local lines, contexts = splitContextFromLines(file)
	local groups = {}
	local tmpLines = {}
	local first = true

    for context,v in pairsByKeysAlphabetic(contexts) do
		tmp = tmp .. "${color2}${font bold:pixelsize=17}${voffset 15}"..context.."${goto 175}${hr 1}${font}\t\t\t\t\n"
		--table.sort(v)
		tmpLines, groups = splitGroupsFromLines(lines[v])
		first = true
		for group, v2 in pairsByKeysAlphabetic(groups) do
			if first then
				tmp = tmp .. "\t\t\t\t${color3}${font bold:pixelsize=13}${voffset 8}"..group..":${font}\t\t\t\t"
				first = false
			else 
				tmp = tmp .. "\t\t\t\t${color3}${font bold:pixelsize=13}${voffset 2}"..group..":${font}\t\t\t\t"

			end
			
			for k3, description in ipairs(tmpLines[v2]) do
				result = tmp .. "${color}${alignr}".. description 
				tmp = tmp .. "${color}${alignr}".. description .."\n"
			end

		end

	end 
result = tmp
	return result
end
-- print(conky_getTodos())
-- print all line numbers and their contents
--for k,v in pairs(lines) do
--	print("${color2}${voffset 8}"..k..":")
--	table.sort(v)
--	for k2,v2 in pairs(v) do
--		print("${color}${alignr}".. v2)
--	end
--end
