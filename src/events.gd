extends Node


# warning-ignore:unused_signal
signal commands_queued(commands: Array[Command])

# warning-ignore:unused_signal
signal player_queue_empty

# warning-ignore:unused_signal
signal level_complete

signal player_ticked

signal player_damaged(dmg)

signal player_bumped

signal announce_death(el)

signal out_of_pieces

signal piece_drawn

signal dice_roll_complete

signal request_dice_roll(faces:Array[Dice.FaceType])

signal piece_given(Piece)

signal tick_suspension_cleared(character:Character)
