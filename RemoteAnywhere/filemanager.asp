 <html> 
<head>
<title><(-ComputerName-)> - RemotelyAnywhere</title>
  <script type="text/javascript" src="file.js">  </script> 
   <link type="text/css" rel="stylesheet" href="file.css" /> 
    <script language="JavaScript">

function goDrive(name, size) {
if (size == '') {
alert('No disk in drive');
} else {
document.body.style.filter = 'progid:DXImageTransform.Microsoft.Fade(Percent=40,Duration=0.2)';
window.location='ExecCommand?VIEW_FOLDER=' + escape(name);
}
}

function goFile(name, size) {
if (size == '') {
alert('No disk in drive');
} else {
document.body.style.filter = 'progid:DXImageTransform.Microsoft.Fade(Percent=40,Duration=0.2)';
window.location='ExecCommand?get_File=' + escape(name);
}
}
</script> <script language="JavaScript">
	function dirTree(dir, fn) {
		
		if (typeof(fn) == "undefined") {
			fn = dir;
			dir = eval(fn);
		}
		var win = null;
		var opt = null;
		var url = "dirtree.html?dir=" + escape(dir) + "&fn=" + escape(fn) + "&rnd=" + Math.random();
		var w = 300;
		var h = 500;
		if (window.showModelessDialog) {
			opt = "help:0;resizable:1;dialogWidth:"+w+"px;dialogHeight:"+h+"px";
			win = window.showModelessDialog(url,"",opt);
		} else {
			opt = "width="+w+",height="+h+",resizable=1,scrollbars=1";
			win = window.open(url,"",opt);
		}
		win.opener = self;
		
	}
