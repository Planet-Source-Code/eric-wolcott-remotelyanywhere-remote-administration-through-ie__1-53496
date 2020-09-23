Attribute VB_Name = "Module3"
Option Explicit

Private Declare Function GetFileTime Lib "kernel32" (ByVal hFile As Long, lpCreationTime As FILE_TIME, lpLastAccessTime As FILE_TIME, lpLastWriteTime As FILE_TIME) As Long
Private Declare Function GetFileVersionInfo Lib "Version.dll" Alias "GetFileVersionInfoA" (ByVal lptstrFilename As String, ByVal dwhandle As Long, ByVal dwlen As Long, lpData As Any) As Long
Private Declare Function GetFileVersionInfoSize Lib "Version.dll" Alias "GetFileVersionInfoSizeA" (ByVal lptstrFilename As String, lpdwHandle As Long) As Long
Private Declare Function VerQueryValue Lib "Version.dll" Alias "VerQueryValueA" (pBlock As Any, ByVal lpSubBlock As String, lplpBuffer As Any, puLen As Long) As Long
Private Declare Function OpenFile Lib "kernel32" (ByVal lpFileName As String, lpReOpenBuff As OF_STRUCT, ByVal wStyle As Long) As Long
Private Declare Function lclose Lib "kernel32" Alias "_lclose" (ByVal hFile As Long) As Long
Private Declare Function FileTimeToLocalFileTime Lib "kernel32" (lpFileTime As FILE_TIME, lpLocalFileTime As FILE_TIME) As Long
Private Declare Function FileTimeToSystemTime Lib "kernel32" (lpFileTime As FILE_TIME, lpSystemTime As SYSTEM_TIME) As Long
Private Declare Function GetFileAttributes Lib "kernel32" Alias "GetFileAttributesA" (ByVal lpFileName As String) As Long
Private Declare Sub MoveMemory Lib "kernel32" Alias "RtlMoveMemory" (dest As Any, ByVal Source As Long, ByVal Length As Long)

Private Declare Function lstrcpy Lib "kernel32" Alias "lstrcpyA" (ByVal lpString1 As String, ByVal lpString2 As Long) As Long

Private Const OF_READ = &H0
Private Const OF_SHARE_DENY_NONE = &H40
Private Const OFS_MAXPATHNAME = 128

' ===== From Win32 Ver.h =================
' ----- VS_VERSION.dwFileFlags -----
Private Const VS_FFI_SIGNATURE = &HFEEF04BD
Private Const VS_FFI_STRUCVERSION = &H10000
Private Const VS_FFI_FILEFLAGSMASK = &H3F&

' ----- VS_VERSION.dwFileFlags -----
Private Const VS_FF_DEBUG = &H1
Private Const VS_FF_PRERELEASE = &H2
Private Const VS_FF_PATCHED = &H4
Private Const VS_FF_PRIVATEBUILD = &H8
Private Const VS_FF_INFOINFERRED = &H10
Private Const VS_FF_SPECIALBUILD = &H20

' ----- VS_VERSION.dwFileOS -----
Private Const VOS_UNKNOWN = &H0
Private Const VOS_DOS = &H10000
Private Const VOS_OS216 = &H20000
Private Const VOS_OS232 = &H30000
Private Const VOS_NT = &H40000
Private Const VOS__BASE = &H0
Private Const VOS__WINDOWS16 = &H1
Private Const VOS__PM16 = &H2
Private Const VOS__PM32 = &H3
Private Const VOS__WINDOWS32 = &H4

Private Const VOS_DOS_WINDOWS16 = &H10001
Private Const VOS_DOS_WINDOWS32 = &H10004
Private Const VOS_OS216_PM16 = &H20002
Private Const VOS_OS232_PM32 = &H30003
Private Const VOS_NT_WINDOWS32 = &H40004


' ----- VS_VERSION.dwFileType -----
Private Const VFT_UNKNOWN = &H0
Private Const VFT_APP = &H1
Private Const VFT_DLL = &H2
Private Const VFT_DRV = &H3
Private Const VFT_FONT = &H4
Private Const VFT_VXD = &H5
Private Const VFT_STATIC_LIB = &H7

' ----- VS_VERSION.dwFileSubtype for VFT_WINDOWS_DRV -----
Private Const VFT2_UNKNOWN = &H0
Private Const VFT2_DRV_PRINTER = &H1
Private Const VFT2_DRV_KEYBOARD = &H2
Private Const VFT2_DRV_LANGUAGE = &H3
Private Const VFT2_DRV_DISPLAY = &H4
Private Const VFT2_DRV_MOUSE = &H5
Private Const VFT2_DRV_NETWORK = &H6
Private Const VFT2_DRV_SYSTEM = &H7
Private Const VFT2_DRV_INSTALLABLE = &H8
Private Const VFT2_DRV_SOUND = &H9
Private Const VFT2_DRV_COMM = &HA

