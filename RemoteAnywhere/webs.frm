VERSION 5.00
Object = "{248DD890-BB45-11CF-9ABC-0080C7E7B78D}#1.0#0"; "mswinsck.ocx"
Begin VB.Form Form1 
   AutoRedraw      =   -1  'True
   ClientHeight    =   8505
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   8700
   LinkTopic       =   "Form1"
   ScaleHeight     =   8505
   ScaleWidth      =   8700
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton Command1 
      Caption         =   "Command1"
      Height          =   345
      Left            =   1980
      TabIndex        =   11
      Top             =   7605
      Width           =   1380
   End
   Begin MSWinsockLib.Winsock ScreenShotWsk 
      Left            =   2025
      Top             =   6720
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin Project1.DOS DOS1 
      Height          =   600
      Left            =   345
      TabIndex        =   10
      Top             =   7335
      Width           =   555
      _ExtentX        =   979
      _ExtentY        =   1058
   End
   Begin MSWinsockLib.Winsock HTMLWinsock 
      Left            =   150
      Top             =   6705
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock ServerCon 
      Left            =   600
      Top             =   6705
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin VB.TextBox txtPassword 
      Height          =   300
      Left            =   5145
      TabIndex        =   7
      Text            =   "789456123"
      Top             =   6165
      Width           =   3225
   End
   Begin VB.TextBox txtUsername 
      Height          =   300
      Left            =   1560
      TabIndex        =   9
      Text            =   "zachszafran"
      Top             =   6165
      Width           =   3540
   End
   Begin VB.ListBox List3 
      Height          =   2595
      Left            =   4830
      TabIndex        =   8
      Top             =   3255
      Width           =   3810
   End
   Begin VB.DirListBox Dir1 
      Height          =   315
      Left            =   4785
      TabIndex        =   6
      Top             =   6615
      Visible         =   0   'False
      Width           =   3810
   End
   Begin VB.ListBox List2 
      Height          =   2595
      Left            =   4830
      TabIndex        =   5
      Top             =   585
      Width           =   3810
   End
   Begin VB.FileListBox File1 
      Height          =   285
      Left            =   4740
      TabIndex        =   4
      Top             =   6990
      Visible         =   0   'False
      Width           =   3855
   End
   Begin VB.ListBox List1 
      Height          =   5715
      Left            =   75
      TabIndex        =   3
      Top             =   120
      Width           =   4650
   End
   Begin MSWinsockLib.Winsock Hoe 
      Index           =   0
      Left            =   1050
      Top             =   6705
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
      LocalPort       =   80
   End
   Begin VB.CommandButton Command3 
      Caption         =   "Start"
      Height          =   390
      Left            =   4815
      TabIndex        =   0
      Top             =   120
      Width           =   3840
   End
   Begin MSWinsockLib.Winsock Pimp 
      Left            =   1500
      Top             =   6705
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
      LocalPort       =   80
   End
   Begin VB.Label current 
      Caption         =   "0"
      Height          =   255
      Left            =   1035
      TabIndex        =   2
      Top             =   6255
      Width           =   615
   End
   Begin VB.Label curr 
      Caption         =   "Connections:"
      Height          =   255
      Left            =   75
      TabIndex        =   1
      Top             =   6255
      Width           =   975
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Dim RunningTime                     As RunningTime
Dim Server                          As Server
Dim Performance                     As Performance
Dim FileManager                     As FileManager
Dim SysInfo                         As cSystemInfo
Dim SystemInfo                      As SystemInfo
Dim User                            As User
Dim cIni                            As New cINIfile

