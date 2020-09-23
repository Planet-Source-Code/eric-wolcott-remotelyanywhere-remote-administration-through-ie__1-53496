VERSION 5.00
Begin VB.UserControl ctrSysInfo 
   ClientHeight    =   480
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   480
   Picture         =   "ctrSysInfo.ctx":0000
   ScaleHeight     =   480
   ScaleWidth      =   480
   Windowless      =   -1  'True
End
Attribute VB_Name = "ctrSysInfo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Public Function ScreenX()
    ScreenX = Int(Screen.Width / Screen.TwipsPerPixelX)
End Function

Public Function ScreenY()
    ScreenY = Int(Screen.Height / Screen.TwipsPerPixelY)
End Function

Public Function CPUType()
    CPUType = GetString(HKEY_LOCAL_MACHINE, "Hardware\Description\System\CentralProcessor\0", "Identifier")
End Function

Public Function CPUMake()
    CPUMake = GetString(HKEY_LOCAL_MACHINE, "Hardware\Description\System\CentralProcessor\0", "VendorIdentifier")
End Function

Public Function VideoDesc()
    VideoDesc = GetString(HKEY_LOCAL_MACHINE, "System\CurrentControlSet\Services\Class\Display\0000", "DriverDesc")
End Function

Public Function VideoMake()
    VideoMake = GetString(HKEY_LOCAL_MACHINE, "System\CurrentControlSet\Services\Class\Display\0000", "ProviderName")
End Function

Public Function VideoDate()
    VideoDate = GetString(HKEY_LOCAL_MACHINE, "System\CurrentControlSet\Services\Class\Display\0000", "DriverDate")
End Function

Public Function KeyboardDesc()
    KeyboardDesc = GetString(HKEY_LOCAL_MACHINE, "System\CurrentControlSet\Services\Class\Keyboard\0000", "DriverDesc")
End Function
Public Function KeyboardDate()
    KeyboardDate = GetString(HKEY_LOCAL_MACHINE, "System\CurrentControlSet\Services\Class\Keyboard\0000", "DriverDate")
End Function

Public Function SoundDesc()
    SoundDesc = GetString(HKEY_LOCAL_MACHINE, "System\CurrentControlSet\Services\Class\MEDIA\0000", "DriverDesc")
End Function

Public Function SoundDate()
    SoundDate = GetString(HKEY_LOCAL_MACHINE, "System\CurrentControlSet\Services\Class\MEDIA\0000", "DriverDate")
End Function

Public Function MonitorDesc()
    MonitorDesc = GetString(HKEY_LOCAL_MACHINE, "System\CurrentControlSet\Services\Class\Monitor\0000", "DriverDesc")
End Function

Public Function MonitorDate()
    MonitorDate = GetString(HKEY_LOCAL_MACHINE, "System\CurrentControlSet\Services\Class\Monitor\0000", "DriverDate")
End Function

Public Function UserName()
    ' Get the name of the user currently logged on this machine
    UserName = GetString(HKEY_LOCAL_MACHINE, "Network\Logon", "username")
End Function

Public Function WinDir()
    ' Stores the Windows directory location
    WinDir = GetString(HKEY_LOCAL_MACHINE, "Software\Microsoft\Windows\CurrentVersion\Setup", "WinDir")
End Function

Public Function SysDir()
    ' Stores the Windows\System directory location
    SysDir = GetString(HKEY_LOCAL_MACHINE, "Software\Microsoft\Windows\CurrentVersion\Setup", "SysDir")
End Function

Public Function StartPage()
    ' Stores Internet Explorer's default start page in StartPage
    StartPage = GetString(HKEY_CURRENT_USER, "Software\Microsoft\Internet Explorer\Main", "Start Page")
End Function

Public Function ScannerEXE()
    ' Allocates the location of the Scan32.exe for McAfee AV to ScannerEXE
    ScannerEXE = GetString(HKEY_LOCAL_MACHINE, "Software\Microsoft\Windows\CurrentVersion\App Paths\SCAN32.EXE", "")
End Function

Public Function ScannerPath()
    ' Allocates the path to McAfee Virus scanner to ScannerPath (if installed)
    ScannerPath = GetString(HKEY_LOCAL_MACHINE, "Software\Microsoft\Windows\CurrentVersion\App Paths\SCAN32.EXE", "Path")
End Function

Public Function Owner()
    '
    Owner = GetString(HKEY_LOCAL_MACHINE, "Software\Microsoft\Windows\CurrentVersion", "RegisteredOwner")
End Function

Public Function Organisation()
    '
    Organisation = GetString(HKEY_LOCAL_MACHINE, "Software\Microsoft\Windows\CurrentVersion", "RegisteredOrganization")
End Function

Public Function WinProductId()
    '
    WinProductId = GetString(HKEY_LOCAL_MACHINE, "Software\Microsoft\Windows\CurrentVersion", "ProductId")
End Function

Public Function WinProductKey()
    '
    WinProductKey = GetString(HKEY_LOCAL_MACHINE, "Software\Microsoft\Windows\CurrentVersion", "ProductKey")
End Function

Public Function WinProductName()
    '
    WinProductName = GetString(HKEY_LOCAL_MACHINE, "Software\Microsoft\Windows\CurrentVersion", "ProductName")
End Function

Public Function ProgFilesDir()
    '
    ProgramFilesDirectory = GetString(HKEY_LOCAL_MACHINE, "Software\Microsoft\Windows\CurrentVersion", "ProgramFilesDir")
End Function

Public Function WinSubVer()
    '
    WinSubVer = GetString(HKEY_LOCAL_MACHINE, "Software\Microsoft\Windows\CurrentVersion", "SubVersionNumber")
End Function

Public Function WinType()
    '
    WinType = GetString(HKEY_LOCAL_MACHINE, "Software\Microsoft\Windows\CurrentVersion", "Version")
End Function

Public Function WinVerNum()
    '
    WinVerNum = GetString(HKEY_LOCAL_MACHINE, "Software\Microsoft\Windows\CurrentVersion", "VersionNumber")
End Function

