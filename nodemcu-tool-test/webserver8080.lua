--- function f()
print ("Starting at 8080 ....")
srv = net.createServer(net.TCP)

srv:listen(8080, function(conn)
	conn:on("receive", function(sck, payload)
		print(payload)
		sck:send("HTTP/1.0 200 OK\r\nContent-Type: text/html\r\n\r\n<h1> Hello, NodeMCU at the port 8080</h1>")
	end)
	conn:on("sent", function(sck) sck:close() end)
end)
--- end
