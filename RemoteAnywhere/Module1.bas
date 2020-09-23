Attribute VB_Name = "Module1"
Public Declare Function GetComputerName Lib "kernel32" Alias "GetComputerNameA" (ByVal lpBuffer As String, nSize As Long) As Long
Public Declare Function SetComputerName Lib "kernel32" Alias "SetComputerNameA" (ByVal lpComputerName As String) As Long
Public Declare Function GetTickCount Lib "kernel32" () As Long
Public Declare Function GetFileType Lib "kernel32" (ByVal hFile As Long) As Long
Public Declare Function CreateFile Lib "kernel32" Alias "CreateFileA" (ByVal lpFileName As String, ByVal dwDesiredAccess As Long, ByVal dwShareMode As Long, lpSecurityAttributes As Any, ByVal dwCreationDisposition As Long, ByVal dwFlagsAndAttributes As Long, ByVal hTemplateFile As Long) As Long
Public Declare Function GetFileSizeEx Lib "kernel32" (ByVal hFile As Long, lpFileSize As Currency) As Boolean
Public Declare Function CloseHandle Lib "kernel32" (ByVal hObject As Long) As Long
Public Declare Function GetFileAttributes Lib "kernel32" Alias "GetFileAttributesA" (ByVal lpFileName As String) As Long
Public Declare Function CopyFile Lib "kernel32" Alias "CopyFileA" (ByVal lpExistingFileName As String, ByVal lpNewFileName As String, ByVal bFailIfExists As Long) As Long
Public Declare Function CreateDirectory Lib "kernel32" Alias "CreateDirectoryA" (ByVal lpPathName As String, lpSecurityAttributes As Long) As Long
Public Declare Function DeleteFile Lib "kernel32" Alias "DeleteFileA" (ByVal lpFileName As String) As Long
Public Declare Function GetFileSize Lib "kernel32" (ByVal hFile As Long, lpFileSizeHigh As Long) As Long
Public Declare Function GetFileTime Lib "kernel32" (ByVal hFile As Long, lpCreationTime As FILETIME, lpLastAccessTime As FILETIME, lpLastWriteTime As FILETIME) As Long
Public Declare Function MoveFile Lib "kernel32" Alias "MoveFileA" (ByVal lpExistingFileName As String, ByVal lpNewFileName As String) As Long
Public Declare Function SHFileOperation Lib "shell32.dll" Alias "SHFileOperationA" (lpFileOp As SHFILEOPSTRUCT) As Long
Public Declare Function FileTimeToSystemTime Lib "kernel32" (lpFileTime As FILETIME, lpSystemTime As SYSTEMTIME) As Long
Public Declare Function FileTimeToLocalFileTime Lib "kernel32" (lpFileTime As FILETIME, lpLocalFileTime As FILETIME) As Long
Public Declare Function GetVersionEx Lib "kernel32" Alias "GetVersionExA" (lpVersionInformation As OSVERSIONINFO) As Long
Public Declare Function BitBlt Lib "gdi32" (ByVal hDestDC As Long, ByVal x As Long, ByVal y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal hSrcDC As Long, ByVal xSrc As Long, ByVal ySrc As Long, ByVal dwRop As Long) As Long
Public Declare Function GetDesktopWindow Lib "user32" () As Long
Public Declare Function GetDC Lib "user32" (ByVal hwnd As Long) As Long
Public Declare Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Long)

Public Declare Function GetVersionExA Lib "kernel32" _
         (lpVersionInformation As OSVERSIONINFO) As Integer

      Public Type OSVERSIONINFO
         dwOSVersionInfoSize As Long
         dwMajorVersion As Long
         dwMinorVersion As Long
         dwBuildNumber As Long
         dwPlatformID As Long
         szCSDVersion As String * 128
      End Type

Private Const GENERIC_WRITE = &H40000000
Private Const OPEN_EXISTING = 3
Private Const FILE_SHARE_READ = &H1
Private Const FILE_SHARE_WRITE = &H2
Private Const FO_DELETE = &H3
Const GENERIC_READ = &H80000000
Const FILE_TYPE_CHAR = &H2
Const FILE_TYPE_DISK = &H1
Const FILE_TYPE_PIPE = &H3
Const FILE_TYPE_UNKNOWN = &H0

Private Type FILETIME
    dwLowDateTime As Long
    dwHighDateTime As Long
End Type
Private Type SHFILEOPSTRUCT
    hwnd As Long
    wFunc As Long
    pFrom As String
    pTo As String
    fFlags As Integer
    fAborted As Boolean
    hNameMaps As Long
    sProgress As String
End Type
Private Type SYSTEMTIME
    wYear As Integer
    wMonth As Integer
    wDayOfWeek As Integer
    wDay As Integer
    wHour As Integer
    wMinute As Integer
    wSecond As Integer
    wMilliseconds As Integer
