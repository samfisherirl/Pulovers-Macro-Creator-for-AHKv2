#Requires Autohotkey v2.0
#SingleInstance Force
#Include lib\convert\ConvertFuncs.ahk
;AutoGUI 2.5.8
;Auto-GUI-v2 credit to autohotkey.com/boards/viewtopic.php?f=64&t=89901
;AHKv2converter credit to github.com/mmikeww/AHK-v2-script-converter
a := A_ScriptDir
logs := a "\important\log.txt"    ; set the path to the log file
empty := a "\important\empty.txt"    ; set the path to an empty file
temps := a "\important\temp.txt"
trash := a "\important\trash.txt"    ; set the path to a temporary file
retstat := a "\important\return.txt"    ; set the path to the return status file
files := [logs, empty, temps, trash, retstat]
exe := "`"" a "\lib\AutoHotKey Exe\AutoHotkeyV1.exe`" "     ; specify the path to the AutoHotkey V1 executable
autogui := "`"" a "\important\MacroCreator.ahk`""   ; specify the path to the AutoGUI script
com := exe autogui     ; concatenate the two paths

checkFirstTime(files)
Run(com, , , &PID)     ; run the concatenated command, which launches AutoGUI
Sleep(1000)    ; wait for 1 second
findProcess(PID)

While ProcessExist(PID)    ; while the Pulover's process exists
    ; wait for %logs% to exist, that means Pulover's is trying to generate code.
    ; this loop will convert to v2 and notify Pulover's via %retstat%
{
    if FileExist(logs)    ; check if the log file exists
    {
        inscript := tryRead(logs)       ; read the contents of the file into a variable
        if (inscript != "")    ; if the variable is not empty
        {
            FileMove(logs, temps, 1)    ; move the log file to the temporary file
            try
            {
                script := Convert(inscript)    ; convert the script from AHK v1 to AHK v2  ; add menu handlers to the script
                FileCopy(empty, temps, 1)
                FileAppend(script, temps)
                FileCopy(temps, retstat, 1)
                FileMove(temps, trash, 1)
            }
            catch {
                sleep(10)
            } } }
    else {
        Sleep(15)
        continue
    }
}
ExitApp


checkFirstTime(files) {
    for fil in files {
        if FileExist(fil) {
            x := 1
            break
        }
        else {
            x := 0
        }
    }
    if (x == 0) {
        MsgBox("This is your first time. If Pulover's Macro Creator needs to download language packs, `nexpect to need to restart from the `"Launch_Pulover's_Macro_Recorder.ahk`" after update.")
    }
}

findProcess(PID) {
    Loop 50 {     ; loop up to 10 times
        if ProcessExist(PID) {     ; check if the AutoGUI process exists
            break     ; if it does, break out of the loop
        }
        else {
            Sleep(500)     ; if it doesn't, wait for 1 second and check again
        }
    }
}
;try {out := FileRead(path)}
tryRead(path) {
    try {
        out := FileRead(path)
        return out
    }
    catch {
        Sleep(10)
        return ""
    }
}