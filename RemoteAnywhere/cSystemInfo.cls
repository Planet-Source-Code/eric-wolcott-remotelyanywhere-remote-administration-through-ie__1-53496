VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cSystemInfo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
DefInt A-Z

'*****************************************************
' Class:    cSysInfo
'
' Purpose:  To provide system information for the following
'           properties:
'           OS Version, CPU, IE Version, Free Memory,
'           Total Memory, Free Virtual Memory,
'           Total Virutal Memory
'
' Author:   Brett Raven : treedevil@hotmail.com
'
' Date Rev.:17/12/2001
'*****************************************************

Private Type SYSTEM_INFO
    dwOemID                     As Long
    dwPageSize                  As Long
    lpMinimumApplicationAddress As Long
    lpMaximumApplicationAddress As Long
    dwActiveProcessorMask       As Long
    dwNumberOrfProcessors       As Long
    dwProcessorType             As Long
    dwAllocationGranularity     As Long
    dwReserved                  As Long
End Type

Private Type OSVERSIONINFO
    dwOSVersionInfoSize As Long
    dwMajorVersion      As Long
    dwMinorVersion      As Long
    dwBuildNumber       As Long
    dwPlatformID        As Long
    szCSDVersion        As String * 128
End Type

Private Type MEMORYSTATUS
    dwLength            As Long
    dwMemoryLoad        As Long
    dwTotalPhys         As Long
    dwAvailPhys         As Long
    dwTotalPageFile     As Long
    dwAvailPageFile     As Long
    dwTotalVirtual      As Long
    dwAvailVirtual      As Long
End Type

Private Type DllVersionInfo
   cbSize As Long
   dwMajorVersion   As Long
   dwMinorVersion   As Long
   dwBuildNumber    As Long
   dwPlatformID     As Long
End Type


'**CONSTANTS
Private Const EM_UNDO                    As Long = &HC7
Private Const PROCESSOR_INTEL_386        As Integer = 386
Private Const PROCESSOR_INTEL_486        As Integer = 486
Private Const PROCESSOR_INTEL_PENTIUM    As Integer = 586
Private Const PROCESSOR_MIPS_R4000       As Integer = 4000
Private Const PROCESSOR_ALPHA_21064      As Integer = 21064
Private Const ENTERPRISE_TYPE_LIVESTOCK  As Long = 1
Private Const ENTERPRISE_TYPE_CROP       As Long = 2


' Private declarations
Private Declare Function GetVersionEx Lib "KERNEL32" Alias "GetVersionExA" _
                          (LpVersionInformation As OSVERSIONINFO) As Long
Private Declare Sub GlobalMemoryStatus Lib "KERNEL32" (lpBuffer As _
                         MEMORYSTATUS)
Private Declare Sub GetSystemInfo Lib "KERNEL32" (lpSystemInfo As _
                         SYSTEM_INFO)
Private Declare Function DllGetVersion Lib "Shlwapi.dll" (dwVersion As DllVersionInfo) As Long
                  
' Local variable(s) to hold property value(s)
Private mvarWinVersion          As String 'local copy
Private mvarWinName             As String 'local copy
Private mvarCPUVersion          As String 'local copy
Private mvarMemoryTotal         As Long 'local copy
Private mvarMemoryFree          As Long 'local copy
Private mvarVirtualMemoryTotal  As Long 'local copy
Private mvarVirtualMemoryFree   As Variant 'local copy
Private mvarIEVersion           As String 'local copy



Public Property Get VirtualMemoryFree() As Long
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.VirtualMemoryFree
    VirtualMemoryFree = mvarVirtualMemoryFree
End Property

Public Property Get VirtualMemoryTotal() As Long
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.VirtualMemoryTotal
    VirtualMemoryTotal = mvarVirtualMemoryTotal
End Property


Public Property Get MemoryFree() As Long
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.MemoryFree
    MemoryFree = mvarMemoryFree
End Property

