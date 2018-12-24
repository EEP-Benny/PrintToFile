FileToPrint = FileToPrint or "print.txt"
oldprint = print
function print(...)
	file=assert(io.open(FileToPrint,"a"))
	file:write(table.concat({...}))
	file:write("\n")
	file:close()
	oldprint(...)
end
oldclearlog = clearlog
function clearlog()
	io.open(FileToPrint,"w+"):close()
	oldclearlog()
end