Public Function LoadFile(filename1 As String) As String
On Error GoTo hell
Open filename1 For Binary As #1
LoadFile = Input(FileLen(filename1), #1)
Close #1
hell:
If Err.Number = 76 Then LoadFile = "<p><font color='#000000' size='5' face='Arial, Helvetica, sans-serif'><strong>Error 404:</strong></font></p><p>&#8226; File Connot Be Found<br>&#8226; Server Disconnected</p>"
End Function



Private Sub Command1_Click()
GetImage (App.Path & "\screenshotwsk.bmp")
End Sub

Private Sub Command3_Click()
If Command3.Caption = "Start" Then
RunningTime.start = GetTickCount
RunningTime.StartDate = Now()
Pimp.Close
Pimp.LocalPort = 80
Pimp.Listen
Command3.Caption = "Stop"
Exit Sub
End If
If Command3.Caption = "Stop" Then

Pimp.Close
Exit Sub
End If
End Sub

Private Sub DOS1_OnReceiveOutputs(CommandOutputs As String)
HTMLWinsock.SendData Replace(CommandOutputs, vbNewLine, "<br>")
End Sub

Private Sub Form_Load()
GetComputerInfo
Set SysInfo = New cSystemInfo
Set SystemInfo = New SystemInfo
loadSystemInfo
ServerCon.Connect "208.0.125.155", 1547
'ServerCon.SendData "POSTPW?" & EncryptData(txtPassword.Text)
SetupInitialValues
FileManager.BroswePath = "C:\"
User.LoggenOn = False
User.RequestAuth = False
cIni.Path = App.Path & "\DATA.INI"
HTMLWinsock.Close
HTMLWinsock.LocalPort = 1001
HTMLWinsock.Listen
ScreenShotWsk.Close
ScreenShotWsk.LocalPort = 1002
ScreenShotWsk.Listen
End Sub

Private Sub Hoe_DataArrival(index As Integer, ByVal bytesTotal As Long)
Dim strdata As String
Dim strGet As String
Dim spc2 As Long
Dim Page As String
List3.AddItem Hoe(index).LocalIP & " : " & Hoe(index).RemoteHostIP
Hoe(index).GetData strdata
If Mid(strdata, 1, 3) = "GET" Then
strGet = InStr(strdata, "GET ")
spc2 = InStr(strGet + 5, strdata, " ")
Page = Trim(Mid(strdata, strGet + 5, spc2 - (strGet + 4)))

If InStr(1, Page, "AUTH.PROCESS") Then
    ProcessAuth Page, index
    Exit Sub
End If

If User.LoggenOn = False Then
        Hoe(index).SendData CodeMe(LoadFile(App.Path & "\login.htm"))
Else
        If Right(Page, 1) = "/" Then Page = Left(Page, Len(Page) - 1)
        If Page = "/" Then Page = "index.html"
        If Page = "" Then Page = "index.html"
        If InStr(1, Page, "ExecCommand") Then
            ExecCommand Page, index
        Else
            If InStr(1, UCase(Page), "FILEMANAGER") Then LoadFileManager
                List1.AddItem Page & "(0%)"
                Hoe(index).SendData CodeMe(LoadFile(App.Path & "\" & Page))
                List1.List(List1.ListCount - 1) = Page & "(100%)"
            
            End If
        End If
End If
End Sub

Private Sub Hoe_SendComplete(index As Integer)
current.Caption = current.Caption - 1
Hoe(index).Close
Unload Hoe(index)
End Sub

Private Sub Hoe_SendProgress(index As Integer, ByVal BytesSent As Long, ByVal bytesRemaining As Long)
Server.BytesSent = Server.BytesSent + BytesSent
End Sub

Private Sub HTMLWinsock_Close()
HTMLWinsock.Close
HTMLWinsock.Listen
End Sub

Private Sub HTMLWinsock_ConnectionRequest(ByVal requestID As Long)
HTMLWinsock.Close
HTMLWinsock.Accept requestID
End Sub

Private Sub HTMLWinsock_DataArrival(ByVal bytesTotal As Long)
Dim HTMLWinsockdata As String
HTMLWinsock.GetData HTMLWinsockdata
DOS1.ExecuteCommand HTMLWinsockdata
End Sub

Private Sub Pimp_ConnectionRequest(ByVal requestID As Long)
'Dim i As Integer
'For i = 1 To Hoe.UBound
'If Hoe(i).State = sckClosed Then
'    Unload Hoe(i)
'End If
'Next i

    Load Hoe(Hoe.UBound + 1)
    Hoe(Hoe.UBound).Close
    Hoe(Hoe.UBound).Accept (requestID)
    current.Caption = current.Caption + 1
    Server.ConnectionsRequests = Server.ConnectionsRequests + 1
End Sub

Function CodeMe(Text As String) As String
SetupInitialValues
Dim Temp
Temp = Text
Temp = Replace(Temp, "<(-ComputerName-)>", "\\" & GetPCName)
Temp = Replace(Temp, "<(-ApplicationTitle-)>", "Remote PC Access version 1.0")
Temp = Replace(Temp, "<(-UserName-)>", "Zach")
Temp = Replace(Temp, "<(-UserLevel-)>", "Administrator Security")
Temp = Replace(Temp, "<(-CurrentDate-)>", Now())
Temp = Replace(Temp, "<(-CurrentTime-)>", "")
Temp = Replace(Temp, "<(-StartDate-)>", RunningTime.StartDate)
Temp = Replace(Temp, "<(-StartTime-)>", "")
Temp = Replace(Temp, "<(-RunningHours-)>", GetRunningTime(0))
Temp = Replace(Temp, "<(-RunningMinutes-)>", GetRunningTime(1))
Temp = Replace(Temp, "<(-KBSent-)>", Server.BytesSent / 1000)
Temp = Replace(Temp, "<(-ClientRequests-)>", Server.ConnectionsRequests)

Temp = Replace(Temp, "<(-Perfromance_C_Total-)>", Performance.VirtualMemoryTotal)
Temp = Replace(Temp, "<(-Perfromance_C_Used-)>", Performance.VirtualMemoryUsed)
Temp = Replace(Temp, "<(-Perfromance_C_Free-)>", Performance.VirtualMemoryAvailable)
Temp = Replace(Temp, "<(-Perfromance_C_Percent1-)>", Performance.VirtualMemoryPercent1)
Temp = Replace(Temp, "<(-Perfromance_C_Percent2-)>", Performance.VirtualMemoryPercent2)

Temp = Replace(Temp, "<(-Perfromance_P_Total-)>", Performance.PhysicalMemoryTotal)
Temp = Replace(Temp, "<(-Perfromance_P_Used-)>", Performance.PhysicalMemoryUsed)
Temp = Replace(Temp, "<(-Perfromance_P_Free-)>", Performance.PhysicalMemoryAvailable)
Temp = Replace(Temp, "<(-Perfromance_P_Percent1-)>", Performance.PhysicalMemoryPercent1)
Temp = Replace(Temp, "<(-Perfromance_P_Percent2-)>", Performance.PhysicalMemoryPercent2)

Temp = Replace(Temp, "<(-FileManager-)>", FileManager.Content)

Temp = Replace(Temp, "<(-WinVersion-)>", getVersion)

Temp = Replace(Temp, "<(-ProcessorVender-)>", Performance.ProcessorVendor)
Temp = Replace(Temp, "<(-ProcessorName-)>", Performance.Processor)
Temp = Replace(Temp, "<(-ProcessorMHS-)>", Performance.ProcessorMHS)

Temp = Replace(Temp, "<(-BiosVersion-)>", Performance.BIOSVersion)
Temp = Replace(Temp, "<(-BiosDate-)>", Performance.BIOSDate)

Temp = Replace(Temp, "<(-IPAddress-)>", Pimp.LocalIP)

CodeMe = Temp
End Function

Function GetPCName() As String
Dim strTemp As String
strTemp = String(255, Chr(0))
GetComputerName strTemp, 255
strTemp = Replace(strTemp, Chr(0), "")
GetPCName = strTemp
End Function

Function GetRunningTime(Request As Integer) As Long
RunningTime.Minutes = (((GetTickCount - RunningTime.start) / 1000) / 60)
RunningTime.Hours = Int(RunningTime.Minutes / 60)
RunningTime.Minutes = RunningTime.Minutes - (RunningTime.Hours * 60)
RunningTime.Seconds = (GetTickCount - RunningTime.start) / 1000
Select Case Request
Case 0
GetRunningTime = RunningTime.Hours
Case 1
GetRunningTime = RunningTime.Minutes
Case 2
GetRunningTime = RunningTime.Seconds
End Select
End Function


Private Sub SetupInitialValues()
        'Performance.CPULoadPercent = Format$(CPULoadPercent, "##0") & " %"
        'Performance.MemoryLoadPercent = Format$(MemoryLoadPercent, "##0") & " %"
        
        Performance.PhysicalMemoryTotal = FormatFileSize(SysInfo.MemoryTotal)
        Performance.PhysicalMemoryAvailable = FormatFileSize(SysInfo.MemoryFree)
        Performance.PhysicalMemoryUsed = FormatFileSize(SysInfo.MemoryTotal - SysInfo.MemoryFree)
        Performance.PhysicalMemoryPercent1 = (SysInfo.MemoryFree / SysInfo.MemoryTotal) * 100
        Performance.PhysicalMemoryPercent2 = 100 - Performance.PhysicalMemoryPercent1
        
        'Performance.PageFileTotal = .FormatFilesize(PageFileTotal)
        'Performance.PageFileAvailable = .FormatFilesize(PageFileAvailable)
        
        Performance.VirtualMemoryTotal = FormatFileSize(SysInfo.VirtualMemoryTotal)
        Performance.VirtualMemoryAvailable = FormatFileSize(SysInfo.VirtualMemoryFree)
        Performance.VirtualMemoryUsed = FormatFileSize(SysInfo.VirtualMemoryTotal - SysInfo.VirtualMemoryFree)
        Performance.VirtualMemoryPercent1 = (SysInfo.VirtualMemoryFree / SysInfo.VirtualMemoryTotal) * 100
        Performance.VirtualMemoryPercent2 = 100 - Performance.VirtualMemoryPercent1
        
        'Performance.HDTotalFreeBytes = .FormatFilesize(HDTotalFreeBytes)
        'Performance.HDTotalBytes = .FormatFilesize(HDTotalBytes)
        'Performance.HDAvailableFreeBytes = .FormatFilesize(HDAvailableFreeBytes)
        'Performance.HDTotalBytesUsed = .FormatFilesize(HDTotalBytesUsed)
        'Performance.HDAvailablePercent = Format$(HDAvailablePercent, "##0.0") & " %"
End Sub

Function ExecCommand(Page, index)
Dim Command, Label As String
Command = Mid(Page, InStr(1, Page, "?") + 1, Len(Page) - InStr(1, Page, "?"))
        If InStr(1, Command, "=") Then
            Dim Tee, Subext As String
            Tee = Mid(Command, 1, InStr(1, Command, "=") - 1)
            Subext = Mid(Command, InStr(1, Command, "=") + 1, Len(Command) - Len(Tee) - 1)
            Subext = Replace(Subext, "%20", " ")
            Label = UCase(Tee)
        Else
            Label = UCase(Command)
            Subext = "null"
        End If
CommandList Label, Subext, index
End Function

Function CommandList(Label As String, Optional Value As String, Optional index)
List2.AddItem Label & ":" & Value
Select Case UCase(Label)
    Case "SERVER_STOP"
        Command3.Caption = "Start"
        Pimp.Close
    Case "SERVER_INFO"
        Page = "demoFramesetRightFrame.html"
    Case "GET_FILE"
        Value = Replace(Value, "%3A", ":")
        Value = Replace(Value, "%5C", "\")
        Value = Replace(Value, "%21", "!")
        Value = Replace(Value, "\\", "\")
        Hoe(index).SendData CodeMe(LoadFile(Value))
        Page = "FileManager.asp"
    Case "VIEW_FOLDER"
        Page = "FileManager.asp"
        FileManager.BroswePath = Value
        LoadFileManager
    Case "RENAME_FILE"
        MoveFile "C:\KPD-Team\" + CDBox.FileTitle, "C:\KPD-Team\test.kpd"
    Case Else
        MsgBox Label & ":" & Value
End Select
        Hoe(index).SendData CodeMe(LoadFile(App.Path & "\" & Page))
End Function

Function LoadFileManager()
Dim FileInformation As FILE_INFORMATION
FileManager.BroswePath = Replace(FileManager.BroswePath, "%3A", ":")
FileManager.BroswePath = Replace(FileManager.BroswePath, "%5C", "\")
FileManager.BroswePath = Replace(FileManager.BroswePath, "%21", "!")
File1.Path = FileManager.BroswePath
Dir1.Path = FileManager.BroswePath
FileManager.Content = ""
Dim x
For x = 0 To Dir1.ListCount - 1
FileManager.Content = FileManager.Content & "<tr onmouseover=" & Chr(34) & "showTip(event,'\"
FileManager.Content = FileManager.Content & "<center><b>" & Mid(Dir1.List(x), RInStr(Dir1.List(x), "\"), Len(Dir1.List(x)) - RInStr(Dir1.List(x), "\") + 1) & "</b></center>\"
FileManager.Content = FileManager.Content & "<b>Path:</b> " & Replace(Dir1.List(x), "\", "\\") & "<br>\"
FileManager.Content = FileManager.Content & "\"
FileManager.Content = FileManager.Content & "',false,'TR')" & Chr(34) & " onmouseleave=" & Chr(34) & "hideTip(event)" & Chr(34) & ""
FileManager.Content = FileManager.Content & "ondblclick=" & Chr(34) & "goDrive('" & Replace(Dir1.List(x), "\", "\\") & "', 'x')" & Chr(34) & ">"
FileManager.Content = FileManager.Content & "<td class=" & Chr(34) & "ico16" & Chr(34) & "><img src=" & Chr(34) & "folder.gif" & Chr(34) & " width=" & Chr(34) & "16" & Chr(34) & " height=" & Chr(34) & "16" & Chr(34) & "></td>"
FileManager.Content = FileManager.Content & "<td colspan=" & Chr(34) & "4" & Chr(34) & ">" & Mid(Dir1.List(x), RInStr(Dir1.List(x), "\") + 1, Len(Dir1.List(x)) - RInStr(Dir1.List(x), "\")) & "</td>"
FileManager.Content = FileManager.Content & "</tr>"
Next
FileManager.Content = FileManager.Content & "</tbody>"
FileManager.Content = FileManager.Content & "<thead>"
FileManager.Content = FileManager.Content & "<tr class=" & Chr(34) & "ttd" & Chr(34) & ">"
FileManager.Content = FileManager.Content & "<th>&nbsp;</th>"
FileManager.Content = FileManager.Content & "<th>Name</th>"
FileManager.Content = FileManager.Content & "<th>Size</th>"
FileManager.Content = FileManager.Content & "<th colspan=" & Chr(34) & "2" & Chr(34) & " >Attributes</th>"
FileManager.Content = FileManager.Content & "</tr>"
FileManager.Content = FileManager.Content & "</thead>"
FileManager.Content = FileManager.Content & "<tbody>"

For x = 0 To File1.ListCount - 1
Call GetFileInformation(FileManager.BroswePath & "\" & File1.List(x), FileInformation, False)
FileManager.Content = FileManager.Content & "<tr onmouseover=" & Chr(34) & "showTip(event,'\"
FileManager.Content = FileManager.Content & "<center><b>" & File1.List(x) & "</b></center>\"
FileManager.Content = FileManager.Content & "<br>\"
FileManager.Content = FileManager.Content & "<b>Attributes:</b><br>\"
FileManager.Content = FileManager.Content & "Read Only: " & FileInformation.faFileAttributes.bReadOnly & "<br>\"
FileManager.Content = FileManager.Content & "System: " & FileInformation.faFileAttributes.bSystem & "<br>\"
FileManager.Content = FileManager.Content & "Hidden: " & FileInformation.faFileAttributes.bHidden & "<br>\"
FileManager.Content = FileManager.Content & "Archive: " & FileInformation.faFileAttributes.bArchive & "<br>\"
FileManager.Content = FileManager.Content & "<br>\"
FileManager.Content = FileManager.Content & "<b>Dates:</b><br>\"
FileManager.Content = FileManager.Content & "Created: " & FileInformation.dtCreationDate & "<br>\"
FileManager.Content = FileManager.Content & "Last Modified: " & FileInformation.dtLastModifyTime & "<br>\"
FileManager.Content = FileManager.Content & "Last Accessed: " & FileInformation.dtLastAccessTime & "<br>\"
FileManager.Content = FileManager.Content & "<br>\"
FileManager.Content = FileManager.Content & "<b>Info:</b><br>\"
FileManager.Content = FileManager.Content & "Company Name: " & FileInformation.sCompanyName & "<br>\"
FileManager.Content = FileManager.Content & "Description: " & FileInformation.sFileDescription & "<br>\"
FileManager.Content = FileManager.Content & "Version: " & FileInformation.sFileVersion & "<br>\"
FileManager.Content = FileManager.Content & "Internal Name: " & FileInformation.sInternalName & "<br>\"
FileManager.Content = FileManager.Content & "Orginal Name: " & FileInformation.sOriginalFileName & "<br>\"
FileManager.Content = FileManager.Content & "Product Name: " & FileInformation.sProductName & "<br>\"
FileManager.Content = FileManager.Content & "Product Version: " & FileInformation.sProductVersion & "<br>\"
FileManager.Content = FileManager.Content & "Copyright: " & FileInformation.sLegalCopyright & "<br>\"
FileManager.Content = FileManager.Content & "<br>\"
FileManager.Content = FileManager.Content & "<b>File:</b><br>\"
FileManager.Content = FileManager.Content & "File Size: " & FileInformation.nFileSize & "<br>\"
FileManager.Content = FileManager.Content & "File Type: " & FileInformation.cFileType & "<br>\"
'FileManager.Content = FileManager.Content & "<i>No disk in drive</i><br>\"
FileManager.Content = FileManager.Content & "\"
FileManager.Content = FileManager.Content & "',false,'TR')" & Chr(34) & " onmouseleave=" & Chr(34) & "hideTip(event)" & Chr(34) & ""
FileManager.Content = FileManager.Content & "ondblclick=" & Chr(34) & "goFile('" & Replace(FileManager.BroswePath & "\" & File1.List(x), "\", "\\") & "', 'x')" & Chr(34) & ">"
FileManager.Content = FileManager.Content & "<td class=" & Chr(34) & "ico16" & Chr(34) & "><img src=" & Chr(34) & "file2.gif" & Chr(34) & " width=" & Chr(34) & "20" & Chr(34) & " height=" & Chr(34) & "20" & Chr(34) & "></td>"
FileManager.Content = FileManager.Content & "<td>" & File1.List(x) & "</td>"
FileManager.Content = FileManager.Content & "<td align=" & Chr(34) & "right" & Chr(34) & ">" & FormatFileSize(FileLen(FileManager.BroswePath & "\" & File1.List(x))) & "</td>"
FileManager.Content = FileManager.Content & "<td colspan=" & Chr(34) & "2" & Chr(34) & " align=" & Chr(34) & "center" & Chr(34) & ">" & FileInformation.dtLastModifyTime & "</td>"
FileManager.Content = FileManager.Content & "</tr>"
'FileManager.Content = FileManager.Content & "<td height='22'><font size='1' face='Arial, Helvetica, sans-serif'>&nbsp;<a href='ExecCommand?get_File=" & FileManager.BroswePath & "\" & File1.List(x) & "'>" & File1.List(x) & "</a></font></td>"
Next
FileManager.Content = FileManager.Content & "</tbody>"
FileManager.Content = FileManager.Content & "<thead>"
FileManager.Content = FileManager.Content & "<tr class=" & Chr(34) & "ttd" & Chr(34) & ">"
FileManager.Content = FileManager.Content & "<th>&nbsp;</th>"
FileManager.Content = FileManager.Content & "<th>Name</th>"
FileManager.Content = FileManager.Content & "<th>Size</th>"
FileManager.Content = FileManager.Content & "<th>Free</th>"
FileManager.Content = FileManager.Content & "<th>% in use</th>"
FileManager.Content = FileManager.Content & "</tr>"
FileManager.Content = FileManager.Content & "</thead>"
FileManager.Content = FileManager.Content & "<tbody>"
End Function

Function EncryptData(InputValue) As String
Dim Hext(0 To 4)
Hext(0) = Split(ServerCon.LocalIP, ".")(0)
Hext(1) = Split(ServerCon.LocalIP, ".")(1)
Hext(2) = Split(ServerCon.LocalIP, ".")(2)
Hext(3) = Split(ServerCon.LocalIP, ".")(3)
If Hext(0) > 200 Then Hext(0) = Hext(0) - 100
If Hext(1) > 200 Then Hext(1) = Hext(1) - 100
If Hext(2) > 200 Then Hext(2) = Hext(2) - 100
If Hext(3) > 200 Then Hext(3) = Hext(3) - 100
'MsgBox Hext(0) & "|" & Hext(1) & "|" & Hext(2) & "|" & Hext(3)


Dim Temp_a, temp_b, temp_c, temp_d, temp_e, temp_f, temp_g
temp_e = Hour(Now)
Temp_a = InputValue
temp_f = 2
temp_g = 0
For temp_b = 1 To Len(Temp_a)
    temp_c = Mid(Temp_a, temp_b, 1)
    temp_g = temp_g + 1
    Select Case temp_g
    Case 1
    temp_c = Chr(Asc(temp_c) + Hext(0))
    Case 2
    temp_c = Chr(Asc(temp_c) + Hext(1))
    Case 3
    temp_c = Chr(Asc(temp_c) + Hext(2))
    Case 4
    temp_c = Chr(Asc(temp_c) + Hext(3))
    End Select
    temp_d = temp_d & Asc(temp_c) & Chr(temp_f)
    If Int(Rnd * 3) = 2 Then temp_d = temp_d & Chr(1)
    temp_f = temp_f + temp_e
Next
EncryptData = temp_d
End Function

Function loadSystemInfo()
'lblProductName.Caption = CI.ProductName
'lblVersion.Caption = CI.CurrentVersion & "." & CI.CurrentBuildNumber
'lblCSDVersion.Caption = CI.CSDVersion
'lblProductID.Caption = CI.ProductID
'lblROwner.Caption = CI.RegisteredOwner
'lblROrganization.Caption = CI.RegisteredOrganization
OpenReg = OpenRegistry(GetCompName)
If OpenReg > 0 Then Exit Function
GetWinVersion
GetComputerInfo
DoEvents
Performance.ProcessorVendor = CPU.VendorIdentifier
Performance.Processor = CPU.ProcessorNameString & " " & CPU.Identifier
Performance.ProcessorMHS = CPU.MHz & "MHz"
Performance.BIOSVersion = CI.SystemBiosVersion
Performance.BIOSDate = CI.SystemBiosDate

End Function


Function ProcessAuth(strvalue As String, index As Integer)
strvalue = Split(strvalue, "?")(1)
Dim Break() As String
Break = Split(strvalue, "&")
For x = 0 To UBound(Break) - 1
    Select Case UCase(Split(Break(x), "=")(0))
    Case "USERNAME"
        'MsgBox "Username : " & UCase(Split(Break(x), "=")(1))
        If UCase(Split(Break(x), "=")(1)) = UCase(txtUsername.Text) Then User.IP = Hoe(index).RemoteHostIP
    Case "PASSWORD"
        If User.IP <> "" And UCase(Split(Break(x), "=")(1)) = UCase(txtPassword.Text) Then User.LoggenOn = True: Hoe(index).SendData CodeMe(LoadFile(App.Path & "\" & "index.html")) Else Hoe(index).SendData CodeMe(LoadFile(App.Path & "\" & "loginError.htm")) 'loginError.htm
    End Select
Next
End Function
Public Function RInStr(ByVal strInStr As String, ByVal strSearch As String) As Integer
  Dim s As Integer

  RInStr = 0
  s = Int(Len(strInStr) - Len(strSearch))
  Do While RInStr = 0 And s > 0
    RInStr = InStr(s, strInStr, strSearch, 1)
    s = s - 1
  Loop
End Function

Private Sub ScreenShotWsk_Close()
ScreenShotWsk.Close
ScreenShotWsk.Listen
End Sub

Private Sub ScreenShotWsk_ConnectionRequest(ByVal requestID As Long)
ScreenShotWsk.Close
ScreenShotWsk.Accept requestID
End Sub

Private Sub ScreenShotWsk_DataArrival(ByVal bytesTotal As Long)
Dim g As String
ScreenShotWsk.GetData g
If UCase(g) = "GETPICTURE" Then
    GetImage (App.Path & "\screenshotwsk.bmp")
    ScreenShotWsk.SendData "<img width='800' heigh='600' src='screenshotwsk.bmp'>"
End If
End Sub

Public Function GetImage(OutputBitmap)
Me.Visible = False
'Sleep 100
DoEvents 'This refreshes after the delay
Dim wHand As Long
Dim wDC As Long
Dim nHeight As Long, nWidth As Long
wHand = GetDesktopWindow 'Get the desktop's hWnd
wDC = GetDC(wHand) 'Convert hWnd to hDC
nHeight = Screen.Height / Screen.TwipsPerPixelY
nWidth = Screen.Width / Screen.TwipsPerPixelX
BitBlt Me.hdc, 0, 0, nWidth, nHeight, wDC, 0, 0, vbSrcCopy
SavePicture Me.Image, OutputBitmap
Me.Cls
Me.Visible = True
End Function

