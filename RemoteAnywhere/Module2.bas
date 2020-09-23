Attribute VB_Name = "Module2"
Declare Function RegOpenKeyEx Lib "advapi32" Alias "RegOpenKeyExA" _
    (ByVal hKey As Long, ByVal lpSubKey As String, ByVal ulOptions As Long, _
    ByVal samDesired As Long, phkResult As Long) As Long

Declare Function RegCloseKey Lib "advapi32" (ByVal hKey As Long) As Long

Declare Function RegEnumKeyEx Lib "advapi32.dll" Alias "RegEnumKeyExA" _
    (ByVal hKey As Long, ByVal dwIndex As Long, ByVal lpName As String, _
    lpcbName As Long, ByVal lpReserved As Long, ByVal lpClass As String, _
    lpcbClass As Long, lpftLastWriteTime As Any) As Long

Declare Function RegConnectRegistry Lib "advapi32.dll" Alias "RegConnectRegistryA" _
    (ByVal lpMachineName As String, ByVal hKey As Long, phkResult As Long) As Long
    
Public Declare Function RegQueryValueEx Lib "advapi32.dll" Alias "RegQueryValueExA" _
    (ByVal hKey As Long, ByVal lpValueName As String, ByVal lpReserved As Long, _
    lpType As Long, lpData As Any, lpcbData As Long) As Long

Private Declare Function GetComputerName Lib "kernel32" Alias "GetComputerNameA" _
    (ByVal lpBuffer As String, nSize As Long) As Long

Private Declare Function NetUserEnum Lib "Netapi32" (servername As Byte, _
    ByVal level As Long, ByVal filter As Long, buff As Long, ByVal buffsize As Long, _
    entriesread As Long, totalentries As Long, resumehandle As Long) As Long

Private Declare Function NetApiBufferFree Lib "Netapi32" (ByVal Buffer As Long) As Long

Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (xDest As Any, _
    xSource As Any, ByVal nBytes As Long)

Private Declare Function lstrlenW Lib "kernel32" (ByVal lpString As Long) As Long



Private Const MAX_COMPUTERNAME_LENGTH As Long = 31
Private Const FILTER_WORKSTATION_TRUST_ACCOUNT = &H10

Public Const HKEY_PERFORMANCE_DATA = &H80000004
Public Const HKEY_DYN_DATA = &H80000006
Public Const HKEY_CURRENT_CONFIG = &H80000005
Public Const HKEY_CLASSES_ROOT = &H80000000
Public Const HKEY_CURRENT_USER = &H80000001
Public Const HKEY_LOCAL_MACHINE = &H80000002
Public Const HKEY_USERS = &H80000003

Public Const KEY_ALL_ACCESS = &H3F
Public Const REG_OPTION_NON_VOLATILE = 0&
Public Const REG_CREATED_NEW_KEY = &H1
Public Const REG_OPENED_EXISTING_KEY = &H2
Public Const ERROR_SUCCESS = 0&
Public Const REG_SZ = (1)


Public Const SYNCHRONIZE = &H100000
Public Const STANDARD_RIGHTS_ALL = &H1F0000
Public Const KEY_QUERY_VALUE = &H1
Public Const KEY_SET_VALUE = &H2
Public Const KEY_CREATE_LINK = &H20
Public Const KEY_CREATE_SUB_KEY = &H4
Public Const KEY_ENUMERATE_SUB_KEYS = &H8
Public Const KEY_EVENT = &H1
Public Const KEY_NOTIFY = &H10
Public Const READ_CONTROL = &H20000
Public Const STANDARD_RIGHTS_READ = (READ_CONTROL)
Public Const STANDARD_RIGHTS_WRITE = (READ_CONTROL)

Public Const KEY_READ = ((STANDARD_RIGHTS_READ Or KEY_QUERY_VALUE Or KEY_ENUMERATE_SUB_KEYS Or KEY_NOTIFY) And (Not SYNCHRONIZE))
Public Const KEY_EXECUTE = (KEY_READ)
Public Const KEY_WRITE = ((STANDARD_RIGHTS_WRITE Or KEY_SET_VALUE Or KEY_CREATE_SUB_KEY) And (Not SYNCHRONIZE))
Public Const REG_BINARY = 3

