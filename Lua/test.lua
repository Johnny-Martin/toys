local msg = "hello"

local LibDemo = require("lib")
if LibDemo then
	LibDemo.LOG(msg)
else
	print(msg)
end

local luacom = require("luacom")
if luacom then
	local comObj = luacom.CreateObject("SmpMath.1")
	if comObj then
		print("Add: 8 + 9: "..tostring(comObj:Add(8 + 9)))
	end
else
	print("can not open luacom")
end