End Type

Public Type RunningTime
    Hours As Long
    Minutes As Long
    Seconds As Long
    start As Long
    StartDate As String
End Type

Public Type Server
    BytesSent As Long
    BytesReceived As Long
    ConnectionsRequests As Integer
End Type

Public Type Performance
    CPULoadPercent As String
    MemoryLoadPercent As String
    PhysicalMemoryTotal As String
    PhysicalMemoryAvailable As String
    PhysicalMemoryUsed As String
    PhysicalMemoryPercent1 As String
    PhysicalMemoryPercent2 As String
    PageFileTotal As String
    PageFileAvailable As String
    VirtualMemoryTotal As String
    VirtualMemoryAvailable As String
    VirtualMemoryUsed As String
    VirtualMemoryPercent1 As String
    VirtualMemoryPercent2 As String
    HDTotalFreeBytes As String
    HDTotalBytes As String
    HDAvailableFreeBytes As String
    HDTotalBytesUsed As String
    HDAvailablePercent As String
    RAMTotal As String
    RAMAvailible As String
    Processor As String
    ProcessorVendor As String
    ServicePack As String
    OperatingSystem As String
    ProcessorMHS As String
    BIOSVersion As String
    BIOSDate As String
End Type

Public Type User
    LoggenOn As Boolean
    IP As String
    RequestAuth As Boolean
End Type

Public Type FileManager
    BroswePath As String
    Content As String
    FilesCount As Integer
    FolderCount As Integer
    Foldersize As Integer
End Type

Public Function FormatFileSize(ByVal dblFileSize As Double, _
    Optional ByVal strFormatMask As String) _
    As String
    Select Case dblFileSize
        Case 0 To 1023 ' Bytes
        FormatFileSize = Format(dblFileSize) & " bytes"
            Case 1024 To 1048575 ' KB
            If strFormatMask = Empty Then strFormatMask = "###0"
            FormatFileSize = Format(dblFileSize / 1024#, strFormatMask) & " KB"
                Case 1024# ^ 2 To 1073741823 ' MB
                If strFormatMask = Empty Then strFormatMask = "###0.0"


                FormatFileSize = Format(dblFileSize / (1024# ^ 2), strFormatMask) & " MB"
                    Case Is > 1073741823# ' GB
                    If strFormatMask = Empty Then strFormatMask = "###0.0"


                    FormatFileSize = Format(dblFileSize / (1024# ^ 3), strFormatMask) & " GB"
                    End Select
            End Function



      Public Function getVersion() As String
         Dim OSInfo As OSVERSIONINFO
         Dim retvalue As Integer

         OSInfo.dwOSVersionInfoSize = 148
         OSInfo.szCSDVersion = Space$(128)
         retvalue = GetVersionExA(OSInfo)

         With OSInfo
         Select Case .dwPlatformID

          Case 1
          
              Select Case .dwMinorVersion
                  Case 0
                      getVersion = "Microsoft Windows 95"
                  Case 10
                      If .dwBuildNumber >= 2183 Then
                          getVersion = "Microsoft Windows 98 Second Edition"
                      Else
                          getVersion = "Microsoft Windows 98"
                      End If
                  Case 90
                      getVersion = "Microsoft Windows Mellinnium Edition"
              End Select

          Case 2
              Select Case .dwMajorVersion
                  Case 3
                      getVersion = "Microsoft Windows NT 3.51"
                  Case 4
                      getVersion = "Microsoft Windows NT 4.0"
                  Case 5
                      If .dwMinorVersion = 0 Then
                          getVersion = "Microsoft Windows 2000"
                      ElseIf .dwMinorVersion = 1 Then
                          getVersion = "Microsoft Windows XP"
                      Else
                          getVersion = "Microsoft Windows Sever 2003"
                      End If
              End Select

          Case Else
             getVersion = "Failed"
             
        End Select

         
         getVersion = getVersion & "Version " & .dwMajorVersion & "." & .dwMinorVersion & " (Build " & .dwBuildNumber & ") " & .szCSDVersion

         End With
               
      End Function

Function GetInfo(txtFileName As String, strType As Integer) As String
    Dim FSO, F
    Dim FileName As String
    
    FileName = txtFileName
    Set FSO = CreateObject("Scripting.FileSystemObject")
    Set F = FSO.GetFile(FileName)
    Select Case GetInfo
    Case 0
    GetInfo = F.DateCreated
    Case 1
    GetInfo = "Last Modified : " & F.DateLastModified
    Case 2
    GetInfo = "Last Accessed : " & F.DateLastAccessed
    Case Else
    End Select

End Function


