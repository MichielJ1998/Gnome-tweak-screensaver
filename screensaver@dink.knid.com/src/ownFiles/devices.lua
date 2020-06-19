-- http://lua-users.org/wiki/FileInputOutput


function conky_getDevices()
	tmp = ""
	--local wifi = true


	os.execute("ls -1a /media/michiel > .devicesTMP")

	tmp = ""

	for line in io.lines(".devicesTMP") do
  		if line ~= "." and line ~= ".." then
  			tmp = tmp .. "${color2}${font bold:pixelsize=13}${voffset 2}".. line ..":${font}${color} ${alignr}${fs_used /media/michiel/".. line .."} / ${fs_size /media/michiel/".. line .."}\n"
  			tmp = tmp .. "${font}${color}${voffset 2} ${alignr}${offset -10}${fs_used_perc /media/michiel/".. line .."}%${alignr}${fs_bar 10,69 /media/michiel/".. line .."}\n"
  		end
	end

result = tmp
	return result
end

-- print(conky_getDevices())

-- ${color2}${font bold:pixelsize=13}${voffset 2}HDD - home:${font}${color} ${alignr}${fs_used /home/michiel} / ${fs_size /home/michiel}
-- ${font}${color}${voffset 2} ${alignr}${offset -10}${fs_used_perc /home/michiel}%${alignr}${fs_bar 10,69 /home/michiel}