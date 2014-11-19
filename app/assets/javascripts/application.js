// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui/tooltip
//= require turbolinks
//= require_tree .

function _repaintCursor() {
    var saveCursor = document.body.style.cursor,
        newCursor = saveCursor ? "" : "wait";
    _setCursor(newCursor);
    _setCursor(saveCursor);
}

function _setCursor(cursor) {
    var wkch = document.createElement("div");
    var wkch2 = document.createElement("div");
    wkch.style.overflow = "hidden";
    wkch.style.position = "absolute";
    wkch.style.left = "0px";
    wkch.style.top = "0px";
    wkch.style.width = "100%";
    wkch.style.height = "100%";
    wkch2.style.width = "200%";
    wkch2.style.height = "200%";
    wkch.appendChild(wkch2);
    document.body.appendChild(wkch);
    document.body.style.cursor = cursor;
    wkch.scrollLeft = 1;
    wkch.scrollLeft = 0;
    document.body.removeChild(wkch);
}
