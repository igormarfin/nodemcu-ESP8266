
-- print AP list in old format (format not defined)
function f()

function listap(t)
    for k,v in pairs(t) do
        print(k.." : "..v)
    end
end

wifi.sta.getap(listap)
end


--- how to run: f=assert(loadfile("scanwifi2.lua"))
--- f()