</script> </head> <body> 
<div left="0" class="window"> 
  <div class="titleBar"><img src="menu_openfolder.png" align="absmiddle">&nbsp;File 
    Manager</div> 
   <div class="buttonBar"> 
    <div class="buttonGroup"> <img src="ico_favourite.gif" width="22" height="22" border="0" title="Add this page to your QuickLinks"> 
      <img src="ico_refresh.gif" width="22" height="22" border="0" title="Refresh"> 
    </div>
  </div>
  <div class="dataArea"> 
    <table id="dlist" class="inner" onselectstart="return false">
      <thead>
        <tr> 
          <th colspan=5><(-ComputerName-)></th>
        </tr>
      </thead>
      <thead>
        <tr class="ttd"> 
          <th>&nbsp;</th>
          <th colspan="4">Name</th>
        </tr>
      </thead>
      <tbody>
	  <(-FileManager-)>

		
		

        <tr onmouseover="showTip(event,'\
<center><b>C:\\</b></center>\
\
\
<b>Volume Serial Number:</b> 641794A0<br>\
<b>File System:</b> NTFS<br>\
<b>Attributes:</b><br>\
- Maximum file name length is 255 characters<br>\
- Case is preserved<br>\
- Case sensitive<br>\
- Supports Unicode<br>\
- Persistent ACLs<br>\
- Supports file compression<br>\
\
- Supports encryption<br>\
- Supports object IDs<br>\
- Supports reparse points<br>\
- Supports sparse files<br>\
- Supports quotas<br>\
\
<b>Permissions:</b><br>\
- Read (R)<br>\
- Write (W)<br>\
- Execute (X)<br>\
- Delete (D)<br>\
- Change Permissions (P)<br>\
- Take Ownership (O)<br>\
\
\
',false,'TR')" onmouseleave="hideTip(event)"
ondblclick="goDrive('C:\\', '20012072960')"> 
          <td class="ico16"><img src="file2.gif" width="20" height="20"></td>
          <td>C:\</td>
          <td class="num">19,085.00 MB</td>
          <td class="num">6,360.59 MB</td>
          <td><img src="" title="67%" width="102" height="12" align="absmiddle">&nbsp;67%</td>
        </tr>
        <tr onmouseover="showTip(event,'\
<center><b>D:\\</b></center>\
\
<b>Volume Name:</b> My Disc<br>\
<b>Volume Serial Number:</b> CFC9DCBF<br>\
<b>File System:</b> CDFS<br>\
<b>Attributes:</b><br>\
- Maximum file name length is 110 characters<br>\
\
- Case sensitive<br>\
- Supports Unicode<br>\
\
\
\
\
\
\
\
\
\
\
\
',false,'TR')" onmouseleave="hideTip(event)"
ondblclick="goDrive('D:\\', '72851456')"> 
          <td class="ico16"><img src="file2.gif" width="20" height="20"></td>
          <td>D:\</td>
          <td class="num">69.47 MB</td>
          <td class="num">0.00 MB</td>
          <td><img src="" title="100%" width="102" height="12" align="absmiddle">&nbsp;100%</td>
        </tr>
        <tr onmouseover="showTip(event,'\
<center><b>E:\\</b></center>\
\
<i>No disk in drive</i>\
\
',false,'TR')" onmouseleave="hideTip(event)"
ondblclick="goDrive('E:\\', '')"> 
          <td class="ico16"><img src="file2.gif" width="20" height="20"></td>
          <td>E:\</td>
          <td colspan="3" align="center"><a href="drives.html?scan=all&3000923635">click 
            to scan</a></td>
        </tr>
        <tr onmouseover="showTip(event,'\
<center><b>F:\\</b></center>\
\
<i>No disk in drive</i>\
\
',false,'TR')" onmouseleave="hideTip(event)"
ondblclick="goDrive('F:\\', '')"> 
          <td class="ico16"><img src="file2.gif" width="20" height="20"></td>
          <td>F:\</td>
          <td colspan="3" align="center"><a href="drives.html?scan=all&3000923635">click 
            to scan</a></td>
        </tr>
        <tr onmouseover="showTip(event,'\
<center><b>G:\\</b></center>\
\
<i>No disk in drive</i>\
\
',false,'TR')" onmouseleave="hideTip(event)"
ondblclick="goDrive('G:\\', '')"> 
          <td class="ico16"><img src="file2.gif" width="20" height="20"></td>
          <td>G:\</td>
          <td colspan="3" align="center"><a href="drives.html?scan=all&3000923635">click 
            to scan</a></td>
        </tr>
        <tr onmouseover="showTip(event,'\
<center><b>R:\\</b></center>\
\
<i>No disk in drive</i>\
\
',false,'TR')" onmouseleave="hideTip(event)"
ondblclick="goDrive('R:\\', '')"> 
          <td class="ico16"><img src="file2.gif" width="20" height="20"></td>
          <td>R:\</td>
          <td colspan="3" align="center"><a href="drives.html?scan=all&3000923635">click 
            to scan</a></td>
        </tr>
        <tr onmouseover="showTip(event,'\
<center><b>X:\\</b></center>\
\
<i>No disk in drive</i>\
\
',false,'TR')" onmouseleave="hideTip(event)"
ondblclick="goDrive('X:\\', '')"> 
          <td class="ico16"><img src="file2.gif" width="20" height="20"></td>
          <td>X:\</td>
          <td colspan="3" align="center"><a href="drives.html?scan=all&3000923635">click 
            to scan</a></td>
        </tr>
        <tr onmouseover="showTip(event,'\
<center><b>Z:\\</b></center>\
\
<i>No disk in drive</i>\
\
',false,'TR')" onmouseleave="hideTip(event)"
ondblclick="goDrive('Z:\\', '')"> 
          <td class="ico16"><img src="file2.gif" width="20" height="20"></td>
          <td>Z:\</td>
          <td colspan="3" align="center"><a href="drives.html?scan=all&3000923635">click 
            to scan</a></td>
        </tr>
      </tbody>
      <tfoot>
        <tr> 
          <td class="ico16">S</td>
          <td>Total</td>
          <td class="num">19,154.47 MB</td>
          <td class="num">6,360.59 MB</td>
          <td><img src="" title="67%" width="102" height="12" align="absmiddle">&nbsp;67%</td>
        </tr>
      </tfoot>
    </table>
    <br> 

<script type="text/javascript">
trows = new SelectableTableRows(document.getElementById("dlist"), false);
</script> <form name="go" action="dir.html" method="get"> <table class="inner"> <tr valign="middle"> <th>Go:</th> <td><input type="text" name="dir" value="" size="30" title="Jump to this folder"
onfocus="this.select()"><a href="javascript:dirTree('document.forms.go.dir.value')"><img src="" title="Browse" align="absmiddle" border="0"></a></td> <td class="ttd"><input type="submit" value="Go" title="Jump to this folder"></td> </tr> </table> </form> </div> </div> </body> </html> 