@tool
extends Node2D

@export var half_length: int = 460

@export var angle: float:
	set(value):
		angle = value
		$Rod.rotation = angle
		
		$LeftPlate.position = Vector2(-half_length, 0).rotated(angle) + $Rod.position
		$RightPlate.position = Vector2(half_length,0).rotated(angle) + $Rod.position
		

var left_plate_base: Vector2:
	get:
		return $LeftPlate/BagPosition.global_position

var right_plate_base: Vector2:
	get:
		return $RightPlate/BagPosition.global_position
	

func add_to_left_plate(child: Node):
	var previous = child.global_position
	child.get_parent().remove_child(child)
	$LeftPlate.add_child(child)
	child.global_position = previous
	

func add_to_right_plate(child: Node):
	var previous = child.global_position
	child.get_parent().remove_child(child)
	$RightPlate.add_child(child)
	child.global_position = previous
