
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
    print(string.format("IP: %s",wifi.sta.getip()))
    t:unregister()
  end
end)
then
  print("whoopsie")
end

---tmr.delay(10000000)
