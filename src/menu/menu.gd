extends Control


@onready var continue_button: Button = get_node("%ContinueButton")


func _ready() -> void:
	if (Globals.can_continue()):
		continue_button.show()
	

func _on_start_button_pressed():
	Globals.start()
	

func _on_continue_button_pressed():
	Globals.continue_game()
	

func _on_quit_button_pressed():
	get_tree().quit()
	