Private Type VS_FIXEDFILEINFO
    dwSignature As Long
    dwStrucVersionl As Integer ' e.g. = &h0000 = 0
    dwStrucVersionh As Integer ' e.g. = &h0042 = .42
    dwFileVersionMSl As Integer ' e.g. = &h0003 = 3
    dwFileVersionMSh As Integer ' e.g. = &h0075 = .75
    dwFileVersionLSl As Integer ' e.g. = &h0000 = 0
    dwFileVersionLSh As Integer ' e.g. = &h0031 = .31
    dwProductVersionMSl As Integer ' e.g. = &h0003 = 3
    dwProductVersionMSh As Integer ' e.g. = &h0010 = .1
    dwProductVersionLSl As Integer ' e.g. = &h0000 = 0
    dwProductVersionLSh As Integer ' e.g. = &h0031 = .31
    dwFileFlagsMask As Long ' = &h3F For version "0.42"
    dwFileFlags As Long ' e.g. VFF_DEBUG Or VFF_PRERELEASE
    dwFileOS As Long ' e.g. VOS_DOS_WINDOWS16
    dwFileType As Long ' e.g. VFT_DRIVER
    dwFileSubtype As Long ' e.g. VFT2_DRV_KEYBOARD
    dwFileDateMS As Long ' e.g. 0
    dwFileDateLS As Long ' e.g. 0
End Type


Public Type FILE_ATTRIBUTES
    bArchive As Boolean
    bCompressed As Boolean
    bDirectory As Boolean
    bHidden As Boolean
    bNormal As Boolean
    bReadOnly As Boolean
    bSystem As Boolean
    bTemporary As Boolean
End Type

Public Type FILE_INFORMATION
    cFilename As String
    cDirectory As String
    cFullFilePath As String
    cFileType As String
    nVerMajor As Long
    nVerMinor As Long
    nVerRevision As Long
    nVerNotUsedVB As Long
    nFileSize As Long
    nFileAttributes As Long
    nFileType As Long
    faFileAttributes As FILE_ATTRIBUTES
    dtCreationDate As Date
    dtLastModifyTime As Date
    dtLastAccessTime As Date
    sCompanyName As String
    sFileDescription As String
    sFileVersion As String
    sInternalName As String
    sLegalCopyright As String
    sOriginalFileName As String
    sProductName As String
    sProductVersion As String
End Type

Private Type SYSTEM_TIME
    wYear As Integer
    wMonth As Integer
    wDayOfWeek As Integer
    wDay As Integer
    wHour As Integer
    wMinute As Integer
    wSecond As Integer
    wMilliseconds As Integer
End Type

Private Type FILE_TIME
    dwLowDateTime As Long
    dwHighDateTime As Long
End Type

Private Type OF_STRUCT
     cBytes As Byte
     fFixedDisk As Byte
     nErrCode As Integer
     Reserved1 As Integer
     Reserved2 As Integer
     szPathName(OFS_MAXPATHNAME) As Byte
End Type

Public Function GetFileInformation(ByVal fileFullPath As String, ByRef FileInformation As FILE_INFORMATION, Optional ByVal showMsgBox As Boolean = False) As Boolean
Dim lDummy As Long, lsize As Long, rc As Long
Dim lVerbufferLen As Long
Dim sBuffer() As Byte
Dim udtVerBuffer As VS_FIXEDFILEINFO
Dim hFile As Integer
Dim FileStruct As OF_STRUCT
Dim CreationTime As FILE_TIME
Dim LastAccessTime As FILE_TIME
Dim LastWriteTime As FILE_TIME
Dim LocalFileTime As SYSTEM_TIME
Dim MessageString As String

