VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "SystemInfo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'*****INFORMATION*****
'This code has been re-written by myself into a class module for easier use
'Much of the original code was by Philipp Heltewig
'I found his code somewhere on the Internet (i forgot where). It said that this could be reused
'in other projects. So I am. I dont intend to step on anyones toes with this code, it is simply designed for ease
'of use.
'Jack Hoxley
'I would be interested in any comments to Jollyjeffers@hotmail.com
'But i will use the block sender function for any stuck up twat that thinks they own the world and
'wants to complain about this.
'My line on this is: You chose to download it and spend time looking at this, i didn't make you.

'*****USE******
'in a form declare
'Dim Bananas as new systeminfo (replace bananas with anything)
'Then (Assumes using VB5 or later) in your form type:
'Bananas. (u will then get a drop down menu of the available features)

'**************FUTURE***************
'I am hoping to create another similiar example but allowing you to change things, such as
'Computer Name
'Format Disk
'Set Windows Resolution
'Set Amount of colours

'But i am new to Class Modules (Not VB, i have 3 years exp in that)
'Any one know how to do things that dont require a return value EMail me
'Please!
'**********************************************************************************************
'Internal
Private TotPhys As Long
Private TotVirt As Long
Private TotPag As Long
Private AvPhys As Long
Private AvVirt As Long
Private AvPag As Long
'System Name
Private Declare Function GetComputerName Lib "kernel32" Alias "GetComputerNameA" (ByVal lpBuffer As String, nSize As Long) As Long
'Disk Space
Private Declare Function GetDiskFreeSpace Lib "kernel32" Alias "GetDiskFreeSpaceA" (ByVal lpRootPathName As String, lpSectorsPerCluster As Long, lpBytesPerSector As Long, lpNumberOfFreeClusters As Long, lpTtoalNumberOfClusters As Long) As Long
'Sreen Res.
#If Win16 Then
Private Declare Sub GetWindowRect Lib "User" (ByVal hwnd As Integer, lpRect As RECT)
    Private Declare Function GetDC Lib "User" (ByVal hwnd As Integer) As Integer
    Private Declare Function ReleaseDC Lib "User" (ByVal hwnd As Integer, ByVal hdc As Integer) As Integer
    Private Declare Sub SetBkColor Lib "GDI" (ByVal hdc As Integer, ByVal crColor As Long)
    Private Declare Sub Rectangle Lib "GDI" (ByVal hdc As Integer, ByVal X1 As Integer, ByVal Y1 As Integer, ByVal X2 As Integer, ByVal Y2 As Integer)
    Private Declare Function CreateSolidBrush Lib "GDI" (ByVal crColor As Long) As Integer
    Private Declare Function SelectObject Lib "GDI" (ByVal hdc As Integer, ByVal hObject As Integer) As Integer
    Private Declare Sub DeleteObject Lib "GDI" (ByVal hObject As Integer)
#Else
Private Declare Function GetWindowRect Lib "User32" (ByVal hwnd As Long, lpRect As RECT) As Long
    Private Declare Function GetDC Lib "User32" (ByVal hwnd As Long) As Long
    Private Declare Function ReleaseDC Lib "User32" (ByVal hwnd As Long, ByVal hdc As Long) As Long
    Private Declare Function SetBkColor Lib "gdi32" (ByVal hdc As Long, ByVal crColor As Long) As Long
    Private Declare Function Rectangle Lib "gdi32" (ByVal hdc As Long, ByVal X1 As Long, ByVal Y1 As Long, ByVal X2 As Long, ByVal Y2 As Long) As Long
    Private Declare Function CreateSolidBrush Lib "gdi32" (ByVal crColor As Long) As Long
    Private Declare Function SelectObject Lib "User32" (ByVal hdc As Long, ByVal hObject As Long) As Long
    Private Declare Function DeleteObject Lib "gdi32" (ByVal hObject As Long) As Long
Private Const BITSPIXEL = 12
Private Const HORZRES = 8
Private Const VERTRES = 10
Private Const PLANES = 14
Private hdesktopwnd
Private hdccaps
#If Win16 Then
    Private Type RECT
        Left As Integer
        Top As Integer
        Right As Integer
        Bottom As Integer
    End Type