Public Const REG_DWORD = 4
Public Const REG_DWORD_BIG_ENDIAN = 5
Public Const REG_DWORD_LITTLE_ENDIAN = 4
Public Const REG_EXPAND_SZ = 2
Public Const REG_FULL_RESOURCE_DESCRIPTOR = 9
Public Const REG_LINK = 6
Public Const REG_MULTI_SZ = 7
Public Const REG_NONE = 0

Public Const REG_NOTIFY_CHANGE_ATTRIBUTES = &H2
Public Const REG_NOTIFY_CHANGE_LAST_SET = &H4
Public Const REG_NOTIFY_CHANGE_NAME = &H1
Public Const REG_NOTIFY_CHANGE_SECURITY = &H8
Public Const REG_OPTION_BACKUP_RESTORE = 4
Public Const REG_OPTION_CREATE_LINK = 2

Public Const REG_OPTION_RESERVED = 0
Public Const REG_OPTION_VOLATILE = 1
Public Const REG_LEGAL_CHANGE_FILTER = (REG_NOTIFY_CHANGE_NAME Or REG_NOTIFY_CHANGE_ATTRIBUTES Or REG_NOTIFY_CHANGE_LAST_SET Or REG_NOTIFY_CHANGE_SECURITY)
Public Const REG_LEGAL_OPTION = (REG_OPTION_RESERVED Or REG_OPTION_NON_VOLATILE Or REG_OPTION_VOLATILE Or REG_OPTION_CREATE_LINK Or REG_OPTION_BACKUP_RESTORE)

Type SECURITY_ATTRIBUTES
    nLength As Long
    lpSecurityDescriptor As Long
    bInheritHandle As Long
End Type

Type DevTypes
    Class As String
    Name As String
End Type

Type DevProps
    PropDesc As String
    PropVal As String
End Type

Type CPU
    ProcessorNameString As String
    VendorIdentifier As String
    Identifier As String
    MHz As String
End Type


Type ComputerInfo
    ProductName As String
    CurrentVersion As String
    CurrentBuildNumber As String
    CSDVersion As String
    ProductID As String
    RegisteredOwner As String
    RegisteredOrganization As String
    SystemIdentifier As String
    SystemBiosDate As String
    SystemBiosVersion As String
    VideoBiosDate As String
    VideoBiosVersion As String
End Type
    
    
Type DeviceInfo 'hold device information
    DevProps() As DevProps
End Type

Type DriverInfo 'hold driver information
    DevProps() As DevProps
End Type

Type ExtraInfo 'hold extra information
    DevProps() As DevProps
End Type

Private DeviceKey As String 'registry key that holds device information

Private DriverKey As String 'registry key that holds driver information

Private DriverPath As String 'current device driver path

Public DevTypes() As DevTypes 'device type information

Public ExtraInfo() As ExtraInfo, DeviceInfo() As DeviceInfo, DriverInfo() As DriverInfo

Public CI As ComputerInfo, CPU As CPU

Public ComputerName As String

Private NumExtDevProps As Long, NumDevProps As Long, NumDrvProps As Long

Private Count(100) As Long 'counter for keeping track of location in registry

Private NumDevices As Long  'the number of matching devices found

Private NumExtraInfo As Long 'extra info data count

Private WinVersion As String 'version of windows in fixed format

Private NumDevTypes As Long 'number of device types found

Private lhRemoteRegistry As Long

