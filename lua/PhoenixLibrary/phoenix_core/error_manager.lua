--Set all functions in this file to _PHX prefixing to make them into phoenixlibrary only functions, after system is tested and works (on the road, I am unsure)

--THESE NEED TO BE REVOLUTIONIZED/FIXED UP AND SHORTENED, SERIOUSLY!

--[[
	TODO: OFFLOAD <GETFUNCNAMEATSTACK> to a global func that we can use; Put in !core.lua or something
	LibError(bHalt, numStack, errString)
	function LibError(bHalt, numAddStack, strError)
		
	end
]]

function LibraryError(errObject, numAddStack)
	if type(errObject) ~= "string" then tostring(errObject) end --I think error objects (returned from pcalls) do actually act as strings, I am unsure as of now though
	local numStack, strLibrary, strFunc = 2, "<Unknown>", "<Unknown>"
	if type(numAddStack) == "number" and numAddStack > 0 then numStack = numStack + numAddStack end
	
	local tbl = debug.getinfo(numStack,"n")
	if tbl then
		if type(tbl.name) == "string" then
			strFunc = tbl.name
		end
		local env = getfenv(2)
		if env and type(env.NAME) == "string" then strLibrary = env.NAME end
	end
	ErrorNoHalt("LibraryError["..tostring(strName).."]["..tostring(strFunc).."] : "..tostring(errObject).."\n")
end
LibError = LibraryError

function LibraryErrorHalt(errObject, numAddStack)
	if type(errObject) ~= "string" then tostring(errObject) end --I think error objects (returned from pcalls) do actually act as strings, I am unsure as of now though
	if not strFunc then
		local tbl = debug.getinfo(2,"n")
		if type(tbl) == "table" and type(tbl.name) == "string" then strFunc = tbl.name end
	end
	error("LibraryError["..tostring(strName).."]["..tostring(strFunc).."] : "..tostring(errObject),3 + FORCE(numAddStack,0)) --NOTE: endline is automatic for <error> function
end
LibErrorHalt = LibraryErrorHalt