#Else
    Private Type RECT
        Left As Long
        Top As Long
        Right As Long
        Bottom As Long
    End Type
'*** Check System Version Function
Private Declare Function GetVersionX Lib "kernel32" Alias "GetVersionExA" (lpVersionInformation As OSVERSIONINFO) As Long
Private Type OSVERSIONINFO
    dwOSVersionInfoSize As Long
    dwMajorVersion As Long
    dwMinorVersion As Long
    dwBuildNumber As Long
    dwPlatformID As Long
    szCSDVersion As String * 128
End Type
Dim OSInfo As OSVERSIONINFO
'*** Display Res. Functions
Private Declare Function GetDesktopWindow Lib "User32" () As Long
Private Declare Function GetDeviceCaps Lib "gdi32" (ByVal hdc As Long, ByVal nIndex As Long) As Long
'Memorystatus
Option Explicit
Private Declare Sub GlobalMemoryStatus Lib "kernel32" (lpBuffer As MEMORYSTATUS)
Private Type MEMORYSTATUS
    dwLength As Long 'Gesamtlänge der Struktur
    dwMemoryLoad As Long 'belegter Speicher
    dwTotalPhys As Long 'Gesamt RAM
    dwAvailPhys As Long 'Verfügbarer RAM
    dwTotalPageFile As Long 'Auslagerungsdatei
    dwAvailPageFile As Long 'Verf. Arbeitsspeicher
    dwTotalVirtual As Long 'virt. Speicher
    dwAvailVirtual As Long 'verf. virt. Speicher
End Type
Dim lpInfoBuffer As MEMORYSTATUS
#End If 'dont know why these are here, but it dont work otherwise
#End If
Public Function GetHdiskSpace(DrivePath As String, RoundtoMB As Boolean) As Double
  Dim Drive As String
  Dim SectorsPerCluster As Long, BytesPerSector As Long
  Dim NumberOfFreeClusters As Long, TotalClusters As Long, Sts As Long
  Dim DS
  Drive = Left(Trim(DrivePath), 1) & ":\"     ' Ensure path is at the root.
  Sts = GetDiskFreeSpace(Drive, SectorsPerCluster, BytesPerSector, NumberOfFreeClusters, TotalClusters)
  If Sts <> 0 Then
    GetHdiskSpace = SectorsPerCluster * BytesPerSector * NumberOfFreeClusters
    DS = Format$(GetHdiskSpace, "###,###")
    If RoundtoMB = True Then
    GetHdiskSpace = DS / 1024 / 1024
    End If
  Else
    GetHdiskSpace = -1
  End If
End Function


Public Function GetWinComputerName() As String
  Dim sBuffer As String
  Dim lBufSize As Long
  Dim lStatus As Long
  lBufSize = 255
  sBuffer = String$(lBufSize, " ")
  lStatus = GetComputerName(sBuffer, lBufSize)
  GetWinComputerName = ""
  If lStatus <> 0 Then
     GetWinComputerName = Left(sBuffer, lBufSize)
  End If
  'frmSys.lblName = sGetComputerName
End Function
Public Function GetWinDisplayColors(RETURNx As String) As String
     RETURNx = UCase(RETURNx)
     Dim DisplayBits
    Dim DisplayPlanes
    Dim DisplayWidth
    Dim DisplayHeight
    Dim RetVal
    hdccaps = GetDC(hdesktopwnd)
    DisplayBits = GetDeviceCaps(hdccaps, 12)
    DisplayPlanes = GetDeviceCaps(hdccaps, 14)
    DisplayWidth = GetDeviceCaps(hdccaps, 8)
    DisplayHeight = GetDeviceCaps(hdccaps, 10)
    RetVal = ReleaseDC(hdesktopwnd, hdccaps)
