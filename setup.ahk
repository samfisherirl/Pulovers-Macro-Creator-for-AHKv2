#Requires Autohotkey v2.0
a := A_ScriptDir
logs := a "\important\log.txt"    ; set the path to the log file
empty := a "\important\empty.txt"    ; set the path to an empty file
temps := a "\important\temp.txt"
trash := a "\important\trash.txt"    ; set the path to a temporary file
retstat := a "\important\return.txt"    ; set the path to the return status file

files := [logs, empty, temps, trash, retstat]
for fil in files {
	if FileExist(fil) {
		FileDelete(fil)
	}
}