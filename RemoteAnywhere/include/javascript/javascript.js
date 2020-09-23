function MsgServer(strData){
var obj=document.frm.txtCount;
if(obj.value=="")frmServerMsg.td_Msg.innerHTML=strData;else frmServerMsg.td_Msg.innerHTML+="<BR>"+strData;
obj.value=true;frmServerMsg.txt_focus.focus();
}

function PictureClient(strData){
var obj=document.frmClient.txtCount;
if(obj.value=="")frmClientMsg.td_Msg.innerHTML=strData;else frmClientMsg.td_Msg.innerHTML=strData;
//obj.value=true;frmClientMsg.txt_focus.focus();
}

function MsgClient(strData){
var obj=document.frmClient.txtCount;
if(obj.value=="")frmClientMsg.td_Msg.innerHTML=strData;else frmClientMsg.td_Msg.innerHTML+="<br>"+strData;
obj.value=true;frmClientMsg.txt_focus.focus();
}

function OnServer(){
var sString="<iframe src='ChatServer.htm' width=500 height=450></iframe>";
td_msg.innerHTML=sString; 
}

function OnClient(){
var sString="<iframe src='ChatClient.htm' width=500 height=450></iframe>";
td_msg.innerHTML=sString;
}