print('Hello world from init')

wifi.setmode(wifi.STATION)
wifi.sta.config{ssid="EasyBox-05B843", pwd="r590Qf.er1"}


-- wait for an IP
cnt = 10
if not tmr.create():alarm(1000, tmr.ALARM_AUTO, function(t)
  print("hey there")
  if wifi.sta.getip()==nil then
    cnt = cnt-1
    if cnt<=0 then
      print "Not connected to wifi."
      t:unregister()
    end
  else
    print("\nStarting main")
   dofile("webserver80.lua")
   dofile("webserver8080.lua")
  ---  loadfile("webserver8080.lua")()

    print(string.format("IP: %s",wifi.sta.getip()))

    --- start LED_BUILTIN
    --- https://lowvoltage.github.io/2017/07/09/Onboard-LEDs-NodeMCU-Got-Two
    --- https://gist.github.com/jhorsman/6a93191ba31a48cf0cea75acd4c20cea
    gpio.mode(4,gpio.OUTPUT)
    gpio.write(4, 0)

    t:unregister()
  end
end)
then
  print("whoopsie")
end


--[[
srv = net.createServer(net.TCP)
srv:listen(80, function(conn)
	conn:on("receive", function(sck, payload)
		print(payload)
		sck:send("HTTP/1.0 200 OK\r\nContent-Type: text/html\r\n\r\n<h1> Hello, NodeMCU at the port 80</h1>")
	end)
	conn:on("sent", function(sck) sck:close() end)
end)
--]]
