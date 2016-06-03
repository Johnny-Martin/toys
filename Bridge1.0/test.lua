--
-- Luna Account example
--
local a = Fuck("a", "b", "c", "b", "c")
if type(a) == "table" then
	local ret = a.Shit("2")
	print(tostring(ret))
	
end

Fuck = nil
collectgarbage("collect")