Dim lBufferLen As Long
Dim bytebuffer(255) As Byte
Dim Lang_Charset_String As String
Dim HexNumber As Long
Dim i As Integer
Dim strTemp As String
Dim buffer As String
Dim lVerPointer As Long
Dim strVersionInfo(7) As String

    On Error GoTo e_HandleFileInformationError
    
    With FileInformation
        lsize = GetFileVersionInfoSize(fileFullPath, lDummy)
        If lsize >= 1 Then
            ReDim sBuffer(lsize)
            rc = GetFileVersionInfo(fileFullPath, 0&, lsize, sBuffer(0))
            rc = VerQueryValue(sBuffer(0), "\", lVerPointer, lVerbufferLen)
            MoveMemory udtVerBuffer, lVerPointer, Len(udtVerBuffer)
        End If
        
        '**** Determine Filename Info ****
        .cFullFilePath = fileFullPath
        .cFilename = DetermineFilename(fileFullPath)
        .cDirectory = DetermineDirectory(fileFullPath)
        
        '**** Determine File Date Info ****
        hFile = OpenFile(fileFullPath, FileStruct, OF_READ Or OF_SHARE_DENY_NONE)
        If GetFileTime(hFile, CreationTime, LastAccessTime, LastWriteTime) Then
            Call FileTimeToLocalFileTime(LastAccessTime, LastAccessTime)
            If Not FileTimeToSystemTime(LastAccessTime, LocalFileTime) Then
                .dtLastAccessTime = Format(LocalFileTime.wMonth, "00") & "/" & Format(LocalFileTime.wDay, "00") & "/" & Format(LocalFileTime.wYear, "0000") & " " & Format(LocalFileTime.wHour, "00") & ":" & Format(LocalFileTime.wMinute, "00") & ":" & Format(LocalFileTime.wSecond, "00")
            End If
            Call FileTimeToLocalFileTime(CreationTime, CreationTime)
            If Not FileTimeToSystemTime(CreationTime, LocalFileTime) Then
                .dtCreationDate = Format(LocalFileTime.wMonth, "00") & "/" & Format(LocalFileTime.wDay, "00") & "/" & Format(LocalFileTime.wYear, "0000") & " " & Format(LocalFileTime.wHour, "00") & ":" & Format(LocalFileTime.wMinute, "00") & ":" & Format(LocalFileTime.wSecond, "00")
            End If
            Call FileTimeToLocalFileTime(LastWriteTime, LastWriteTime)
            If Not FileTimeToSystemTime(LastWriteTime, LocalFileTime) Then
                .dtLastModifyTime = Format(LocalFileTime.wMonth, "00") & "/" & Format(LocalFileTime.wDay, "00") & "/" & Format(LocalFileTime.wYear, "0000") & " " & Format(LocalFileTime.wHour, "00") & ":" & Format(LocalFileTime.wMinute, "00") & ":" & Format(LocalFileTime.wSecond, "00")
            End If
        End If
    
        Call lclose(hFile)
    
        '**** Determine File Attributes and Size
        .nFileType = udtVerBuffer.dwFileType
        Select Case .nFileType
            Case VFT_UNKNOWN
                .cFileType = "Unknown"
            Case VFT_APP
                .cFileType = "Application"
            Case VFT_DLL
                .cFileType = "DLL Library"
            Case VFT_DRV
                .cFileType = "Driver"
            Case VFT_FONT
                .cFileType = "Font"
            Case VFT_VXD
                .cFileType = "VXD File"
            Case VFT_STATIC_LIB
                .cFileType = "Static Library"
            Case Else
                .cFileType = "Unknown"
        End Select
        
        .nFileAttributes = GetFileAttributes(fileFullPath)
        If .nFileAttributes And &H20 Then
            .faFileAttributes.bArchive = True
        Else
            .faFileAttributes.bArchive = False
        End If
        If .nFileAttributes And &H800 Then
            .faFileAttributes.bCompressed = True
        Else
            .faFileAttributes.bCompressed = False
        End If
        If .nFileAttributes And &H10 Then
            .faFileAttributes.bDirectory = True
        Else
            .faFileAttributes.bDirectory = False
        End If
        If .nFileAttributes And &H2 Then
            .faFileAttributes.bHidden = True
        Else
            .faFileAttributes.bHidden = False
        End If
        If .nFileAttributes And &H80 Then
            .faFileAttributes.bNormal = True
        Else
            .faFileAttributes.bNormal = False
        End If
        If .nFileAttributes And &H1 Then
            .faFileAttributes.bReadOnly = True
        Else
            .faFileAttributes.bReadOnly = False
        End If
        If .nFileAttributes And &H4 Then
            .faFileAttributes.bSystem = True
        Else
            .faFileAttributes.bSystem = False
        End If
        If .nFileAttributes And &H100 Then
            .faFileAttributes.bTemporary = True
        Else
            .faFileAttributes.bTemporary = False
        End If
    
        .nFileSize = FileLen(fileFullPath)
        
    '**** Determine Product Version number ****
        If lsize >= 1 Then
            .nVerMajor = udtVerBuffer.dwProductVersionMSh
            .nVerMinor = udtVerBuffer.dwProductVersionMSl
            .nVerNotUsedVB = udtVerBuffer.dwFileVersionLSh
            .nVerRevision = udtVerBuffer.dwFileVersionLSl
        End If
    End With
    
'**** Company Name and other String Info ****
    
     '*** We will check the FileDescription of the gdi32.dll****
     buffer = String(255, 0)

     '*** Get size ****
     lBufferLen = GetFileVersionInfoSize(fileFullPath, lDummy)
     If lBufferLen >= 1 Then

         ReDim sBuffer(lBufferLen)
         rc = GetFileVersionInfo(fileFullPath, 0&, lBufferLen, sBuffer(0))
         If rc <> 0 Then

             rc = VerQueryValue(sBuffer(0), "\VarFileInfo\Translation", lVerPointer, lBufferLen)
    
             If rc <> 0 Then
                 'lVerPointer is a pointer to four 4 bytes of Hex number,
                 'first two bytes are language id, and last two bytes are code
                 'page. However, Lang_Charset_String needs a  string of
                 '4 hex digits, the first two characters correspond to the
                 'language id and last two the last two character correspond
                 'to the code page id.
        
                 MoveMemory bytebuffer(0), lVerPointer, lBufferLen
        
                 HexNumber = bytebuffer(2) + bytebuffer(3) * &H100 + _
                 bytebuffer(0) * &H10000 + bytebuffer(1) * &H1000000
                 Lang_Charset_String = Hex(HexNumber)
                 'now we change the order of the language id and code page
                 'and convert it into a string representation.
                 'For example, it may look like 040904E4
                 'Or to pull it all apart:
                 '04------        = SUBLANG_ENGLISH_USA
                 '--09----        = LANG_ENGLISH
                 ' ----04E4 = 1252 = Codepage for Windows:Multilingual
        
                 Do While Len(Lang_Charset_String) < 8
                    Lang_Charset_String = "0" & Lang_Charset_String
                 Loop
                
                With FileInformation
                    .sCompanyName = GetStringValue("\StringFileInfo\" & Lang_Charset_String & "\" & "CompanyName", lVerPointer, lBufferLen, sBuffer)
                    .sFileDescription = GetStringValue("\StringFileInfo\" & Lang_Charset_String & "\" & "FileDescription", lVerPointer, lBufferLen, sBuffer)
                    .sFileVersion = GetStringValue("\StringFileInfo\" & Lang_Charset_String & "\" & "FileVersion", lVerPointer, lBufferLen, sBuffer)
                    .sInternalName = GetStringValue("\StringFileInfo\" & Lang_Charset_String & "\" & "InternalName", lVerPointer, lBufferLen, sBuffer)
                    .sLegalCopyright = GetStringValue("\StringFileInfo\" & Lang_Charset_String & "\" & "LegalCopyright", lVerPointer, lBufferLen, sBuffer)
                    .sOriginalFileName = GetStringValue("\StringFileInfo\" & Lang_Charset_String & "\" & "OriginalFileName", lVerPointer, lBufferLen, sBuffer)
                    .sProductName = GetStringValue("\StringFileInfo\" & Lang_Charset_String & "\" & "ProductName", lVerPointer, lBufferLen, sBuffer)
                    .sProductVersion = GetStringValue("\StringFileInfo\" & Lang_Charset_String & "\" & "ProductVersion", lVerPointer, lBufferLen, sBuffer)
                End With
            End If
        End If
    End If
'         strVersionInfo(0) = "CompanyName"
'         strVersionInfo(1) = "FileDescription"
'         strVersionInfo(2) = "FileVersion"
'         strVersionInfo(3) = "InternalName"
'         strVersionInfo(4) = "LegalCopyright"
'         strVersionInfo(5) = "OriginalFileName"
'         strVersionInfo(6) = "ProductName"
'         strVersionInfo(7) = "ProductVersion"

    GetFileInformation = True
    Exit Function
    
e_HandleFileInformationError:
    GetFileInformation = False
    Exit Function
End Function
Private Function GetStringValue(ByRef searchString As String, ByVal lVerPointer As Long, ByVal lBufferLen As Long, ByRef sBuffer() As Byte) As String
Dim buffer As String
Dim strTemp As String
Dim rc As Long

    GetStringValue = ""
    buffer = String(255, 0)
    rc = VerQueryValue(sBuffer(0), searchString, lVerPointer, lBufferLen)
    
    If rc <> 0 Then
        lstrcpy buffer, lVerPointer
        GetStringValue = Mid$(buffer, 1, InStr(buffer, Chr(0)) - 1)
    End If

End Function
Private Function DetermineDirectory(inputString As String) As String
Dim pos As Integer
    pos = InStrRev(inputString, "\", , vbTextCompare)
    DetermineDirectory = Mid(inputString, 1, pos)
End Function
Private Function DetermineFilename(inputString As String) As String
Dim pos As Integer
    pos = InStrRev(inputString, "\", , vbTextCompare)
    DetermineFilename = Mid(inputString, pos + 1, Len(inputString) - pos)
End Function
Private Function DetermineDrive(inputString As String) As String
Dim pos As Integer
    If inputString = "" Then Exit Function
    pos = InStr(1, inputString, ":\", vbTextCompare)
    DetermineDrive = Mid(inputString, 1, pos - 1)
End Function



