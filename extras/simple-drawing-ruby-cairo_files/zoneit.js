(function() {
var write_string = '<iframe src="http://widgets.dzone.com/links/widgets/zoneit.html?t=';
write_string += window.dzone_style ? window.dzone_style : '1';
write_string += '&url=';
if (window.dzone_url) write_string += encodeURIComponent(dzone_url);
else  write_string += encodeURIComponent(window.location);
if (window.dzone_title) write_string += '&title=' + encodeURIComponent(dzone_title);
else  write_string += '&title=' + encodeURIComponent(document.title);
if (window.dzone_blurb) write_string += '&description=' + encodeURIComponent(dzone_blurb);
if (window.dzone_style == '2') write_string += '" height="25" width="155" scrolling="no" frameborder="0"></iframe>';
else write_string += '" height="70" width="50" scrolling="no" frameborder="0"></iframe>';
document.write(write_string);
})()