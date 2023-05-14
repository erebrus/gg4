extends Node


signal commands_queued(commands: Array[Command])

signal player_queue_empty

signal level_complete

signal trigger_tick

signal player_damaged(dmg)

signal player_bumped

signal announce_death(el)

signal out_of_pieces

signal piece_drawn

signal dice_roll_complete

signal request_dice_roll(faces:Array[Dice.FaceType])

signal piece_given(Piece)

signal tick_suspension_cleared(character:Character)

signal trigger_discard_fetch

signal trigger_discard

signal turn_complete

signal request_keys(val:bool)

signal request_tutorial(val:String)

signal request_hide_panels()

