// window.webcam.getCameraList()
$.ajaxSetup ({ cache: false }); 
var ajax_load = "<img src='/images/spinner-small.gif' alt='loading...' />";

var $T

$T = {
	data: null,
	pos: 0,
        // height and width of the output stream
        // container
	width: 640,
	height: 480,
        //width: 1280,
        //height: 720,
	initialize: function(args) {
		this.mobile = args['mobile'] || false
		this.calibrated = args['calibrated'] || false
		if (args['height']) {
			this.options.height = args['height'] 
			this.options.width = args['width']
		}
		getUserMedia(this.options, this.success, this.deviceError)
		window.webcam = this.options
		this.canvas = document.getElementById("canvas")
		this.buffer = document.getElementById("buffer")
		this.canvas.width = this.width
		this.canvas.height = this.height
		this.buffer.width = this.width
		this.buffer.height = this.height
		this.ctx = this.canvas.getContext("2d")
		this.bctx = this.buffer.getContext("2d")
	},
        success: function (stream) {
		//console.log('success')
                if ($T.options.context === 'webrtc') {
			//console.log('webrtc')
                        var video = $T.options.videoEl,
                                vendorURL = window.URL || window.webkitURL;
                        video.src = vendorURL ? vendorURL.createObjectURL(stream) : stream;
                        video.onerror = function () {
                                stream.stop();
                        	streamError();
                	};
                } else {
                //flash context
			console.log('flash or something else')
        	}
        },
	deviceError: function (error) {
		console.log(error)
	},
	// options contains the configuration information for the shim
	// it allows us to specify the width and height of the video
	// output we're working with, the location of the fallback swf,
	// events that are triggered onCapture and onSave (for the fallback)
	// and so on.
	options: {

            "audio": true,
            "video": true,

            // the element (by id) you wish to apply
            el: "webcam",

            extern: null,
            append: true,

            // the recommended mode to be used is 'callback '
            // where a callback is executed once data
            // is available
            mode: "callback",

            // the flash fallback Url
            swffile: "/javascripts/webcam-fallback/jscam_canvas_only.swf",

            // quality of the fallback stream
            quality: 100,
            context: "",

            debug: function () {},

            // callback for capturing the fallback stream
            onCapture: function () {
                window.webcam.save();
            },
            onTick: function () {},

            // callback for saving the stream, useful for
            // relaying data further.
	    onSave: function (data) {
		// in progress for Flash now
		// seems to execute 240 times... once for each column?
		var col = data.split(";"),
			img = $T.canvas.getContext('2d').getImageData(0, 0, this.width, this.height);
			tmp = null,
			w = this.width,
			h = this.height;

		for (var i = 0; i < w; i++) { 
			tmp = parseInt(col[i], 10);
			img.data[$T.pos + 0] = (tmp >> 16) & 0xff;
			img.data[$T.pos + 1] = (tmp >> 8) & 0xff;
			img.data[$T.pos + 2] = tmp & 0xff;
			img.data[$T.pos + 3] = 0xff;
			$T.pos += 4;
		}
		
		if ($T.pos >= 4 * w * $T.sample_height) { 
			$T.canvas.getContext('2d').putImageData(img, 0, 0);
			$T.ctx.drawImage(img, 0, 0);
			$T.pos = 0;
		}

	    },
	    onLoad: function () {}
        },

	capture: function() {
		if ($T.options.context === 'webrtc') {
			var video = document.getElementsByTagName('video')[0]; 
			//copy from video stream into buffer
			$T.bctx.drawImage(video, 0, 0);
		} else if($T.options.context === 'flash'){
			window.webcam.capture();
		} else {
			console.log('No context was supplied to getSnapshot()');
		}
		img = $T.ctx.getImageData(0,0,$T.width,$T.height)
		bfr = $T.bctx.getImageData(0,0,$T.width,$T.height)

		for (i=0;i<(4*$T.width*$T.height);i++) { 
			r = img.data[i]
			//g = img.data[i+1]
			//b = img.data[i+2]
			br = bfr.data[i]
			//bg = bfr.data[i+1]
			//bb = bfr.data[i+2]
			// we can make this more efficient with byte math:
			if (br > r) img.data[i] = br
			//if (bg > g) img.data[i+1] = bg
			//if (bb > b) img.data[i+2] = bb
		} 
		
		$T.ctx.putImageData(img,0,0)

	},
	geolocate: function() {
		if (navigator.geolocation) {
			navigator.geolocation.getCurrentPosition($T.setGeolocation)
			return true
		}
	},
	setGeolocation: function(loc) {
                if (loc.coords) {
                        $('#lat').val(loc.coords.latitude)
                        $('#lon').val(loc.coords.longitude)
                }
                else {
                        $('#lat').val(loc.latitude)
                        $('#lon').val(loc.longitude)
                }
	},
	saveImage: function() {
		//temp quick fix:
		window.location = $T.ctx.getDataUrl()
		is_c = $('#is_calibration')
		if (is_c.checked) {
			$('#choose_calibration').hide()
			is_c.val(true) 
		} else {
			$('#choose_calibration').show()
			is_c.val(false)
			$('#calibration_id').val($T.calibration_id)
		}
		$('#dataurl').val($T.canvas.toDataURL())
		$('#geotag').val($('#geotag-toggle').val() == "on")
		$('#save').show()
		$('#capture').hide()
		setTimeout(function() { if ($('#geotag-toggle').val() == "on") $T.geolocate() },500)
	},
	cancelSave: function() {
		$('#geotag').val('false')
		$('#lon').val('')
		$('#lat').val('')
	},
        /**
         * Returns a canvas object of any rect from the offered canvas
         */
        excerptCanvas: function(x1,y1,x2,y2,source) {
                source = source || $C
                var width = x2-x1, height = y2-y1
                $('body').append("<canvas style='' id='excerptCanvas'></canvas>")
                var element = $('#excerptCanvas')[0]
                element.width = width
                element.height = height
                var excerptCanvasContext = element.getContext('2d')
                var sourcedata = source.getImageData(x1,y1,width,height)
                excerptCanvasContext.putImageData(sourcedata,0,0)
                return excerptCanvasContext
        }
}
