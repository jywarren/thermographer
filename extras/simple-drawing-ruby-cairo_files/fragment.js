
function AJAX()
{
}

AJAX.prototype={

	init: function() { 
			this.xmlhttp = null;
			if (window.XMLHttpRequest) this.xmlhttp=new XMLHttpRequest();
  			else if (window.ActiveXObject) this.xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
		},

	get: function(url, action) {
			this.init();
			if (this.xmlhttp==null) return false;
  			this.xmlhttp.onreadystatechange=action;
			this.set_action(action);
  			this.xmlhttp.open("GET",url,true);
  			this.xmlhttp.send(null);
			return true;
		},

	set_action: function(action) {
		this.xmlhttp.onreadystatechange = function(xmlhttp) { return function() {
			action(xmlhttp);
		}}(this.xmlhttp);
	},

	post: function(url,params,action) {
			this.init();
			if (this.xmlhttp==null) return false;
 			this.set_action(action);
  			this.xmlhttp.open("POST",url,true);
			this.xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
			this.xmlhttp.setRequestHeader("Content-length", params.length);
			this.xmlhttp.setRequestHeader("Connection", "close");
			this.xmlhttp.send(params);
			return true;
		},

	put: function(url,data,action) {
			this.init();
			if (this.xmlhttp==null) return false;
 			this.set_action(action);
  			this.xmlhttp.open("PUT",url,true);
			this.xmlhttp.setRequestHeader("Content-type", "text/html");
			this.xmlhttp.setRequestHeader("Content-length", data.length);
			this.xmlhttp.setRequestHeader("Connection", "close");
			this.xmlhttp.send(data);
			return true;
		}
}

function save_fragment(name)
{
	var textarea = document.getElementById(name+"-textarea");
	var ajax = new AJAX();
	ajax.put("/fragment/"+name,textarea.value, function(xmlhttp) { 
			if (xmlhttp.readyState != 4) return;
			if (xmlhttp.status != 200) alert("Warning: Save returned "+xmlhttp.status);
			else alert("Changes saved");
	});
	hide_edit_fragment(name);
}

function hide_edit_fragment(name)
{
	var form = document.getElementById(name+"-editform");
	form.style.display = "none";
	var ob = document.getElementById(name);	
	ob.style.display = "block";
	var textarea = document.getElementById(name+"-textarea");
	ob.innerHTML = textarea.value;
}

function edit_fragment(name)
{
	var ob = document.getElementById(name);
	if (ob) {
		var form = document.getElementById(name+"-editform");
		var textarea = undefined;
		if (form == undefined) {
			form = document.createElement("form")
			form.id = name+"-editform";
			textarea = document.createElement("textarea");
			textarea.id = name + "-textarea";
			textarea.className = 'editfragment';

			var preview = document.createElement("input");
			preview.type = "button";
			preview.name = "Preview";
			preview.value = "Preview";
			preview.className = "preview";
			preview.onclick = function() { hide_edit_fragment(name); return false; }

			var save = document.createElement("input");
			save.type = "submit";
			save.name = "Save";
			save.value = "Save";
			save.className = "save";
			save.onclick = function() { save_fragment(name); return false; }

			form.appendChild(textarea);
			form.appendChild(preview);
			form.appendChild(save);
			ob.parentNode.appendChild(form);
		}
		var textarea = form.getElementsByTagName('textarea')[0];
		textarea.value = ob.innerHTML;
		ob.style.display = 'none';
		form.style.display = 'block';
	}
}
