local msg = "hello"

local LibDemo = require("lib")
if LibDemo then
	LibDemo.LOG(msg)
else
	print(msg)
end
