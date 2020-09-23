VERSION 5.00
Begin VB.UserControl DMSysInfo 
   ClientHeight    =   480
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   480
   InvisibleAtRuntime=   -1  'True
   Picture         =   "DMSysInfo.ctx":0000
   ScaleHeight     =   480
   ScaleWidth      =   480
   ToolboxBitmap   =   "DMSysInfo.ctx":08CA
End
Attribute VB_Name = "DMSysInfo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
' System Stuff
Private Declare Function GetComputerName Lib "kernel32" Alias "GetComputerNameA" (ByVal lpBuffer As String, nSize As Long) As Long
Private Declare Function GetUserName Lib "advapi32.dll" Alias "GetUserNameA" (ByVal lpBuffer As String, nSize As Long) As Long
Private Declare Function GetVersion Lib "kernel32" () As Long
Private Declare Function GetVersionEx Lib "kernel32" Alias "GetVersionExA" (lpVersionInformation As OSVERSIONINFO) As Long
Private Declare Sub GlobalMemoryStatus Lib "kernel32" (lpBuffer As MEMORYSTATUS)
Private Declare Sub GetSystemInfo Lib "kernel32" (lpSystemInfo As SYSTEM_INFO)
Private Declare Function GetSystemPowerStatus Lib "kernel32" (lpSystemPowerStatus As SYSTEM_POWER_STATUS) As Long

'System Folder Locations
Private Declare Function GetWindowsDirectory Lib "kernel32" Alias "GetWindowsDirectoryA" (ByVal lpBuffer As String, ByVal nSize As Long) As Long
Private Declare Function GetSystemDirectory Lib "kernel32" Alias "GetSystemDirectoryA" (ByVal lpBuffer As String, ByVal nSize As Long) As Long
Private Declare Function GetTempPath Lib "kernel32" Alias "GetTempPathA" (ByVal nBufferLength As Long, ByVal lpBuffer As String) As Long
Private Declare Function GetCurrentDirectory Lib "kernel32" Alias "GetCurrentDirectoryA" (ByVal nBufferLength As Long, ByVal lpBuffer As String) As Long
Private Declare Function SHGetSpecialFolderLocation Lib "shell32.dll" (ByVal hwndOwner As Long, ByVal nFolder As Long, pidl As ITEMIDLIST) As Long
Private Declare Function SHGetPathFromIDList Lib "shell32.dll" Alias "SHGetPathFromIDListA" (ByVal pidl As Long, ByVal pszPath As String) As Long

'NET Stuff
Private Declare Function GetAllUsersProfileDirectory Lib "userenv.dll" Alias "GetAllUsersProfileDirectoryA" (ByVal lpProfileDir As String, lpcchSize As Long) As Boolean
Private Declare Function GetDefaultUserProfileDirectory Lib "userenv.dll" Alias "GetDefaultUserProfileDirectoryA" (ByVal lpProfileDir As String, lpcchSize As Long) As Boolean
Private Declare Function GetProfilesDirectory Lib "userenv.dll" Alias "GetProfilesDirectoryA" (ByVal lpProfileDir As String, lpcchSize As Long) As Boolean
Private Declare Function GetUserProfileDirectory Lib "userenv.dll" Alias "GetUserProfileDirectoryA" (ByVal hToken As Long, ByVal lpProfileDir As String, lpcchSize As Long) As Boolean
Private Declare Function GetCurrentProcess Lib "kernel32" () As Long
Private Declare Function OpenProcessToken Lib "advapi32" (ByVal ProcessHandle As Long, ByVal DesiredAccess As Long, TokenHandle As Long) As Long

'Registry stuff
Private Declare Function RegOpenKeyEx Lib "advapi32.dll" Alias "RegOpenKeyExA" (ByVal hKey As Long, ByVal lpSubKey As String, ByVal ulOptions As Long, ByVal samDesired As Long, phkResult As Long) As Long
Private Declare Function RegQueryValueEx Lib "advapi32.dll" Alias "RegQueryValueExA" (ByVal hKey As Long, ByVal lpValueName As String, ByVal lpReserved As Long, lpType As Long, lpData As Any, lpcbData As Long) As Long
Private Declare Function RegCloseKey Lib "advapi32.dll" (ByVal hKey As Long) As Long

Private Const Ttoken = (&H8)
Private Const MAX_PATH = 260