Public Property Get MemoryTotal() As Long
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.MemoryTotal
    MemoryTotal = mvarMemoryTotal
End Property


Public Property Get WinVersion() As String
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.WinVersion
    WinVersion = mvarWinVersion
End Property

Public Property Get WinName() As String
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.WinVersion
    WinName = mvarWinName
End Property


Public Property Get CPUVersion() As String
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.CPUVersion
    CPUVersion = mvarCPUVersion
End Property

Public Property Get IEVersion() As String
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.WinVersion
    IEVersion = mvarIEVersion
End Property

Private Function SystemInformation() As Boolean
    
    Dim strMsg          As String           ' Status information.
    Dim intRet          As Integer          ' OS Information
    Dim intVer_major    As Integer          ' OS Version
    Dim intVer_minor    As Integer          ' Minor Os Version
    Dim lngBuild        As Long             ' OS lngBuild
    Dim udtVerinfo      As OSVERSIONINFO
    Dim udtSysInfo      As SYSTEM_INFO
    Dim udtMemStatus    As MEMORYSTATUS
    Dim lngMemory       As Long
    Dim udtDVI          As DllVersionInfo
    
    
     ' Get operating system and version.
    udtVerinfo.dwOSVersionInfoSize = Len(udtVerinfo)
     intRet = GetVersionEx(udtVerinfo)
    If intRet = 0 Then
        SystemInformation = False
    End If
    
    intVer_major = udtVerinfo.dwMajorVersion
    intVer_minor = udtVerinfo.dwMinorVersion
    
    Select Case intVer_major
        Case 3
            strMsg = IIf(intVer_minor = 5, "Windows NT ", "Windows ")
        Case 4
            Select Case intVer_minor
                Case 0
                    strMsg = "Windows NT "
                Case 1
                    strMsg = "Windows 98 "
                Case Else
                    strMsg = "Windows ME "
            End Select
        Case 5
            strMsg = IIf(intVer_minor = 1, "Windows XP ", "Windows 2000 ")
        Case Else
            'unknown
            strMsg = "Windows Unknown Version"
    End Select
    
    lngBuild = udtVerinfo.dwBuildNumber
    
    'set properties
    mvarWinName = strMsg
    mvarWinVersion = intVer_major & "." & intVer_minor & " (Build " & lngBuild & ")"
    
    strMsg = ""
      
    ' Get CPU type and operating mode.
    GetSystemInfo udtSysInfo
    'strMsg = strMsg + "CPU: "
    
    Select Case udtSysInfo.dwProcessorType
        Case PROCESSOR_INTEL_386
            strMsg = strMsg + "Intel 386"
        Case PROCESSOR_INTEL_486
            strMsg = strMsg + "Intel 486"
        Case PROCESSOR_INTEL_PENTIUM
            strMsg = strMsg + "Intel Pentium"
        Case PROCESSOR_MIPS_R4000
            strMsg = strMsg + "MIPS R4000"
        Case PROCESSOR_ALPHA_21064
            strMsg = strMsg + "DEC Alpha 21064"
        Case Else
            strMsg = strMsg + "(unknown)"
    End Select
    
    'set property
    mvarCPUVersion = strMsg
    
    ' Get free lngMemory.
    GlobalMemoryStatus udtMemStatus
    mvarMemoryTotal = udtMemStatus.dwTotalPhys / 1024
    mvarMemoryFree = udtMemStatus.dwAvailPhys / 1024
    mvarVirtualMemoryTotal = udtMemStatus.dwTotalVirtual / 1024
    mvarVirtualMemoryFree = udtMemStatus.dwAvailVirtual / 1024
    
    
    'IE Version
    udtDVI.cbSize = Len(udtDVI)
    DllGetVersion udtDVI
    mvarIEVersion = "Internet Explorer " & udtDVI.dwMajorVersion & "." & _
                  udtDVI.dwMinorVersion & "." & _
                  udtDVI.dwBuildNumber
    
    
End Function



Private Sub Class_Initialize()


        SystemInformation
        
End Sub





