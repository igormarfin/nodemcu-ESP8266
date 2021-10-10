LEDpin = 12         -- Declare LED pin no.
delayuS = 500000   -- Set delay in microSecond. here 0.5 second

gpio.mode(LEDpin,gpio.OUTPUT)-- Set LED pin as GPIO output pin


---[[
while(1)           -- Define infinite while loop
do
gpio.write(LEDpin,gpio.HIGH)-- Set LED pin HIGH i.e. LED ON
tmr.delay(delayuS) -- timer Delay
gpio.write(LEDpin,gpio.LOW)-- Set LED pin LOW i.e. LED OFF
tmr.delay(delayuS) -- timer Delay
end
--]]

LEDpin = 12         -- Declare LED pin no.
gpio.mode(LEDpin,gpio.OUTPUT)-- Set LED pin as GPIO output pin
gpio.write(LEDpin,0)
---gpio.write(LEDpin,1)
print(gpio.read(LEDpin))



-- set pin index 1 to GPIO mode, and set the pin to high.
pin=6
gpio.mode(pin, gpio.OUTPUT)
gpio.write(pin, gpio.HIGH)
---gpio.write(pin, gpio.LOW)
print(gpio.read(pin))



-- set pin index 1 to GPIO mode, and set the pin to high.
pin=6
gpio.mode(pin, gpio.OUTPUT)
gpio.write(pin, gpio.HIGH)
gpio.write(pin, gpio.LOW)
print(gpio.read(pin))