' Registry consts
Private Const ERROR_SUCCESS = 0&
Private Const HKEY_LOCAL_MACHINE = &H80000002
Private Const STANDARD_RIGHTS_ALL = &H1F0000
Private Const KEY_QUERY_Value = &H1
Private Const KEY_SET_Value = &H2
Private Const KEY_CREATE_SUB_KEY = &H4
Private Const KEY_ENUMERATE_SUB_KEYS = &H8
Private Const KEY_NOTIFY = &H10
Private Const KEY_CREATE_LINK = &H20
Private Const SYNCHRONIZE = &H100000

Private Const KEY_ALL_ACCESS = _
    ((STANDARD_RIGHTS_ALL Or _
    KEY_QUERY_Value Or _
    KEY_SET_Value Or _
    KEY_CREATE_SUB_KEY Or _
    KEY_ENUMERATE_SUB_KEYS Or _
    KEY_NOTIFY Or KEY_CREATE_LINK) And _
    (Not SYNCHRONIZE))
    
Private Type SHITEMID
    cb As Long
    abID As Byte
End Type

Private Type ITEMIDLIST
    mkid As SHITEMID
End Type

Private Type OSVERSIONINFO
    dwOSVersionInfoSize As Long
    dwMajorVersion As Long
    dwMinorVersion As Long
    dwBuildNumber As Long
    dwPlatformId As Long
    szCSDVersion As String * 128
End Type

Private Type MEMORYSTATUS
    dwLength As Long
    dwMemoryLoad As Long
    dwTotalPhys As Long
    dwAvailPhys As Long
    dwTotalPageFile As Long
    dwAvailPageFile As Long
    dwTotalVirtual As Long
    dwAvailVirtual As Long
End Type

Type SYSTEM_INFO
    dwOemID As Long
    dwPageSize As Long
    lpMinimumApplicationAddress As Long
    lpMaximumApplicationAddress As Long
    dwActiveProcessorMask As Long
    dwNumberOrfProcessors As Long
    dwProcessorType As Long
    dwAllocationGranularity As Long
    dwReserved As Long
End Type

Private Type SYSTEM_POWER_STATUS
    ACLineStatus As Byte
    BatteryFlag As Byte
    BatteryLifePercent As Byte
    Reserved1 As Byte
    BatteryLifeTime As Long
    BatteryFullLifeTime As Long
End Type

Enum TSpecialFolders
    DM_DESKTOP = &H0
    DM_PROGRAMS = &H2
    DM_Controls = &H3
    DM_PRINTERS = &H4
    DM_PERSONAL = &H5
    DM_FAVORITES = &H6
    DM_STARTUP = &H7
    DM_RECENT = &H8
    DM_SENDTO = &H9
    DM_BITBUCKET = &HA
    DM_STARTMENU = &HB
    DM_DESKTOPDIRECTORY = &H10
    DM_DRIVES = &H11
    DM_NETWORK = &H12
    DM_NETHOOD = &H13
    DM_FONTS = &H14
    DM_TEMPLATES = &H15
End Enum

Dim Sys_Info As SYSTEM_INFO
Dim AC_Power As SYSTEM_POWER_STATUS
Sub About()
    frmAbout.Show vbModal
    
End Sub
Private Function ReadKey(StrKeyName As String) As String
Dim hKey As Long, RetVal As Long
Dim StrBuff As String

    If RegOpenKeyEx(HKEY_LOCAL_MACHINE, "HARDWARE\DESCRIPTION\System", 0&, KEY_ALL_ACCESS, hKey) <> ERROR_SUCCESS Then
        ReadKey = "ERROR"
        Exit Function
    End If
    
    StrBuff = String(256, Chr(0))
    
    If RegQueryValueEx(hKey, StrKeyName, 0&, RetVal, ByVal StrBuff, 256) <> ERROR_SUCCESS Then
       ReadKey = "ERROR"
       Exit Function
    Else
    
        StrBuff = Left(StrBuff, InStr(1, StrBuff, Chr(0)) - 1)
        ReadKey = StrBuff
    End If
    
    If RegCloseKey(hKey) <> ERROR_SUCCESS Then
       GetKey = "ERORR"
    End If
    
End Function

Public Function DMGetComputerName() As String
Dim StrBuff As String
    StrBuff = String(255, Chr(0))
    GetComputerName StrBuff, 255
    DMGetComputerName = Left(StrBuff, InStr(1, StrBuff, Chr(0)))
    
End Function

Public Function DMGetUserName() As String
Dim StrBuff As String
    StrBuff = String(255, Chr(0))
    GetUserName StrBuff, 255
    DMGetUserName = Left(StrBuff, InStr(1, StrBuff, Chr(0)))
    
