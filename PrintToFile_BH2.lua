--[[
## PrintToFile_BH2 v1.0 ##
Schreibt alle print()-Ausgaben neben dem EEP-Ereignis auch in eine Textdatei.
error()- und assert()-Aufrufe werden ebenfalls in die Textdatei geschrieben.
Einbinden mittels
	require("PrintToFile_BH2"){file="D:/output.txt", output=2}
am Anfang des Skripts.
Optionen:
	f oder file:	Dateiname der Ausgabedatei, relativ zum Resourcenordner
					Standardwert: "print.txt"
	o oder output:	Ausgabemodus im EEP-Ereignisfenster. Moegliche Werte:
					0: keine Ausgabe
					1: normale Ausgabe (Standardwert)
					2: Ausgabe wie in Datei (diese kann sich von der normalen Ausgabe leicht unterscheiden)
]]--
local FileToPrint = "print.txt"
local printType = 1

local oldprint = print
local oldclearlog = clearlog
local olderror = error
local oldassert = assert

function print(...)
	local file=oldassert(io.open(FileToPrint,"a"))
	local args=table.pack(...)
	local output=""
	for i = 1, args.n do
		output=output..tostring(args[i])
	end
	file:write(output.."\n")
	file:close()
	if printType == 1 then
		oldprint(...)
	elseif printType == 2 then
		oldprint(output)
	end
end
function clearlog()
	io.open(FileToPrint,"w+"):close()
	oldclearlog()
end
function error(message, level)
	if level == nil or level < 1 then level = 1 end
	level = level + 1 -- we don't want our custom error function in the traceback
	local traceback = debug.traceback(message, level)
	local file=oldassert(io.open(FileToPrint,"a"))
	file:write("Error: "..traceback)
	file:close()
	olderror(message, level)
end
function assert(v, message, ...)
	if not v then
		if not message then message = "assertion failed!" end
		error(message, 2)
	end
	return oldassert(v, message, ...)
end

return function(options)
	for k,v in pairs(options) do
		if     k == "f" or k == "file" then FileToPrint = v
		elseif k == "o" or k == "output" then printType = v
		end
	end
end
