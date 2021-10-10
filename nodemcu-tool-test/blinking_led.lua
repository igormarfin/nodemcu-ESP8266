local blinking_settings = {
  pin = 6,
  interval = 1000
}
gpio.mode(blinking_settings.pin, gpio.OUTPUT)

return function()
  local state =  gpio.HIGH
  gpio.write(blinking_settings.pin,state)
  local t = tmr.create()
  t:register(blinking_settings.interval, tmr.ALARM_AUTO,function()
    if state == gpio.HIGH then
      state = gpio.LOW
    else
      state = gpio.HIGH
    end
    gpio.write(blinking_settings.pin,state)
  end)
  t:start()
  return t
end

--[[
  --- How to run:
  _t=dofile('blinking_led.lua')()
  _t:stop()
  _t:start()
  _t:unregister()
]]