End Function

Public Function DMGetWindowsPath() As String
Dim StrBuff As String
    StrBuff = String(255, Chr(0))
    GetWindowsDirectory StrBuff, 255
    DMGetWindowsPath = Left(StrBuff, InStr(1, StrBuff, Chr(0)) - 1)
    
End Function

Public Function DMGetSystemPath() As String
Dim StrBuff As String
    StrBuff = String(255, Chr(0))
    GetSystemDirectory StrBuff, 255
    DMGetSystemPath = Left(StrBuff, InStr(StrBuff, Chr(0)) - 1)
    
End Function

Public Function DMGetTempPath() As String
Dim StrBuff As String
    StrBuff = String(255, Chr(0))
    GetTempPath 255, StrBuff
    DMGetTempPath = Left(StrBuff, InStr(1, StrBuff, Chr(0)) - 1)
    
End Function

Public Function DMGetCurrentPath() As String
Dim StrBuff As String
    StrBuff = String(255, Chr(0))
    GetCurrentDirectory 255, StrBuff
    DMGetCurrentPath = Left(StrBuff, InStr(1, StrBuff, Chr(0)) - 1)
    
End Function
Public Function DMGetAllUserProfileFolder() As String
Dim StrBuff As String
    StrBuff = String(255, Chr(0))
    GetAllUsersProfileDirectory StrBuff, 255
    DMGetAllUserProfileFolder = Left(StrBuff, InStr(1, StrBuff, Chr(0)) - 1)
    
End Function

Public Function DMGetDefaultUserProfileDirectory() As String
Dim StrBuff As String
    StrBuff = String(255, Chr(0))
    GetDefaultUserProfileDirectory StrBuff, 255
    DMGetDefaultUserProfileDirectory = Left(StrBuff, InStr(1, StrBuff, Chr(0)) - 1)
    
End Function

Public Function DMGetProfilesDirectory() As String
Dim StrBuff As String
    StrBuff = String(255, Chr(0))
    GetProfilesDirectory StrBuff, 255
    DMGetProfilesDirectory = Left(StrBuff, InStr(1, StrBuff, Chr(0)) - 1)
    
End Function
Public Function DMGetUserProfileDirectory() As String
Dim StrBuff As String
Dim hToken As Long
    StrBuff = String(255, Chr(0))
    OpenProcessToken GetCurrentProcess, Ttoken, hToken
    GetUserProfileDirectory hToken, StrBuff, 255
    DMGetUserProfileDirectory = Left(StrBuff, InStr(1, StrBuff, Chr(0)) - 1)
    
End Function

Public Function DMGetSpecialFolderLocation(TFolder As TSpecialFolders) As String
    Dim StrBuff As String
    Dim RetVal As Long
    Dim IDL As ITEMIDLIST
    RetVal = SHGetSpecialFolderLocation(100, TFolder, IDL)
    If RetVal = NOERROR Then
        StrBuff = String(512, Chr(0))
        RetVal = SHGetPathFromIDList(ByVal IDL.mkid.cb, ByVal StrBuff)
        DMGetSpecialFolderLocation = Left(StrBuff, InStr(StrBuff, Chr(0)) - 1)
        Exit Function
    End If
    DMGetSpecialFolderLocation = ""

End Function

Public Function DMGetVersionNumber() As String
Dim RetVal As Long, WinVer As Long
    RetVal = GetVersion()
    WinVer = RetVal And &HFFFF&
    DMGetVersionNumber = Format((WinVer Mod 256) + ((WinVer \ 256) / 100), "Fixed")
    
End Function

Public Function DMGetWinBuild() As String
Dim DM_Os As OSVERSIONINFO
Dim RetVal As Long
    DM_Os.dwOSVersionInfoSize = Len(DM_Os)
    RetVal = GetVersionEx(DM_Os)
    If RetVal = 0 Then
        DMGetWinBuild = "ERROR"
    Else
        DMGetWinBuild = DM_Os.dwBuildNumber
    End If
    
End Function

Public Function DMGetOSPlatForm() As String
Dim DM_Os As OSVERSIONINFO
Dim RetVal As Long
Dim WinOs As String

    DM_Os.dwOSVersionInfoSize = Len(DM_Os)
    RetVal = GetVersionEx(DM_Os)
    If RetVal = 0 Then
        WinOs = "ERROR"
    Else
        Select Case DM_Os.dwPlatformId
            Case 0
                WinOs = "Windows 32s"
            Case 1
                WinOs = "Windows 95/98"
            Case 2
                WinOs = "Windows NT"
            Case Else
                WinOs = "Unknown Platform"
        End Select
    End If
    DMGetOSPlatForm = WinOs
    
