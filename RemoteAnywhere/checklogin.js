<!--
function chk(f, ntlm) {
var un = f['username'].value;
var pw = f['password'].value;
var url = document.location.href
if (f.ssl) {
if (f.ssl.checked && url.substring(0, 5) == "http:")
f.action = "https:" + url.substring(5, url.lastIndexOf('/')) + "/" + f.action;
if (!f.ssl.checked && url.substring(0, 5) == "https:")
f.action = "http:" + url.substring(6, url.lastIndexOf('/')) + "/" + f.action;
}
if (ntlm || un.length > 0) {
return true;
} else {
alert('Please specify your user name.');
f['username'].focus();
return false;
}
}
//-->