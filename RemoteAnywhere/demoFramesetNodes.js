USETEXTLINKS = 1  //replace 0 with 1 for hyperlinks
STARTALLOPEN = 0 //replace 0 with 1 to show the whole tree
ICONPATH = '' //change if the gif's folder is a subfolder, for example: 'images/'

foldersTree = gFld("<(-ComputerName-)>", "demoFramesetRightFrame.html")
  foldersTree.iconSrc = ICONPATH + "home.bmp"
  aux1 = insFld(foldersTree, gFld("Home", "demoFramesetRightFrame.html"))
  aux1.iconSrc = ICONPATH + "Home.bmp"
  aux1.iconSrcClosed = ICONPATH + "Home.bmp"
  
  aux1 = insFld(foldersTree, gFld("Remote Control", "desktop.htm"))
  aux1.iconSrc = ICONPATH + "remote.gif"
  aux1.iconSrcClosed = ICONPATH + "remote.gif"
  
  aux1 = insFld(foldersTree, gFld("File Transfer", "demoFramesetRightFrame.html"))
  aux1.iconSrc = ICONPATH + "file.gif"
  aux1.iconSrcClosed = ICONPATH + "file.gif"

  aux1 = insFld(foldersTree, gFld("Help Desk", "demoFramesetRightFrame.html"))
  aux1.iconSrc = ICONPATH + "help.gif"
  aux1.iconSrcClosed = ICONPATH + "help.gif"
  
  aux1 = insFld(foldersTree, gLnk("T", "Log Off", "ExecCommand?Log_Off"))
  aux1.iconSrc = ICONPATH + "help.gif"
  aux1.iconSrcClosed = ICONPATH + "help.gif"
  
  aux1 = insFld(foldersTree, gFld("Computer Management", "demoFramesetRightFrame.html"))
  aux1.iconSrc = ICONPATH + "config.gif"
  aux1.iconSrcClosed = ICONPATH + "config.gif"
  
	aux2 = insFld(aux1, gFld("File Manager", "filemanager.asp"))
    aux2.iconSrc = ICONPATH + "hand.gif"
	aux2.iconSrcClosed = ICONPATH + "hand.gif"  
	
	aux2 = insFld(aux1, gFld("User Manager", "http://www.treeview.net/treemenu/demopics/beenthere_america.gif"))
    aux2.iconSrc = ICONPATH + "hand.gif"
	aux2.iconSrcClosed = ICONPATH + "hand.gif"  
	
	aux2 = insFld(aux1, gFld("Services", "http://www.treeview.net/treemenu/demopics/beenthere_america.gif"))
    aux2.iconSrc = ICONPATH + "hand.gif"
	aux2.iconSrcClosed = ICONPATH + "hand.gif"  
	
	aux2 = insFld(aux1, gFld("Processes", "http://www.treeview.net/treemenu/demopics/beenthere_america.gif"))
    aux2.iconSrc = ICONPATH + "hand.gif"
	aux2.iconSrcClosed = ICONPATH + "hand.gif"  
	
	aux2 = insFld(aux1, gFld("Registry Editor", "http://www.treeview.net/treemenu/demopics/beenthere_america.gif"))
    aux2.iconSrc = ICONPATH + "hand.gif"
	aux2.iconSrcClosed = ICONPATH + "hand.gif"  
	
	aux2 = insFld(aux1, gFld("Command Prompt", "dos.htm"))
    aux2.iconSrc = ICONPATH + "hand.gif"
	aux2.iconSrcClosed = ICONPATH + "hand.gif" 
	
	aux2 = insFld(aux1, gFld("Reboot", "http://www.treeview.net/treemenu/demopics/beenthere_america.gif"))
    aux2.iconSrc = ICONPATH + "hand.gif"
	aux2.iconSrcClosed = ICONPATH + "hand.gif" 
	
  aux1 = insFld(foldersTree, gFld("Computer Settings", "javascript:parent.op()"))
  aux1.iconSrc = ICONPATH + "settings.gif"
  aux1.iconSrcClosed = ICONPATH + "settings.gif"
  
  aux1 = insFld(foldersTree, gFld("Server Functions", "demoFramesetRightFrame.html"))
  aux1.iconSrc = ICONPATH + "server.gif"
  aux1.iconSrcClosed = ICONPATH + "server.gif"
  
	aux2 = insFld(aux1, gFld("Stop Server", "ExecCommand?Server_Stop"))
    aux2.iconSrc = ICONPATH + "hand.gif"
	aux2.iconSrcClosed = ICONPATH + "hand.gif"  
	
	aux2 = insFld(aux1, gFld("Server Information", "ExecCommand?Server_Info"))
    aux2.iconSrc = ICONPATH + "hand.gif"
	aux2.iconSrcClosed = ICONPATH + "hand.gif"  
	
  //aux1 = insFld(foldersTree, gFld("Server Functions", "javascript:parent.op()"))
  //aux1.iconSrc = ICONPATH + "server.gif"
  //aux1.iconSrcClosed = ICONPATH + "server.gif"
//      insDoc(aux1, gLnk("R", "Right frame", "http://www.treeview.net/treemenu/demopics/beenthere_edinburgh.gif"))
      //insDoc(aux1, gLnk("B", "New window", "http://www.treeview.net/treemenu/demopics/beenthere_london.jpg"))
  //    insDoc(aux1, gLnk("T", "Whole window", "http://www.treeview.net/treemenu/demopics/beenthere_munich.jpg"))
    //  insDoc(aux1, gLnk("S", "This frame", "http://www.treeview.net/treemenu/demopics/beenthere_athens.jpg"))
      //insDoc(aux1, gLnk("S", "JavaScript link", "javascript:alert(\\\'This JavaScript link simply calls the built-in alert function,\\\\nbut you can define your own function.\\\')"))



