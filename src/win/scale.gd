@tool
extends Node2D

@export var rod_length: int = 1024

@export var angle: float:
	set(value):
		angle = value
		$Rod.rotation = angle
		
		var half = (rod_length - 100) / 2
		
		$LeftPlate.position = Vector2(-half, 0).rotated(angle) + $Rod.position
		$RightPlate.position = Vector2(half,0).rotated(angle) + $Rod.position
		

func add_to_right_plate(child: Node):
	var previous = child.global_position
	child.get_parent().remove_child(child)
	$RightPlate.add_child(child)
	child.global_position = previous