Function ReadRemoteReg(ByVal KeyRoot As Long, _
    ByVal sRegPath As String, ByVal sValueName) As String
    Dim hKey As Long
    Dim KeyValType As Long
    Dim KeyValSize As Long
    Dim KeyVal As String
    Dim tmpVal As String
    Dim res As Long
    Dim i As Integer
    Dim iChar As Integer
    Dim sChar, sWorkStr As String
    Dim bUseZero As Boolean
    Dim lReturnCode, lHive
    
  
    'open the specified key
    res = RegOpenKeyEx(lhRemoteRegistry, sRegPath, 0, KEY_READ, hKey)
    
    'check for errors
    If res <> 0 Then GoTo Errore
    
    'fill buffer
    tmpVal = String(1024, 0)
    
    KeyValSize = 1024
    
    'get the value of the specified key
    res = RegQueryValueEx(hKey, sValueName, 0, KeyValType, ByVal tmpVal, KeyValSize)
    
    'check for errors
    If res <> 0 Then GoTo Errore
    
    'properly format data received
    Select Case KeyValType
    Case REG_SZ
        'remove trailing chr(0)
        tmpVal = Left(tmpVal, InStr(1, tmpVal, Chr(0), vbTextCompare) - 1)
        KeyVal = tmpVal
    Case REG_DWORD
        bUseZero = False
        ' format of keys in tmpVal :
        ' e.g. in registry : (hex) : 40001  ==> reads : 4 0 1 (meaning : 04 00 01)
        ' e.g. in registry : (hex) : 4000f  ==> reads : 4 0 15 (meaning : 04 00 f)
        ' e.g. in registry : (hex) : 121326 ==> reads : 18 19 38 (meaning : 12 13 26)
        sWorkStr = ""
        For i = Len(tmpVal) To 1 Step -1
            'check each code, get asci an convert to hex. You should have 2 digits
            iChar = Asc(Mid(tmpVal, i, 1))
            If iChar <> 0 Then
                bUseZero = True
            End If
            If bUseZero = True Then
                'make sure you have 2 digits (add extra 0 if necessary)
                If Len(Hex(iChar)) = 2 Then
                    ' no need to add an extra 0
                    sWorkStr = sWorkStr & Hex(iChar)
                Else
                    sWorkStr = sWorkStr & "0" & Hex(iChar)
                End If
            End If
        Next
        ' remove the leading 0: and add &h so you know it is hex
        If Left(sWorkStr, 1) = "0" Then
            sWorkStr = Right(sWorkStr, Len(sWorkStr) - 1)
        End If
        'if you want to know the value is stored as hex, use:
        'KeyVal = "&h" & sWorkStr
        'otherwise
        KeyVal = sWorkStr
    
    Case REG_MULTI_SZ
        tmpVal = Left(tmpVal, InStr(1, tmpVal, Chr(0), vbTextCompare) - 1)
        KeyVal = tmpVal
    End Select
    
    ReadRemoteReg = KeyVal
    
    'close the current key
    RegCloseKey hKey
    Exit Function
Errore:
    ReadRemoteReg = ""
    RegCloseKey hKey
    
End Function
Public Function GetDevTypesx() As Long
Dim RegIndex As Long, CurKeyVal As String
Dim DevClass As String, DevName As String
NumDevTypes = -1

Dim hKey As Long
Dim KeyValType As Long
Dim KeyValSize As Long
Dim KeyVal As String
Dim tmpVal As String
Dim res As Long
Dim i As Integer
Dim iChar As Integer
Dim sChar, sWorkStr As String
Dim bUseZero As Boolean
Dim lReturnCode, lHive
    
'open the specified key
res = RegOpenKeyEx(lhRemoteRegistry, DriverKey, 0, KEY_ALL_ACCESS, hKey)