Select Case RETURNx
        Case "CLS_BITS"
                    If DisplayBits = 1 Then
                    If DisplayPlanes = 1 Then
                        GetWinDisplayColors = "1 Bit"
                        ElseIf DisplayPlanes = 4 Then
                        GetWinDisplayColors = "4 Bit"
                    End If
                    ElseIf DisplayBits = 8 Then
                        GetWinDisplayColors = "8 Bit"
                    ElseIf DisplayBits = 16 Then
                    GetWinDisplayColors = "16 Bit"
                    Else
                        GetWinDisplayColors = "24 / 32 Bit"
                    End If
        Case "CLS_COL"
                    If DisplayBits = 1 Then
                    If DisplayPlanes = 1 Then
                        GetWinDisplayColors = "2"
                        ElseIf DisplayPlanes = 4 Then
                        GetWinDisplayColors = "16"
                    End If
                    ElseIf DisplayBits = 8 Then
                        GetWinDisplayColors = "256"
                    ElseIf DisplayBits = 16 Then
                    GetWinDisplayColors = "65000"
                    Else
                        GetWinDisplayColors = "16000000"
                    End If
        Case Else
End Select
End Function
Public Function GetWinVersion() As String
Dim RetVal As Long
RetVal = GetVersionX(OSInfo)
OSInfo.dwOSVersionInfoSize = 148
OSInfo.szCSDVersion = Space(128)
RetVal = GetVersionX(OSInfo)
GetWinVersion = OSInfo.dwMajorVersion & "." & OSInfo.dwMinorVersion
End Function
Public Function GetWinResX() As Integer
GetWinResX = Screen.Width / Screen.TwipsPerPixelX
End Function
Public Function GetWinResY() As Integer
GetWinResY = Screen.Height / Screen.TwipsPerPixelY
End Function
Public Function GetWinResXY() As String
GetWinResXY = Screen.Width / Screen.TwipsPerPixelX & " x " & Screen.Height / Screen.TwipsPerPixelY
End Function
Public Function GetPhysMemTotal() As Long
lpInfoBuffer.dwLength = Len(lpInfoBuffer)
GlobalMemoryStatus lpInfoBuffer
GetPhysMemTotal = lpInfoBuffer.dwTotalPhys '/ 1024 & " KByte"
TotPhys = lpInfoBuffer.dwTotalPhys / 1024
End Function
Public Function GetVirtMemTotal() As Long
lpInfoBuffer.dwLength = Len(lpInfoBuffer)
GlobalMemoryStatus lpInfoBuffer
GetVirtMemTotal = lpInfoBuffer.dwTotalVirtual '/ 1024 & " KByte"
TotVirt = lpInfoBuffer.dwTotalVirtual / 1024
End Function
Public Function GetPageFileMemTotal() As Long
lpInfoBuffer.dwLength = Len(lpInfoBuffer)
GlobalMemoryStatus lpInfoBuffer
GetPageFileMemTotal = lpInfoBuffer.dwTotalPageFile ' / 1024 & " KByte"
TotPag = lpInfoBuffer.dwTotalPageFile / 1024
End Function
Public Function GetPhysMemAvailable() As Long
lpInfoBuffer.dwLength = Len(lpInfoBuffer)
GlobalMemoryStatus lpInfoBuffer
GetPhysMemAvailable = lpInfoBuffer.dwAvailPhys ' / 1024 & " KByte"
AvPhys = lpInfoBuffer.dwAvailPhys '/ 1024
End Function
Public Function GetVirtMemAvailable() As Long
lpInfoBuffer.dwLength = Len(lpInfoBuffer)
GlobalMemoryStatus lpInfoBuffer
GetVirtMemAvailable = lpInfoBuffer.dwAvailVirtual ' / 1024 & " KByte"
AvVirt = lpInfoBuffer.dwAvailVirtual / 1024
End Function
Public Function GetPageFileMemAvailable() As Long
lpInfoBuffer.dwLength = Len(lpInfoBuffer)
GlobalMemoryStatus lpInfoBuffer
GetPageFileMemAvailable = lpInfoBuffer.dwAvailPageFile '/ 1024 & " KByte"
AvPag = lpInfoBuffer.dwAvailPageFile / 1024
End Function
Public Function GetPhysMemLoad() As Long
GetPhysMemLoad = AvPhys / TotPhys
End Function

Public Function GetVirtMemLoad() As Long
GetVirtMemLoad = AvVirt / TotVirt
End Function
Public Function GetPageFileMemLoad() As Long
GetPageFileMemLoad = AvPag / TotPag
End Function
Public Function GetMemLoad() As Integer
lpInfoBuffer.dwLength = Len(lpInfoBuffer)
GlobalMemoryStatus lpInfoBuffer
GetMemLoad = lpInfoBuffer.dwMemoryLoad '& "%"
End Function
