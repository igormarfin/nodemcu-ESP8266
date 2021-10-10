wifi.setmode(wifi.STATION)

---wifi.sta.autoconnect(1)

---wifi.sta.config("XXX", "YYY")

function scan_ap(t)
    print("Scan....")
    for k, v in pairs(t) do
      print(k..","..v)
    end
end

-----------------------------------------------
--- Set Variables ---
-----------------------------------------------
--- AP Search Params ---
ap_list_cfg={}
--- Enter SSID, use nil to list all SSIDs ---
ap_list_cfg.ssid=nil
--- Enter BSSID, use nil to list all SSIDs ---
ap_list_cfg.bssid=nil
--- Enter Channel ID, use 0 to list all channels ---
ap_list_cfg.channel=0
--- Use 0 to skip hidden networks, use 1 to list them ---
ap_list_cfg.show_hidden=1

--- AP Table Format ---
--- 1 for Output table format - (BSSID : SSID, RSSI, AUTHMODE, CHANNEL)
--- 0 for Output table format - (SSID : AUTHMODE, RSSI, BSSID, CHANNEL)
ap_list_table_format = 1

-----------------------------------------------

--- Print Output ---
function print_AP_List(ap_table)
 for p,q in pairs(ap_table) do
 print(p.." : "..q)
 end
end


print("wifi init")


mytimer = tmr.create()
mytimer:register(5000, tmr.ALARM_SINGLE, function (t) print("expired"); t:unregister() end)
mytimer:start()

if not tmr.create():alarm(5000, tmr.ALARM_SINGLE, function()
  print("hey there")
end)
then
  print("whoopsie")
end


print("wifi init2")


if not tmr.create():alarm(7000, tmr.ALARM_SINGLE, function()
  print("hey there")
  tmr.wdclr()
  wifi.sta.getap(ap_list_cfg,ap_list_table_format, print_AP_List)

end)
then
  print("whoopsie")
end


tmr.wdclr()
print("wifi init3")

mytimer = tmr.create()
mytimer:register(8000, tmr.ALARM_SINGLE, function() print("hey there") end)
if not mytimer:start() then print("uh oh") end




---while 1 do
---tmr.wdclr()
---tmr.delay(10000000)
---print(tmr.now())
---print(tmr.now())
---end

print("done")
