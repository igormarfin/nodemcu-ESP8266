--[[
-- a simple HTTP server
srv = net.createServer(net.TCP)
srv:listen(80, function(conn)
	conn:on("receive", function(sck, payload)
		print(payload)
		sck:send("HTTP/1.0 200 OK\r\nContent-Type: text/html\r\n\r\n<h1> Hello, NodeMCU.</h1>")
	end)
	conn:on("sent", function(sck) sck:close() end)
end)


-- connect to WiFi access point
wifi.setmode(wifi.STATION)
wifi.sta.config{ssid="EasyBox-05B843", pwd="r590Qf.er1"}
print(string.format("IP: %s",wifi.sta.getip()))
--]]

--[[

-- connect to WiFi access point
wifi.setmode(wifi.STATION)
wifi.sta.config{ssid="EasyBox-05B843", pwd="r590Qf.er1"}
print(string.format("IP: %s",wifi.sta.getip()))
--]]



print(string.format("IP: %s",wifi.sta.getip()))

srv = net.createServer(net.TCP)
srv:listen(8080, function(conn)
	conn:on("receive", function(sck, payload)
		print(payload)
		sck:send("HTTP/1.0 200 OK\r\nContent-Type: text/html\r\n\r\n<h1> Hello, NodeMCU.</h1>")
	end)
	conn:on("sent", function(sck) sck:close() end)
end)
