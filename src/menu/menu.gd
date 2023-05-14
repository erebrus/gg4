extends Control


@onready var continue_button: Button = get_node("%ContinueButton")


func _ready() -> void:
	if (Globals.can_continue()):
		continue_button.show()
	Globals.stop_game_music()
	$menu_music.volume_db=-80
	$menu_music.play()
	var tween:=create_tween().set_trans(Tween.TRANS_LINEAR)
	tween.tween_property($menu_music, "volume_db",-15.0, 1)
	

func _turn_off_music():
	var tween:=create_tween().set_trans(Tween.TRANS_LINEAR)
	tween.tween_property($menu_music, "volume_db",-80.0, 1)
	await tween.finished
	$menu_music.stop()
	

func _on_tutorial_button_pressed():
	Globals.tutorial()
	_turn_off_music()
	


func _on_start_button_pressed():
	Globals.start()
	_turn_off_music()
	

func _on_continue_button_pressed():
	Globals.continue_game()
	

func _on_quit_button_pressed():
	get_tree().quit()
	


