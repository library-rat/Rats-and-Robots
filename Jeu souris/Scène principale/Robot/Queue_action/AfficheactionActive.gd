extends Control

signal move_player (valeur)

func _on_FileAction_change_action(action, valeur):
	emit_signal("move_player", 0)
	
	if action == null :
		$TextureRect.texture = null
		$Label.text = ""
	else :
		$TextureRect.texture = action.texture
		$Label.text = str(valeur)
		if action.name == "Mouvement" :
			emit_signal("move_player", valeur)


func _on_GameBoard_player_moved(move_range_left):
			$Label.text = str(move_range_left)
