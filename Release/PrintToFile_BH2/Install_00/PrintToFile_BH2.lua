--[[
## PrintToFile_BH2 v0.2 ##
Schreibt alle print()-Ausgaben neben dem EEP-Ereignis auch in eine Textdatei.
Einbinden mittels
	require("PrintToFile_BH2"){file="D:/output.txt", output=2}
am Anfang des Skripts.
Optionen:
	f oder file:	Dateiname der Ausgabedatei, relativ zum Resourcenordner
					Standardwert: "print.txt"
	o oder output:	Ausgabemodus im EEP-Ereignisfenster. Mögliche Werte:
					0: keine Ausgabe
					1: normale Ausgabe (Standardwert)
					2: Ausgabe wie in Datei (diese kann sich von der normalen Ausgabe leicht unterscheiden)
]]--
local FileToPrint = "print.txt"
local printType = 1
local oldprint = print
function print(...)
	local file=assert(io.open(FileToPrint,"a"))
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
local oldclearlog = clearlog
function clearlog()
	io.open(FileToPrint,"w+"):close()
	oldclearlog()
end

return function(options)
	for k,v in pairs(options) do
		if     k == "f" or k == "file" then FileToPrint = v
		elseif k == "o" or k == "output" then printType = v
		end
	end
end
