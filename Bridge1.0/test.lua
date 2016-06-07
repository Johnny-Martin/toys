--
-- Luna Account example
--
local a = Fuck("a", "b", "c", "b", "c")
if type(a) == "table" then
	print("a == table")
	local ret = a:Shit("2")
	print(tostring(#a))
else
	print(type(a))
end

Fuck = nil
print("Fuck = nil")
collectgarbage("collect")
