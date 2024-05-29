#Requires Autohotkey v2.0
#SingleInstance Force
#Include lib\convert\ConvertFuncs.ahk 
#Include lib\vars.ahk
#Include lib\loading.ahk

; If you are reading, and find use in this script
; please donate to the original creator https://www.macrocreator.com/donate/

loadingSplash(A_ScriptDir "\lib\loading.gif")
checkFirstTime(files)
Run(com, ,, &PID)  
ProcessSetPriority "AboveNormal", PID
Sleep(1000)         
findProcess(PID)

While ProcessExist(PID)     
; while the Pulover's process exists
; wait for %logs% to exist, that means Pulover's is trying to generate code.
; this loop will convert to v2 and notify Pulover's via %retstat%
{
    if FileExist(logs)      ; check if the log file exists
    {
        inscript := tryRead(logs)               ; read the contents of the file into a variable
        if (inscript != "")                     ; if the variable is not empty
        {
            FileMove(logs, temps, 1)            ; move the log file to the temporary file
            try
            {
                script := Convert(inscript)     ; convert the script from AHK v1 to AHK v2  ; add menu handlers to the script
                ,FileCopy(empty, temps, 1)
                ,FileAppend(script, temps)
                ,FileCopy(temps, retstat, 1)
                ,FileMove(temps, trash, 1)
            }
            catch as e {
                errorLog(e.message)
                sleep(10)
            } } }
    else {
        Sleep(15)
        continue
    }
}
ExitApp

errorLog(str)
{
    FileOpen("lib\error.txt", "w").Write(str "`n`n")
}

checkFirstTime(files) 
{
    ft  := A_ScriptDir "\lib\firstTime.txt"
    if !FileExist(ft) 
    {
        MsgBox("This is your first time. If Pulover's Macro Creator needs to download language packs, `nexpect the need to restart from the `"Launch_Pulover's_Macro_Recorder.ahk`" after update.`n`nThis also MAY CAUSE FREEZES even for advanced systems. Please be patient it'll take less than a minute. ")
        FileAppend("test", ft)
    } 
}       

findProcess(PID) 
{
    Loop 250 {     ; loop up to 10 times
        if ProcessExist(PID) {     ; check if the AutoGUI process exists
            break     ; if it does, break out of the loop
        }
        else {
            Sleep(50)     ; if it doesn't, wait for 1 second and check again
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