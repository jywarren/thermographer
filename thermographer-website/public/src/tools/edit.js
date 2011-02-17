// Default editing tool -- selection, translation, rotation, etc.
Fred.tools.edit = new Fred.Tool('select & manipulate objects',{
	selection_box: {
		points: [ {x: 0, y: 0}, {x: 0, y:0}, 
			  {x: 0, y: 0}, {x: 0, y:0} ]
	},
	select: function() {
		Fred.keys.add('g',function(){
			console.log('grouping')
			new Fred.Group(Fred.selection.members)
		})
		// here go things which must happen when the tool is deactivated
	},
	deselect: function() {
		// here go things which must happen when the tool is activated
	},
	on_dblclick: function() {
		// default edit behavior opens a menu to edit that object. The only option right now is to input code into its 'script' property.
		if (!Fred.selection.empty) {
			Fred.selection.each(function(selection) {
				var existing = selection.script || "on_mouseup: function() { console.log('hi') }"
				input = prompt("Edit this object's code:",existing)
				if (input != null) selection.script = ("{"+input+"}").evalJSON()
				Fred.attach_listeners(selection.script)
			},this)
		}
	},
	on_mousedown: function() {
		// record offset of x,y from mouse
		this.click_x = Fred.pointer_x
		this.click_y = Fred.pointer_y
		if (Fred.selection.get_under_pointer()) {
			this.dragging_object = true
			this.selection_orig_x = Fred.selection.x
			this.selection_orig_y = Fred.selection.y
		} else {
			console.log('dragging_selection')
			this.dragging_selection = true
			this.selection_box.points[0].x = Fred.pointer_x
			this.selection_box.points[0].y = Fred.pointer_y
		}
	},
	on_mousemove: function() {
		if (this.dragging_object) {
			var x = this.selection_orig_x + Fred.pointer_x - this.click_x
			var y = this.selection_orig_y + Fred.pointer_y - this.click_y
			Fred.move(Fred.selection,x,y,true)
		}
	},
	on_mouseup: function() {
		if (this.dragging_object) this.dragging_object = false
		if (this.dragging_selection) this.dragging_selection = false
	},
	on_touchstart: function(event) {
		this.on_mousedown(event)
	},
	on_touchmove: function(event) {
		this.on_mousemove(event)
	},
	on_touchend: function(event) {
		this.on_mouseup(event)
	},
	draw: function() {
		if (this.dragging_selection) {
			console.log('dragging')
			this.selection_box.points[1].x = Fred.pointer_x
			this.selection_box.points[2].x = Fred.pointer_x
			this.selection_box.points[2].y = Fred.pointer_y
			this.selection_box.points[3].y = Fred.pointer_y
			this.selection_box.width = Fred.pointer_x-this.selection_box.points[0].x
			this.selection_box.height = Fred.pointer_y-this.selection_box.points[0].y
			save()
				lineWidth(1)
				opacity(0.7)
				strokeStyle('#999')
				strokeRect(this.selection_box.points[0].x,this.selection_box.points[0].y,this.selection_box.width,this.selection_box.height)
				opacity(0.3)
				rect(this.selection_box.points[0].x,this.selection_box.points[0].y,this.selection_box.width,this.selection_box.height)
			restore()
			// For now we recalculate selection every time.
			// If that becomes inefficient, we can switch.
	
			// For now we wait until the Fred.Geometry function is written:
			this.get_selection_box()
		}
	},
	get_selection_box: function() {
		Fred.selection.clear()
		// now we must determine what we're selecting
		Fred.objects.each(function(obj){
			// Fred.Geometry.does_poly_overlap_poly(obj,this.selection_box)
			var all_inside = true
			obj.points.each(function(point){
				if (!Fred.Geometry.is_point_in_poly(this.selection_box.points,point.x,point.y)) all_inside = false
			},this)
			if (all_inside) Fred.selection.add(obj)
			obj.selected = true
		},this)
		if (Fred.selection.size() == 0) Fred.selection.clear()
	}
})
