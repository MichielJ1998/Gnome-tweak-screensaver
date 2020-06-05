-- http://lua-users.org/wiki/FileInputOutput


function conky_getNetwork()
	tmp = ""
	--local wifi = true


	os.execute("nmcli con show | grep -n 1 | grep 2: | awk '{print $(NF)}' > .tmp")

	for line in io.lines(".tmp") do
  		device = line
	end

	if device == 'wlp3s0' then
		tmp = tmp .. "${color2}${font bold:pixelsize=13}${voffset 8}Wifi:${font}${color}\n"
		tmp = tmp .. "${offset 30}${color2}${font bold:pixelsize=13}${voffset 2}IP Address:${font}${color} ${alignr}${addrs wlp3s0}\n"
		tmp = tmp .. "${color2}${offset 30}${font bold:pixelsize=13}${voffset 2}Download:${font}${color} ${alignr}${offset -10$}${downspeed wlp3s0}${alignr}${upspeedgraph wlp3s0 10,69}\n"
		tmp = tmp .. "${color2}${offset 30}${font bold:pixelsize=13}${voffset 2}Upload:${font}${color} ${alignr}${offset -10$}${upspeed wlp3s0}${alignr}${upspeedgraph wlp3s0 10,69}"
	else
		tmp = tmp .. "${color2}${font bold:pixelsize=13}${voffset 8}Ethernet:${font}${color}\n"
		tmp = tmp .. "${offset 30}${color2}${font bold:pixelsize=13}${voffset 2}IP Address:${font}${color} ${alignr}${addrs enp2s0}\n"
		tmp = tmp .. "${color2}${offset 30}${font bold:pixelsize=13}${voffset 2}Download:${font}${color} ${alignr}${offset -10$}${downspeed enp2s0}${alignr}${upspeedgraph enp2s0 10,69}\n"
		tmp = tmp .. "${color2}${offset 30}${font bold:pixelsize=13}${voffset 2}Upload:${font}${color} ${alignr}${offset -10$}${upspeed enp2s0}${alignr}${upspeedgraph enp2s0 10,69}"
	end
result = tmp
	return result
end

