/* $AJR(...)
 *	Asynchronous JSON Request
 * 	Only to be used with trusted URLS
 */
// TODO require method.
var $AJR = function(url, callbacks, postData, method, async) {
	var parseJSON = function(json) {
		if(json === null || json === '' || (/^\s+$/).test(json)) {
			return null;
		}
		return eval('(' + json + ')');
	};

	var encodeData = function(data) {
		if (data === null) {
			return null;
		}

		var pairs = [];
		var re = /%20/g;
		for (var name in data) {
			if (data.hasOwnProperty(name)) {
				var value = data[name].toString();
				var pair = encodeURIComponent(name).replace(re, '+') + '=' + encodeURIComponent(value).replace(re, '+');
				pairs.push(pair);
			}
		}
		return pairs.join('&');
	};

	var getRequest = function() {
		var factories = [
		function() { return new XMLHttpRequest(); },
		function() { return new ActiveXObject('Msxml2.XMLHTTP'); },
		function() { return new ActiveXObject('Microsoft.XMLHTTP'); }
		];

		for (var i = 0; i < factories.length; i++) {
			try {
				request = factories[i]();
				if (request !== null) {
					return request;
				}
			} catch(e) {
				continue;
			}
		}

		return null;
	};

	if(typeof(method) == 'undefined') {
		method = 'post';
	}

	if(typeof(callbacks) == 'undefined') {
		callbacks = {};
	}

	if(typeof(async) == 'undefined') {
		async = true;
	}

	if(typeof(postData) == 'undefined') {
		postData = null;
	}

	if (method.toLowerCase() == 'get' && postData) {
		var queryString = encodeData(postData);
		if(queryString) {
			url += ((url.indexOf('?') == -1) ? '?' : '&') + queryString;
		}
	}

	var xhr = getRequest();
	if (xhr === null) {
		throw new Error('XMLHttpRequest not supported');
	}

	xhr.onreadystatechange = function() {
		if (xhr.readyState != 4) {
			return; // request is not finished yet
		}

	/*
	* When request is finised, run appropriate callback functions (if
	* any). Callbacks are selected by the response's status code.
	* (see HTTP/1.1 Status Code Definitions:
	* http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html)
	*/
	if(xhr.status == 200) {
		if (callbacks.success) {
			// X-JSON is Prototype-specific. Without Prototype, we parse it here.
			// NOTE: In Safari, the header is X-Json. In Firefox, IE, and Opera the header is X-JSON.	
			var xJson = null;
			var headers = xhr.getAllResponseHeaders().split('\n');
			var h;
			for(var i = 0 ; i < headers.length; i++ ) {
			    h = headers[i];
			    if (h.match(/^x-json: /i)) {
					xJson = headers[i].replace(/^x-json: /i, '');
			    }
			}

			var json = parseJSON(xJson) || parseJSON(xhr.responseText);
			if (json && json.stat==="fail") {
				if (callbacks.failure) {
					callbacks.failure(json.err.code, json.err.msg);
				} else {
					alert(json.err.msg);
				}
				} else { // success
					if (xhr.responseText.length>1) {
						json = parseJSON(xhr.responseText);
					}
					callbacks.success(json);
				}	
			}
		} else if(xhr.status == 400 || xhr.status == 403 || xhr.status == 500 || xhr.status == 503) {
			if (callbacks.failure) {
				callbacks.failure(xhr.status, xhr.responseText);
			} else if (typeof console != 'undefined' && console.log) {
				console.log(xhr.statusText);
			}
		}
	}; // onreadystatechange

	xhr.open(method.toUpperCase(), url, async);
	xhr.setRequestHeader("X-Requested-With", 'XMLHttpRequest');
	
	if (method == 'post') {
		xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
	}

	xhr.send(encodeData(postData));
};
