extends PanelContainer

var messages:Array[String] =[
	"Place movement tokens to reach the end tile. Don't overshoot it.",
	"Don't forget you can rotate tokens.",	
	"You can walk on grass and sand Tiles.\nMountain tiles are impassable and will force you to discard a token if you try.",
	"If you collect a dice, you can get a surprise. Maybe good, maybe bad.",
	"Your success will be measured by how light your discard bag is. Try to reach the end using the least possible number of tokens. Remember: Less is more. Less is quest.",
	"See those cute creatures. They don't like you.\nIf you collide with them, you will discard your hand.",
	"Attack tokens let you defeat them and shield tokens will let you keep your hand.",
	"That cross represents a hazard tile. You can cross it, but it will force you to discard one token.",
	"Careful with quicksand. It will cost you one extra move to cross it.",
	"You now have all you need to survive your quest.\nAt the end of each level, you  will be given a choice of token to add to your bag.\nRemember keep your discard bag light. Less is more. Less is quest."
]

@onready var label:Label = $MarginContainer/Label
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func show_message(text:String)->void:
	label.text = text
	visible = true

	

