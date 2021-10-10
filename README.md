# Simple Test of NODEMcu

There are two approaches:

1) Development of code in C and flashing with help of Arduino IDE
2) Using native firmware of  NodeMCU: Nodejs + Lua

I have a NodeMCU of a version `NodeMCU1.0 (ES-12E)`.

### Development using Arduino IDE

* download Arduino
  * https://www.arduino.cc/en/Main/Software

Unzip the archive into `arduino-nightly`

There is some troubleshooting of Serial Port in Linux:

* https://www.arduino.cc/en/Guide/Linux

##### Some knowledge about Boot and Flash modes for ESP8266 (old models):

Configuration of `GPIO0 and GPIO2 `

* https://www.instructables.com/id/ESP8266-Using-GPIO0-GPIO2-as-inputs/
* https://www.forward.com.au/pfod/ESP8266/GPIOpins/index.html`
* https://github.com/esp8266/esp8266-wiki/wiki/Boot-Process#esp-boot-modes

##### NodeMCU can be flashed via USB-to-TTL (UART) interface, read this carefully:

* check that USB-to-TTL has been recognized by kernel: `dmesg`

* https://www.instructables.com/id/NODEMcu-Usb-Port-Not-Working-Upload-the-Code-Using/

* Important to know

```
If we now try to upload the code, it will still show the error as shown in the image.
So as to successfully upload the code using the USB to TTL module, first press the flash button and while you keep the flash button pressed, press the reset button, and then release them together.
```

##### NodeMCU is usually flashed via CH340G UART interface (a part of all modern kernels)

 Just try to flash, if a problem occurs,  try to `flash+reset` button

#### Tutorial of how-to with Arduino + NodeMCU

* Simple web service served via Wifi (see `sketch_may21c`)
  * https://protosupplies.com/product/esp8266-nodemcu-v1-0-esp-12e-wifi-module/

* Example of Firebase connection to NodeMCU
  * https://circuitdigest.com/microcontroller-projects/iot-firebase-controlled-led-using-esp8266-nodemcu

Other examples:
* https://www.instructables.com/id/Quick-Start-to-Nodemcu-ESP8266-on-Arduino-IDE/
* https://randomnerdtutorials.com/how-to-install-esp8266-board-arduino-ide/
* https://www.programmingelectronics.com/using-the-print-function-with-arduino-part-1/



### Development using esptoolpy and lua scripts

As a getting started, see a tutorial from  https://blog.alexellis.io/iot-nodemcu-sensor-bme280/


See usefull esptoolpy use-cases for ESP8266  https://github.com/espressif/esptool#entering-the-bootloader


* Use cloud firmware builder, https://nodemcu-build.com/stats.php
* install `esptoolpy` tool: https://nodemcu.readthedocs.io/en/master/getting-started/#esptoolpy
* try to flash

```
# read bootloader info
sudo /home/imarfin/.local/bin/esptool.py -p /dev/ttyUSB0 -b 9600 read_mac
# upload a firmware
sudo /home/imarfin/.local/bin/esptool.py -p /dev/ttyUSB0 --baud 115200  write_flash 0x00000 nodemcu-master-14-modules-2020-05-21-10-21-30-float.bin
# get to lua repl:
sudo screen -L /dev/ttyUSB0 115200
# use ctrl + A + : quit --> to quit from screen (process will be stopped)
# use ctrl + A + D --> to exit screen (process will be pushed to background)
```

##### How to upload lua scripts to ram of the nodemcu: luatool

* https://hackaday.io/project/4377-fiddling-with-the-esp8266/log/14476-uploading-a-lua-file-to-the-esp-nodemcu

```
git clone https://github.com/4refr0nt/luatool
cd luatool/
sudo ./luatool.py --port /dev/ttyUSB0 --src init.lua --baud 115200  --dest init.lua --verbose
sudo ./luatool.py --port /dev/ttyUSB0 --src test5.lua  --baud 115200  --dest test5.lua --verbose
sudo screen -L /dev/ttyUSB0 115200
# then in the screen:
dofile("init.lua")
dofile("test5.lua")
```

##### Updating nodemcu firmware and uploading lua scripts with docker

###### Building a firmware

```
git clone --recurse-submodules https://github.com/nodemcu/nodemcu-firmware.git
cd nodemcu-firmware
docker pull marcelstoer/nodemcu-build
docker run --rm -ti -v `pwd`:/opt/nodemcu-firmware marcelstoer/nodemcu-build build
```


###### flashing an uptodated firmware

```
sudo /home/imarfin/.local/bin/esptool.py -p /dev/ttyUSB0 --baud 115200  write_flash 0x00000 bin/nodemcu_float_master_20200522-0924.bin
```

###### uploading lua scripts

