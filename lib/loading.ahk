
#Requires Autohotkey v2
;AutoGUI creator: Alguimist autohotkey.com/boards/viewtopic.php?f=64&t=89901
;AHKv2converter creator: github.com/mmikeww/AHK-v2-script-converter
;EasyAutoGUI-AHKv2 github.com/samfisherirl/Easy-Auto-GUI-for-AHK-v2

if A_LineFile = A_ScriptFullPath && !A_IsCompiled
{
    pic := "C:\Users\dower\Downloads\Title 06_1.gif"
    myGui := loadingSplash(pic)
    myGui.Show('w1280')
    DarkMode(myGui)
}

loadingSplash(pic)
{   
    progVal := 0
    MyGui := Gui('-DPIScale +AlwaysOnTop')
    MyGui.BackColor := 0x000000
    MyGui.MarginX := 0
    MyGui.MarginY := 0
    ax := MyGui.Add("ActiveX", "x-10 y-20 w1280 h500 ", "mshtml:<img src='" pic "' />")
    progress := myGui.Add("Progress", "x20 y+20 w1280 h60 -Smooth", 10)
    myGui.Title := "Loading"
    myGui.Show('w1280')
    DarkMode(myGui)
    SetTimer(Close, 800)
    Close()
    {
        progress.value += 18
        if progress.value >= 100
        {

            myGui.Hide
            SetTimer(, 0)
            mygui.destroy()
        }
    }
    return myGui
}


purpleBG(Ctrlparams*)
{
    for ctrl in Ctrlparams
    {
        ctrl.Opt("Background5d39c9")
    }
}
blackGuiCtrl(params*)
{
    if params[1].gui.backcolor 
    {
        bg := params[1].gui.backcolor
    } else {
        bg := "12121a"
    }
    for ctrl in params
    {
        try
        {
            ctrl.Opt("Background" bg)
        } catch as e {
            continue
        }
        try
        {
            ctrl.SetFont("cWhite")
        } catch as e {
            continue
        }
    }
}

mcColorFunc()
{
    return mcColors := {
        MCSC_BACKGROUND: 0,
        MCSC_TEXT: 1,
        MCSC_TITLEBK: 2,
        MCSC_TITLETEXT: 3,
        MCSC_MONTHBK: 4,
        MCSC_TRAILINGTEXT: 5
    }
}
GetFont(options, fontName)
{
    myGUI := Gui()
    myGUI.SetFont(options, fontName)
    hFont := SendMessage(WM_GETFONT := 0x31, , , myGUI.AddText())
    myGUI.Destroy()
    return hFont
}
 
class darkMode
{
    static color :=  "191919"
    
    static Call(myGUI, color?)
    {
        myGUI.BackColor := IsSet(color) ? color : darkMode.color
        if (VerCompare(A_OSVersion, "10.0.17763") >= 0)
        {
            DWMWA_USE_IMMERSIVE_DARK_MODE := 19
            if (VerCompare(A_OSVersion, "10.0.18985") >= 0)
            {
                DWMWA_USE_IMMERSIVE_DARK_MODE := 20
            }
            DllCall("dwmapi\DwmSetWindowAttribute", "Ptr", myGUI.hWnd, "Int", DWMWA_USE_IMMERSIVE_DARK_MODE, "Int*", true, "Int", 4)
            ; listView => SetExplorerTheme(LV1.hWnd, "DarkMode_Explorer"), SetExplorerTheme(LV2.hWnd, "DarkMode_Explorer")
            uxtheme := DllCall("GetModuleHandle", "Str", "uxtheme", "Ptr")
            DllCall(DllCall("GetProcAddress", "Ptr", uxtheme, "Ptr", 135, "Ptr"), "Int", 2) ; ForceDark
            DllCall(DllCall("GetProcAddress", "Ptr", uxtheme, "Ptr", 136, "Ptr"))
        }
        for ctrlHWND, ctrl in myGUI
        {
            if ctrl.HasProp("NoBack")
                continue
            blackGuiCtrl(myGUI[ctrlHWND])
        }
    }
}