End Function

Public Function DMGetWorkAreaWidth() As Long
Dim RetVal As Long
    RetVal = Screen.Width
    DMGetWorkAreaWidth = RetVal
    
End Function
Public Function DMGetWorkAreaHeight() As Long
Dim RetVal As Long
    RetVal = Screen.Height
    DMGetWorkAreaHeight = RetVal
    
End Function

Public Function DMGetNumberOfProcesors() As String
    GetSystemInfo Sys_Info
    DMGetNumberOfProcesors = Str(Sys_Info.dwNumberOrfProcessors)
End Function

Public Function DMGetProcessorType() As String
    GetSystemInfo Sys_Info
    DMGetProcessorType = Str(Sys_Info.dwProcessorType)
End Function

Public Function DMGetLowMemoryAddress() As String
    GetSystemInfo Sys_Info
    DMGetLowMemoryAddress = Str(Sys_Info.lpMinimumApplicationAddress)
End Function

Public Function DMGetHighMemoryAddress() As String
    GetSystemInfo Sys_Info
    DMGetHighMemoryAddress = Str(Sys_Info.lpMaximumApplicationAddress)
End Function

Public Function DMGetPageSize() As String
    GetSystemInfo Sys_Info
    DMGetPageSize = Str(Sys_Info.dwPageSize)
End Function

Public Function DMGetACStatus() As Long
    GetSystemPowerStatus AC_Power
    DMGetACStatus = AC_Power.ACLineStatus
End Function

Public Function DMGetBatteryFullTime() As Long
    GetSystemPowerStatus AC_Power
    DMGetBatteryFullTime = AC_Power.BatteryFullLifeTime
End Function

Public Function DMGetBatteryLifePercent()
    GetSystemPowerStatus AC_Power
    DMGetBatteryLifePercent = AC_Power.BatteryLifePercent
End Function

Public Function DMGetBatteryLifeTime() As Long
    GetSystemPowerStatus AC_Power
    DMGetBatteryLifeTime = AC_Power.BatteryLifeTime
End Function

Public Function DMGetBatteryStatus() As Long
    GetSystemPowerStatus AC_Power
    DMGetBatteryStatus = AC_Power.BatteryFlag
End Function

Public Function DMGetTotalPhysMemory() As Long
Dim TMem As MEMORYSTATUS
    GlobalMemoryStatus TMem
    DMGetTotalPhysMemory = TMem.dwTotalPhys / 1024
End Function

Public Function DMGetAvailPhysMemory() As Long
Dim TMem As MEMORYSTATUS
    GlobalMemoryStatus TMem
    DMGetAvailPhysMemory = TMem.dwAvailPhys / 1024
End Function

Public Function DMGetMemoryLoad() As Long
Dim TMem As MEMORYSTATUS
    GlobalMemoryStatus TMem
    DMGetMemoryLoad = TMem.dwMemoryLoad
End Function

Public Function DMGetTotalSwapMemory() As Long
Dim TMem As MEMORYSTATUS
    GlobalMemoryStatus TMem
    DMGetTotalSwapMemory = TMem.dwTotalPageFile / 1024
End Function

Public Function GetAvailSwapMemory() As Long
Dim TMem As MEMORYSTATUS
    GlobalMemoryStatus TMem
    GetAvailSwapMemory = TMem.dwAvailPageFile / 1024
End Function
Public Function DMGetTotalVirtualMemory()
Dim TMem As MEMORYSTATUS
    GlobalMemoryStatus TMem
    DMGetTotalVirtualMemory = TMem.dwTotalVirtual / 1024
    
End Function
Public Function DMGetBoisIdentifier() As String
    DMGetBoisIdentifier = ReadKey("Identifier")
    
End Function

Public Function DMGetSystemBiosDate() As String
    DMGetSystemBiosDate = ReadKey("SystemBiosDate")
    
End Function

Public Function DMGetSystemBiosVersion() As String
    DMGetSystemBiosVersion = ReadKey("SystemBiosVersion")
    
End Function

Public Function DMGetVideoBiosDate() As String
    DMGetVideoBiosDate = ReadKey("VideoBiosDate")
    
End Function

Public Function DMGetVideoBiosVersion() As String
    DMGetVideoBiosVersion = ReadKey("VideoBiosVersion")
    
End Function

Private Sub UserControl_Resize()
    UserControl.Size 480, 480
    
End Sub
