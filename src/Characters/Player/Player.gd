extends Character


@export var enable_debug_movement:=true

func control(delta:float)->void:	
	if enable_debug_movement:		
		if Input.is_action_just_pressed("ui_up"):
#			new_direction.y = -1
			commands.append(Vector2i(0,-1))
		elif Input.is_action_just_pressed("ui_down"):
#			new_direction.y = 1
			commands.append(Vector2i(0,1))
		elif Input.is_action_just_pressed("ui_left"):
			commands.append(Vector2i(-1, 0))
#			new_direction.x = -1
		elif Input.is_action_just_pressed("ui_right"):
#			new_direction.x = 1
			commands.append(Vector2i(1, 0))		
	else:
		super.control(delta)
		
		