```
# build the nodemcu-tool
cd ..
docker build -t nodemcu-tool .
mkdir nodemcu-tool-test
cd nodemcu-tool-test
# run the nodemcu-tool

# USE USB-TO-TTL UART, not microUSB UART
get_nodemcu_dev_env() {
  [[ "$1" = '-t'  ]] && shift && docker run -i -t -v $(pwd):/code ${DOCKER_CNT_PARAMS}  --rm nodemcu-tool "$@"
  [[ "$1" != '-t'  ]] &&  docker run -i -v $(pwd):/code  ${DOCKER_CNT_PARAMS} --rm nodemcu-tool "$@"
}
DOCKER_CNT_PARAMS=" --privileged -v /dev:/dev"
get_nodemcu_dev_env  node_modules/nodemcu-tool/bin/nodemcu-tool.js --port /dev/ttyUSB0 upload /code/init.lua

export DOCKER_CNT_PARAMS=" --privileged"
get_nodemcu_dev_env  node_modules/nodemcu-tool/bin/nodemcu-tool.js --port /dev/ttyUSB0 upload /code/*.lua


get_nodemcu_dev_env  echo node_modules/nodemcu-tool/bin/nodemcu-tool.js --port /dev/ttyUSB0 run init.lua
get_nodemcu_dev_env  echo node_modules/nodemcu-tool/bin/nodemcu-tool.js --port /dev/ttyUSB0 run mod1.lua

DOCKER_CNT_PARAMS=" --privileged -u $(id -u ${USER}):$(id -g ${USER})" get_nodemcu_dev_env sh -c ' cd /code && /app/node_modules/nodemcu-tool/bin/nodemcu-tool.js init'

# add this to .nodemcutool
#
#    "connectionDelay": 100,
#    "compile": true,
#    "minify": true,
#    "keeppath": true
#


# it will start two webservices: at the port 80 and 8080
DOCKER_CNT_PARAMS=" --privileged" get_nodemcu_dev_env  sh -c "cd /code && /app/node_modules/nodemcu-tool/bin/nodemcu-tool.js  upload init.lua webserver80.lua  webserver8080.lua"
DOCKER_CNT_PARAMS=" --privileged" get_nodemcu_dev_env  sh -c "cd /code && /app/node_modules/nodemcu-tool/bin/nodemcu-tool.js  fsinfo"

# get into the nodemcu
sudo screen -L /dev/ttyUSB0 115200
# in the nodemcu
node.restart()
# Ctrl + A + :
# quit

# run some examples of wifi scan https://iotbytes.wordpress.com/wifi-configuration-on-nodemcu/
DOCKER_CNT_PARAMS=" --privileged" get_nodemcu_dev_env  sh -c "cd /code && /app/node_modules/nodemcu-tool/bin/nodemcu-tool.js upload scanwifi2.lua scanwifi3.lua"  
# get into the nodemcu
sudo screen -L /dev/ttyUSB0 115200
# in the nodemcu
f=assert(loadfile("scanwifi2.lua"))
f()
f()

f=assert(loadfile("scanwifi3.lua"))
f()
f()
# Ctrl + A + :
# quit

# test soft AP mode:
DOCKER_CNT_PARAMS=" --privileged" get_nodemcu_dev_env  sh -c "cd /code && /app/node_modules/nodemcu-tool/bin/nodemcu-tool.js upload ap.lua"  
sudo screen -L /dev/ttyUSB0 115200
dofile('ap.lua')
# then connect to `NODEMCU-Test` : psk=> igormarfin
# check 192.168.10.1 and  192.168.10.1:8080

# come back  to the station mode:
#dofile('init.lua')
node.restart()
# Ctrl + A + :
# quit

# playing with blinking led:
DOCKER_CNT_PARAMS=" --privileged" get_nodemcu_dev_env  sh -c "cd /code && /app/node_modules/nodemcu-tool/bin/nodemcu-tool.js upload blinking_led.lua"
sudo screen -L /dev/ttyUSB0 115200
_t=dofile('blinking_led.lua')()
_t:stop()
_t:start()
_t:unregister()
# Ctrl + A + :
# quit
```

* Some practical examples of the lua code for NodeMCU

```
wifi.setmode(wifi.STATION)
wifi.sta.config{ssid="EasyBox-05B843", pwd="r590Qf.er1"}


# example of the timers and alarms
mytimer = tmr.create(); mytimer:register(1000, tmr.ALARM_AUTO, function() print("hey there") end); mytimer:interval(6000); mytimer:start();

mytimer = tmr.create()
mytimer:register(1000, tmr.ALARM_AUTO, function (t) print("expired"); t:unregister() end)
mytimer:start()


if not tmr.create():alarm(7000, tmr.ALARM_SINGLE, function()
  print("hey there")
  ---tmr.wdclr()
  ---wifi.sta.getap(ap_list_cfg,ap_list_table_format, print_AP_List)

end)
then
  print("whoopsie")
end

cnt = 10
if not tmr.create():register(1000, tmr.ALARM_AUTO, function(t)
  print("hey there")
  ---wifi.sta.getap(ap_list_cfg,ap_list_table_format, print_AP_List)
  if wifi.sta.getip()==nil then
    cnt = cnt-1
    if cnt<=0 then
      print "Not connected to wifi."
      t:unregister()
    end
  else
    print("\nStarting main")
    --- dofile("main.lua")
    print(string.format("IP: %s",wifi.sta.getip()))
end):start()
then
  print("whoopsie")
end

```
