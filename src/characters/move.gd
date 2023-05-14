@tool
extends State

var already_collided: Array

#
# FUNCTIONS TO INHERIT IN YOUR STATES
#

## This additionnal callback allows you to act at the end
## of an animation (after the nb of times it should play)
## If looping, is called after each loop
#func _on_anim_finished(_name):
#	pass


# This function is called when the state enters
# XSM enters the root first, the the children
func _on_enter(_args):
	owner.speed = owner.MAX_SPEED	
	already_collided.clear()

# This function is called just after the state enters
# XSM after_enters the children first, then the parent
func _after_enter(_args):
	pass


# This function is called each frame if the state is ACTIVE
# XSM updates the root first, then the children
func _on_update(_delta):
	if owner.is_at_target_position() and not owner.dead:
		change_state("idle")
	var target_direction:Vector2 = (owner.world_target_pos - owner.position).normalized()
	owner.velocity = owner.speed * target_direction * _delta
	
	var distance_to_target = owner.position.distance_to(owner.world_target_pos)
	var move_distance = owner.velocity.length()

	# Set the last movement distance to the distance to the target
	# this will make the player stop exaclty on the target
	var done :=false
	if distance_to_target < move_distance:
		owner.velocity = target_direction * distance_to_target
		done = true			
		
	var collision = owner.move_and_collide(owner.velocity)

	if collision:
		#Logger.error("Unexpected collision with:",collision.collider.name)
		var collider=collision.get_collider()
		
		# dont collice twice in the same move with the same thing
		if not already_collided.has(collider):
			already_collided.append(collider)
			if collider.is_in_group("character"):
				if not collider.dead:
					owner.get_node("sfx/sfx_combat").play()		
					owner.handle_combat_with(collider)
					return
			else:
				owner.retreat() #TODO reconsider if this should be in a state						
	#			owner.bump()#TODO consider move to state
				change_state("wobble")
				return
		
	if done and not owner.dead:
		change_state("idle")	


# This function is called each frame after all the update calls
# XSM after_updates the children first, then the root
func _after_update(_delta):
	pass


# This function is called before the State exits
# XSM before_exits the root first, then the children
func _before_exit(_args):
	pass


# This function is called when the State exits
# XSM before_exits the children first, then the root
func _on_exit(_args):
	pass


# when StateAutomaticTimer timeout()
func _state_timeout():
	pass


# Called when any other Timer times out
func _on_timeout(_name):
	pass