CurKeyVal = String(255, 0)
'if the key is there to open, get the key value
While RegEnumKeyEx(hKey, RegIndex, CurKeyVal, 255, 0, vbNullString, ByVal 0&, ByVal 0&) = 0
    RegCloseKey hKey 'close the key
    CurKeyVal = StripTerminator(CurKeyVal) 'trim the key value
    
    'get device class for win95 or other
    If CI.ProductName = "Microsoft Windows 95" Then
        DevClass = CurKeyVal
    Else
        DevClass = ReadRemoteReg(HKEY_LOCAL_MACHINE, DriverKey & "\" & CurKeyVal, "Class")
        If DevClass = "" Then
            DevClass = CurKeyVal
        End If
    End If
    
    
    DevName = ReadRemoteReg(HKEY_LOCAL_MACHINE, DriverKey & "\" & CurKeyVal, "")
    If DevName > "" Then  'if the returned value isn't empty
        Incr NumDevTypes
        ReDim Preserve DevTypes(NumDevTypes)
        DevTypes(NumDevTypes).Class = DevClass  'add the device type to the array
        DevTypes(NumDevTypes).Name = DevName
    
    End If
    
    RegIndex = RegIndex + 1 'increment the registry index
    RegOpenKeyEx lhRemoteRegistry, DriverKey, 0, KEY_READ, hKey
    CurKeyVal = String(255, 0) 'reset variable
Wend

RegCloseKey hKey 'close registry key
GetDevTypesx = NumDevTypes 'return number of devices found

End Function

Public Function GetWinVersion() As String

        'if we do not know, try both (assuming 9x first)
        
        'set the version to 9x
        WinVersion = ReadRemoteReg(HKEY_LOCAL_MACHINE, "Software\Microsoft\Windows\CurrentVersion", "VersionNumber")
        If WinVersion = "" Then
            'set the version to NT
            WinVersion = ReadRemoteReg(HKEY_LOCAL_MACHINE, "Software\Microsoft\Windows NT\CurrentVersion", "CurrentVersion")
        End If
    
    'format version
    WinVersion = Format(WinVersion, "0.00")
    
    'remove separator as it differs between localities
    WinVersion = Left$(WinVersion, 1) & Right$(WinVersion, 2)
    
    'reset the treeview style just in case
    
    'retrieve the windows version
    Select Case WinVersion
    Case "510"
        WinVersion = "NT"
    Case "500"
        WinVersion = "NT"
    Case "490"
        WinVersion = "9x"
    Case "410"
        WinVersion = "9x"
    Case "400"
        If main.cmboWinVer.ListIndex = 0 Then
            WinVersion = "9x"
        Else
            WinVersion = "NT"
            'i dont' know how NT4 determines active devices....
            'so we'll just hide the icons
            main.TreeView1.Style = tvwTreelinesPlusMinusText
        End If
    Case Else
        MsgBox "Plese email the author with this information: " & WinVersion
    End Select

End Function
        
Function StripTerminator(sInput As String) As String
    Dim ZeroPos As Integer
    'Search the first chr$(0)
    ZeroPos = InStr(1, sInput, vbNullChar)
    If ZeroPos > 0 Then
        StripTerminator = Left$(sInput, ZeroPos - 1)
    Else
        StripTerminator = sInput
    End If

End Function

Function FindInRegX(level As Long, ByVal CurKey As String, srchFor As String) As Long
Dim hKey As Long
Dim KeyValType As Long
Dim KeyValSize As Long
Dim KeyVal As String
Dim tmpVal As String
Dim res As Long
Dim i As Integer
Dim iChar As Integer
Dim sChar, sWorkStr As String
Dim bUseZero As Boolean
Dim lReturnCode, lHive
Dim CurKeyVal As String, strfound As String
Dim CDevice As String


    
    If level = -1 Then Exit Function ' if we are out of levels, exit
    
    'open specified key
    res = RegOpenKeyEx(lhRemoteRegistry, CurKey, 0, KEY_READ, hKey)
    
    CurKeyVal = String(255, 0) 'load the buffer
    
    If RegEnumKeyEx(hKey, Count(level), CurKeyVal, 255, 0, vbNullString, ByVal 0&, ByVal 0&) <> 0 Then
        'if we are out of sublevels...
        RegCloseKey hKey 'close the registry key
        Count(level) = 0 'reset the count for this level
        level = level - 1 'move to the previous level
        'start searching again with the parent level
        FindInRegX level, TruncString(CurKey, "\", True, False), srchFor
        RegCloseKey hKey
        Exit Function
    Else
        'if we have more sublevels to search...
        RegCloseKey hKey 'close the current registry key
        CurKeyVal = StripTerminator(CurKeyVal) 'trim the buffer
       
        CurKey = CurKey & "\" & CurKeyVal 'set the current key = to the new key

        'search for the device class for win95 or all other
        If CI.ProductName = "Microsoft Windows 95" Then
            strfound = UCase$(ReadRemoteReg(HKEY_LOCAL_MACHINE, CurKey, "Class"))
        Else
            strfound = UCase$(ReadRemoteReg(HKEY_LOCAL_MACHINE, DriverKey & "\" & ReadRemoteReg(HKEY_LOCAL_MACHINE, CurKey, "ClassGUID"), "Class"))
        End If
        
        If strfound = UCase$(srchFor) Or UCase$(srchFor) = "ALL" And strfound <> "" Then
            'we found a matching device, or the search is for all devices...
            'make sure the device is a current one....
            'CDevice = UCase$(ReadRemoteReg(HKEY_LOCAL_MACHINE, CurKey & "\Control", "DeviceReference"))
            AddDeviceData strfound, CurKey  'add the device to the array
            Count(level) = Count(level) + 1 'increment key# of this level
            'start searching again on the parentlevel
            FindInRegX level, TruncString(CurKey, "\", True, False), srchFor
            RegCloseKey hKey
            Exit Function
        ElseIf strfound <> "" Then
            'if we found a device class that doesn't match
            Count(level) = Count(level) + 1 'increment key# of this level
            'start searching again on the parent level
            FindInRegX level, TruncString(CurKey, "\", True, False), srchFor
            RegCloseKey hKey
            Exit Function
        Else
            'if there is no "class" key in this level
            Count(level) = Count(level) + 1 'increment key# of this level
            level = level + 1 'go to the next level
            'start searching again
            FindInRegX level, CurKey, srchFor
            RegCloseKey hKey
            Exit Function
        End If
    End If

RegCloseKey hKey
End Function
Function FindInReg(DevType As String) As Long

NumExtraInfo = -1
NumDevices = -1 'reset the number of devices found
cntDeviceInfo = -1
NumDevProps = -1
'Determine if the current OS is supported
If DriverKey = "Unknown" Or DeviceKey = "Unknown" Then
    MsgBox "This OS is currently not supported"
    Exit Function
End If

FindInRegX 0, DeviceKey, DevType 'start finding devices
FindInReg = NumDevices 'return number of devices found
End Function
Function Incr(ByRef LongVar As Long)
    LongVar = LongVar + 1
End Function
Function AddDeviceData(Class As String, Key As String)

NumExtDevProps = -1 'reset the number of extra device properties
NumDevProps = -1 'reset the number of device properties
NumDrvProps = -1 'reset the number or driver properties

Incr NumDevices 'increment +1

ReDim Preserve DeviceInfo(NumDevices) 'redim array
ReDim Preserve DriverInfo(NumDevices) 'redim array

'load information into the device array
'Get generic device information from device reg key

AddDevInfo NumDevices, vbNullString, "Class", Class
AddDevInfo NumDevices, Key, "Compatible IDs", "CompatibleIds"
AddDevInfo NumDevices, Key, "Device Description", "DeviceDesc"
AddDevInfo NumDevices, Key, "Driver", "Driver"
AddDevInfo NumDevices, vbNullString, "ExtraInfoID", "-1"
AddDevInfo NumDevices, Key, "Friendly Name", "FriendlyName"
AddDevInfo NumDevices, Key, "Hardware ID", "HardwareID"
AddDevInfo NumDevices, Key, "Hardware Revision", "HWRevision"
AddDevInfo NumDevices, Key, "Location Information", "LocationInformation"
AddDevInfo NumDevices, Key, "Manufacturer", "Manufacturer"
AddDevInfo NumDevices, Key, "Mfg", "Mfg"
AddDevInfo NumDevices, vbNullString, "Registry Key", "HLM\" & Key
AddDevInfo NumDevices, Key, "Service", "Service"
AddDevInfo NumDevices, Key & "\Control", "In Use", "DeviceReference"

DriverPath = DriverKey & "\" & DeviceInfo(NumDevices).DevProps(3).PropVal
'get generic device information from driver reg key
AddDrvInfo NumDevices, DriverPath, "Device Loader", "DevLoader"
AddDrvInfo NumDevices, DriverPath, "Driver Date", "DriverDate"
AddDrvInfo NumDevices, DriverPath, "Driver Description", "DriverDesc"
AddDrvInfo NumDevices, DriverPath, "Driver Version", "DriverVersion"
AddDrvInfo NumDevices, DriverPath, "INF Path", "InfPath"
AddDrvInfo NumDevices, DriverPath, "INF Section", "InfSection"
AddDrvInfo NumDevices, DriverPath, "INF Section Ext", "InfDriverExt"
AddDrvInfo NumDevices, DriverPath, "Matching Device ID", "MatchingDeviceID"
AddDrvInfo NumDevices, DriverPath, "Port Driver", "Port Driver"
AddDrvInfo NumDevices, DriverPath, "Provider Name", "ProviderName"

'get specific device information
Select Case UCase(Class)
Case "CDROM"
    Incr NumExtraInfo
    ReDim Preserve ExtraInfo(NumExtraInfo)
    AddDevPropInfo NumExtraInfo, DriverPath, "Default DVD Region", "DefaultDVDRegion"
    AddDevPropInfo NumExtraInfo, DriverPath, "Digital Audio Play", "DigitalAudioPlay"
    DeviceInfo(NumDevices).DevProps(4).PropVal = NumExtraInfo

Case "DISPLAY"
    Incr NumExtraInfo
    ReDim Preserve ExtraInfo(NumExtraInfo)
       
    AddDevPropInfo NumExtraInfo, DriverPath, "CMDrivFlags", "CMDrivFlags"
    AddDevPropInfo NumExtraInfo, DriverPath, "Private Problem", "PrivateProblem"
    AddDevPropInfo NumExtraInfo, DriverPath, "Ver", "Ver"
    
    DeviceInfo(NumDevices).DevProps(4).PropVal = NumExtraInfo
Case "MODEM"
    '**********************************************************************
    'the modem code for win95 (4.00 and 4.03) has only been verified on 1 machine
    '**********************************************************************
    If WinVersion = "Win95" Then
        tKey = ReplaceText(TruncString(Key, "\", False, False), "&", "\")
        'this call was based on my hardware config,
        'it may not work on all win95 PC's
        
        Incr NumExtraInfo
        ReDim Preserve ExtraInfo(NumExtraInfo)
        
        AddDevPropInfo NumExtraInfo, DeviceKey & "\" & tKey, "Attached To", "PortName"
        DeviceInfo(NumDevices).DevProps(4).PropVal = NumExtraInfo
    Else
        Incr NumExtraInfo
        ReDim Preserve ExtraInfo(NumExtraInfo)
        
        
        AddDevPropInfo NumExtraInfo, DriverPath, "Attached To", "AttachedTo"
        
        'this is the case on my win98 laptop...
        If ExtraInfo(NumExtraInfo).DevProps(0).PropVal = "" Then
            ExtraInfo(NumExtraInfo).DevProps(0).PropVal = ReadRemoteReg(HKEY_LOCAL_MACHINE, Key, "PortName")
        End If
        
        AddDevPropInfo NumExtraInfo, DriverPath, "Caller ID Outside", "CallerIDOutside"
        AddDevPropInfo NumExtraInfo, DriverPath, "Caller ID Private", "CallerIDPrivate"
        AddDevPropInfo NumExtraInfo, DriverPath, "Logging Path", "LoggingPath"
        AddDevPropInfo NumExtraInfo, DriverPath, "Manufacturer", "Manufacturer"
        AddDevPropInfo NumExtraInfo, DriverPath, "Model", "Model"
        AddDevPropInfo NumExtraInfo, DriverPath, "Reset", "Reset"
        
        DeviceInfo(NumDevices).DevProps(4).PropVal = NumExtraInfo
    End If

Case "MONITOR"
    Incr NumExtraInfo
    ReDim Preserve ExtraInfo(NumExtraInfo)
    
    AddDevPropInfo NumExtraInfo, DriverPath, "DPMS", "DPMS"
    AddDevPropInfo NumExtraInfo, DriverPath, "Max Resolution", "MaxResolution"
    DeviceInfo(NumDevices).DevProps(4).PropVal = NumExtraInfo

Case "PORTS"
    Incr NumExtraInfo
    ReDim Preserve ExtraInfo(NumExtraInfo)

    AddDevPropInfo NumExtraInfo, DriverPath, "Contention", "Contention"
    AddDevPropInfo NumExtraInfo, DriverPath, "ECP Device", "ECPDevice"
    AddDevPropInfo NumExtraInfo, DriverPath, "Enumerator", "Enumerator"
    AddDevPropInfo NumExtraInfo, DriverPath, "Port Sub Class", "PortSubClass"
    DeviceInfo(NumDevices).DevProps(4).PropVal = NumExtraInfo

Case "SYSTEM"
    Incr NumExtraInfo
    ReDim Preserve ExtraInfo(NumExtraInfo)
    
    AddDevPropInfo NumExtraInfo, DriverPath, "PCI Device", "PCIDevice"
    AddDevPropInfo NumExtraInfo, DriverPath, "Resource Picker Exceptions", "ResourcePickerExceptions"
    AddDevPropInfo NumExtraInfo, DriverPath, "Resource Picker Tags", "ResourcePickerTags"
    
    DeviceInfo(NumDevices).DevProps(4).PropVal = NumExtraInfo

End Select

End Function
Private Function AddDevPropInfo(index As Long, RegPath As String, PropName As String, Propkey As String)

Incr NumExtDevProps
ReDim Preserve ExtraInfo(NumExtraInfo).DevProps(NumExtDevProps)

ExtraInfo(index).DevProps(NumExtDevProps).PropDesc = PropName
ExtraInfo(index).DevProps(NumExtDevProps).PropVal = ReadRemoteReg(HKEY_LOCAL_MACHINE, RegPath, Propkey)

End Function
Private Function AddDevInfo(index As Long, RegPath As String, PropName As String, Propkey As String)

Incr NumDevProps
ReDim Preserve DeviceInfo(NumDevices).DevProps(NumDevProps)

DeviceInfo(index).DevProps(NumDevProps).PropDesc = PropName
If RegPath > "" Then
    DeviceInfo(index).DevProps(NumDevProps).PropVal = ReadRemoteReg(HKEY_LOCAL_MACHINE, RegPath, Propkey)
Else
    DeviceInfo(index).DevProps(NumDevProps).PropVal = Propkey
End If

End Function
Private Function AddDrvInfo(index As Long, RegPath As String, PropName As String, Propkey As String)

Incr NumDrvProps 'increment +1
ReDim Preserve DriverInfo(NumDevices).DevProps(NumDrvProps) 'resize array

DriverInfo(index).DevProps(NumDrvProps).PropDesc = PropName
If RegPath > "" Then 'if the user want to find the val in the registry
    DriverInfo(index).DevProps(NumDrvProps).PropVal = ReadRemoteReg(HKEY_LOCAL_MACHINE, RegPath, Propkey)
Else
    'if the user specified the value
    DriverInfo(index).DevProps(NumDrvProps).PropVal = Propkey
End If

End Function
Function GetRegKeys()
'get the registry keys needed for the current OS
Select Case WinVersion
Case "NT"
    DeviceKey = "SYSTEM\CurrentControlSet\Enum" 'the key containing device information
    DriverKey = "SYSTEM\CurrentControlSet\Control\Class" 'the key containing driver information
Case "9x"
    DeviceKey = "Enum" 'the key containing device information
    DriverKey = "SYSTEM\CurrentControlSet\Services\Class" 'the key containing driver information
Case Else
    'add info for other OS's
    DeviceKey = "Unknown"
    DriverKey = "Unknown"
End Select
End Function

Function TruncString(SText As String, SString As String, Front As Boolean, srchForward As Boolean) As String
'trims the rear/front off a string before/after a certain character
If InStr(1, SText, SString) = False Then Exit Function
If srchForward = True Then
    'search from the start of string to the end returning
    'before or after where it is found
    If Front = True Then
        TruncString = Left$(SText, InStr(1, SText, SString, vbTextCompare) - 1)
    Else
        TruncString = Right$(SText, Len(SText) - (InStr(1, SText, SString)))
    End If
Else
    'search from end of string forward, returning string
    'before or after where the string is found
    If Front = True Then
        TruncString = Left$(SText, InStrRev(SText, SString) - 1)
    Else
        TruncString = Right(SText, Len(SText) - InStrRev(SText, SString))
    End If
End If
End Function
Function TCase(strInput As String) As String
    'convert string to Title Case
    TCase = UCase$(Left$(strInput, 1)) & LCase$(Right$(strInput, Len(strInput) - 1))
End Function
Function ReplaceText(strInput As String, oText As String, rText As String) As String


Dim sPosition As Long, FoundAt As Long
sPosition = 1
FoundAt = InStr(sPosition, strInput, oText, vbTextCompare)
While FoundAt <> 0
    strInput = Left$(strInput, FoundAt - 1) & rText & Right$(strInput, Len(strInput) - (FoundAt - 1) - 1)
    sPosition = FoundAt + 1
    FoundAt = InStr(sPosition, strInput, oText, vbTextCompare)
Wend
ReplaceText = strInput
End Function
Function GetDevFriendlyName(ByVal dClass As String) As String
    'get the friendly name of a device type
    For x = 0 To NumDevTypes
        If UCase(DevTypes(x).Class) = UCase(dClass) Then
            GetDevFriendlyName = DevTypes(x).Name
            Exit For
        End If
    Next x
End Function
Public Function GetComputerInfo() As Long
Dim CVPath As String, HSPath As String, CPUPath As String

HSPath = "HARDWARE\Description\System"
CPUPath = HSPath & "\CentralProcessor\0"

If WinVersion = "NT" Then
    CVPath = "SOFTWARE\Microsoft\Windows NT\CurrentVersion"
Else
    CVPath = "SOFTWARE\Microsoft\Windows\CurrentVersion"
End If
    With CI
        .ProductName = ReadRemoteReg(HKEY_LOCAL_MACHINE, CVPath, "ProductName")
        If .ProductName = "" Then .ProductName = "Microsoft Windows NT"
        If WinVersion = "NT" Then
            'winnt splits it up
            .CurrentVersion = ReadRemoteReg(HKEY_LOCAL_MACHINE, CVPath, "CurrentVersion")
            .CurrentBuildNumber = ReadRemoteReg(HKEY_LOCAL_MACHINE, CVPath, "CurrentBuildNumber")
        Else
            'win95 has it all as one
            .CurrentVersion = ReadRemoteReg(HKEY_LOCAL_MACHINE, CVPath, "VersionNumber")
        End If
        .CSDVersion = ReadRemoteReg(HKEY_LOCAL_MACHINE, CVPath, "CSDVersion")
        .ProductID = ReadRemoteReg(HKEY_LOCAL_MACHINE, CVPath, "ProductID")
        .RegisteredOwner = ReadRemoteReg(HKEY_LOCAL_MACHINE, CVPath, "RegisteredOwner")
        .RegisteredOrganization = ReadRemoteReg(HKEY_LOCAL_MACHINE, CVPath, "RegisteredOrganization")
        .SystemIdentifier = ReadRemoteReg(HKEY_LOCAL_MACHINE, HSPath, "Identifier")
        If .SystemIdentifier = "" Then
            GetComputerInfo = 1
            Exit Function
        End If
        .SystemBiosDate = ReadRemoteReg(HKEY_LOCAL_MACHINE, HSPath, "SystemBiosDate")
        .SystemBiosVersion = ReadRemoteReg(HKEY_LOCAL_MACHINE, HSPath, "SystemBiosVersion")
        .VideoBiosDate = ReadRemoteReg(HKEY_LOCAL_MACHINE, HSPath, "VideoBiosDate")
        .VideoBiosVersion = ReadRemoteReg(HKEY_LOCAL_MACHINE, HSPath, "VideoBiosVersion")
    End With
    With CPU
        .ProcessorNameString = ReadRemoteReg(HKEY_LOCAL_MACHINE, CPUPath, "ProcessorNameString")
        .VendorIdentifier = ReadRemoteReg(HKEY_LOCAL_MACHINE, CPUPath, "VendorIdentifier")
        .Identifier = ReadRemoteReg(HKEY_LOCAL_MACHINE, CPUPath, "Identifier")
        'mhz is reported in hex, this converts it to decimal
        .MHz = CLng("&H" & ReadRemoteReg(HKEY_LOCAL_MACHINE, CPUPath, "~Mhz"))

    End With
End Function
Public Function GetCompName() As String

Dim dwLen As Long
Dim strString As String
    
'Create a buffer
dwLen = MAX_COMPUTERNAME_LENGTH + 1
strString = String(dwLen, "X")
    
'Get the computer name
GetComputerName strString, dwLen
    
'get only the actual data
ComputerName = Left(strString, dwLen)
GetCompName = ComputerName
End Function
Public Function OpenRegistry(CompName As String) As Long

'connect to remote registry
lReturnCode = RegConnectRegistry(CompName, HKEY_LOCAL_MACHINE, lhRemoteRegistry)
    
If lReturnCode <> 0 Then
    MsgBox "Could not connect to registry on " & CompName
    OpenRegistry = 1
Else
    OpenRegistry = 0
End If
End Function

Public Function GetNetComputers(strServerName As String)
   Dim colReturn As Collection
    Set colReturn = New Collection
    Dim arrServerName() As Byte
    Dim Users() As Long
    Dim buff As Long
    Dim buffsize As Long
    Dim entriesread As Long
    Dim totalentries As Long
    Dim cnt As Integer
    buffsize = 255
    If Left(strServerName, 2) <> "\\" Then strServerName = "\\" & strServerName
    
    strServerName = strServerName & Chr(0)
    arrServerName() = strServerName
    If NetUserEnum(arrServerName(0), 0, FILTER_WORKSTATION_TRUST_ACCOUNT, buff, buffsize, entriesread, totalentries, 0&) = ERROR_SUCCESS Then
        ReDim Users(0 To entriesread - 1) As Long
        CopyMemory Users(0), ByVal buff, entriesread * 4
        For cnt = 0 To entriesread - 1
            Temp = GetPointerToByteStringW(Users(cnt))
            Temp = Left(Temp, Len(Temp) - 1)
            main.cmboComp.AddItem Temp
        Next cnt
        NetApiBufferFree buff
    End If

End Function

Private Function GetPointerToByteStringW(lpString As Long) As String
    Dim buff() As Byte
    Dim nSize As Long
    
    If lpString Then
        nSize = lstrlenW(lpString) * 2
    
        If nSize Then
            ReDim buff(0 To (nSize - 1)) As Byte
            
            CopyMemory buff(0), ByVal lpString, nSize
            
            GetPointerToByteStringW = buff
        End If
    End If
End Function



