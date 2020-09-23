  var tipTimer = null;
var tipX = null;
var tipY = null;
var tipHtml = null;
var tipAnchor = null;
function showTip(e, sHtml, bHideSelects, sAnchorType) {
hideTip(e);
// find anchor element
var el = e.target || e.srcElement;
while (el.tagName != sAnchorType)
el = el.parentNode;
// remember attributes
tipX = e.clientX;
tipY = e.clientY;
tipAnchor = el;
tipHtml = sHtml;
tipHandler.hideSelects = Boolean(bHideSelects);
// set timer
tipTimer = setTimeout("showTip2()", 400);
}
function showTip2() {
// is there already a tooltip? If so, remove it
if (tipAnchor._tip)
tipHandler.hideTip(tipAnchor);
// create element and insert last into the body
tipHandler.createTip(tipAnchor, tipHtml);
// position tooltip
tipHandler.positionToolTip(tipX, tipY);
// add a listener to the blur event.
// When blurred remove tooltip and restore anchor
tipAnchor.onblur = tipHandler.anchorBlur;
tipAnchor.onkeydown = tipHandler.anchorKeyDown;
if ( navigator.userAgent.indexOf('MSIE') < 0 )	// timeout to hide tooltip
tipTimer = setTimeout("tipHandler.hideTip(tipAnchor)", 15000);
}
function hideTip(e) {
if (tipTimer) {
clearTimeout(tipTimer);
tipTimer = null;
}
// find anchor element
var el = e.target || e.srcElement;
tipHandler.hideTip(el);
}
var tipHandler = {
hideSelects:	false,
tip:			null,
showSelects:	function (bVisible) {
if (!this.hideSelects) return;
// only IE actually do something in here
var selects = [];
if (document.all)
selects = document.all.tags("SELECT");
var l = selects.length;
for	(var i = 0; i < l; i++)
selects[i].runtimeStyle.visibility = bVisible ? "" : "hidden";	
},
create:	function () {
var d = document.createElement("DIV");
d.className = "tooltip";
d.onmousedown = this.tipMouseDown;
d.onmouseup = this.tipMouseUp;
document.body.appendChild(d);		
this.tip = d;
},
createTip:	function (el, sHtml) {
if (this.tip == null) {
this.create();
}
var d = this.tip;
d.innerHTML = sHtml;
d._boundAnchor = el;
el._tip = d;
return d;
},
tipMouseDown:	function (e) {
var d = this;
var el = d._boundAnchor;
if (!e) e = event;
var t = e.target || e.srcElement;
while (t.tagName != "A" && t != d)
t = t.parentNode;
if (t == d) return;

el._onblur = el.onblur;
el.onblur = null;
},
tipMouseUp:	function () {
var d = this;
var el = d._boundAnchor;
el.onblur = el._onblur;
el._onblur = null;
el.focus();
},	
anchorBlur:	function (e) {
var el = this;
tipHandler.hideTip(el);
},
anchorKeyDown:	function (e) {
if (!e) e = window.event
if (e.keyCode == 27) {
tipHandler.hideTip(this);
}
},
removeTip:	function (d) {
d._boundAnchor = null;
d.style.filter = "none";
d.innerHTML = "";
d.onmousedown = null;
d.onmouseup = null;
d.parentNode.removeChild(d);
},
hideTip:	function (el) {
var d = el._tip;
if (d != null) {
d.style.visibility = "hidden";
el.onblur = null;
el._onblur = null;
el._tip = null;
el.onkeydown = null;

this.showSelects(true);
}
},
positionToolTip:	function (clientX, clientY) {
this.showSelects(false);		
var scroll = this.getScroll();
var d = this.tip;
// width
if (d.offsetWidth >= scroll.width)
d.style.width = scroll.width - 10 + "px";
else
d.style.width = "";
// left
if (clientX > scroll.width - d.offsetWidth)
d.style.left = scroll.width - d.offsetWidth + scroll.left + "px";
else
d.style.left = clientX - 2 + scroll.left + "px";
// top
if (clientY + d.offsetHeight + 18 < scroll.height)
d.style.top = clientY + 18 + scroll.top + "px";
else if (clientY - d.offsetHeight > 0)
d.style.top = clientY + scroll.top - d.offsetHeight + "px";
else
d.style.top = scroll.top + 5 + "px";

d.style.visibility = "visible";
},
getScroll:	function () {
if (document.all && typeof document.body.scrollTop != "undefined") {
var ieBox = document.compatMode != "CSS1Compat";
var cont = ieBox ? document.body : document.documentElement;
return {
left:	cont.scrollLeft,
top:	cont.scrollTop,
width:	cont.clientWidth,
height:	cont.clientHeight
};
} else {
return {
left:	window.pageXOffset,
top:	window.pageYOffset,
width:	window.innerWidth,
height:	window.innerHeight
};
}

}
};