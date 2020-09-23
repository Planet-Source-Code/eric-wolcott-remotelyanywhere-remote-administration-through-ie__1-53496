<!--
if (window != top) 
top.location.href = location.href;

/ shows or hides a DIV element
// divID - name of the DIV element
// show - true (show) or false (hide)
function winShow(ID, show) {
if (show == null || typeof(show) == 'undefined') show = true;

var el = document.getElementById(ID);
if (el) {
if (show) {
// set the object visible
el.style.visibility = "visible";

// make sure it's not off-screen...
//   top-left of the object (relative to the page)
var objLft = 0;
var objTop = 0;
for (var e = el; e.offsetParent; e = e.offsetParent) {
objLft += e.offsetLeft;
objTop += e.offsetTop;
}
//   bottom-right of the object
var objRgt = objLft + el.offsetWidth;
var objBtm = objTop + el.offsetHeight;
//   leave some margin around the object
var margin = 2;
objLft -= margin; objTop -= margin;
objRgt += margin; objBtm += margin;
//   page scroll position
var winX = document.body.scrollLeft;
var winY = document.body.scrollTop;
//   page size
var winW = document.body.clientWidth;
var winH = document.body.clientHeight;
//   move the object on-screen
if (objRgt > winX+winW) winX = objLft - winW; // right edge
if (objBtm > winY+winH) winY = objBtm - winH; // bottom edge
if (objLft < winX) winX = objLft; // left edge
if (objTop < winY) winY = objTop; // top edge
window.scrollTo(winX, winY);
} else {
// set the object invisible
el.style.visibility = "hidden";
}
}
}

function winHide(ID) {
winShow(ID, false);
}

function winSetHeight(ID, height) {
document.getElementById(ID).style.height = height + "px";
}

//-->