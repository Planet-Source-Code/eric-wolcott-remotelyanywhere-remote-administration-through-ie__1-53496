<!--
function formFocus() {
var form = document.forms.loginform;
if (form) {
if (form.username && form.username.focus && form.password && form.password.focus)
{
if (form.username.value == "") {
form.username.focus();
} else {
form.password.focus();
}
}
else if (form.rsaid && form.rsaid.focus && form.rsaid.value == "")
{
form.rsaid.focus();
}
else if (form.passcode && form.passcode.focus)
{
form.passcode.focus();
}
else if (form.nexttoken && form.nexttoken.focus)
{
form.nexttoken.focus();
}
else if (form.pin && form.pin.focus)
{
form.pin.focus();
}
}
}


formFocus();

//-->